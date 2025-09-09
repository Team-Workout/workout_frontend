import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/workout_log_models.dart';

class LocalStorageService {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = '$databasesPath/workout_local.db';
    print('🗄️ 데이터베이스 경로: $path');
    
    return await openDatabase(
      path,
      version: 2, // 버전을 2로 올림 (세트 메모 컬럼 추가)
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    print('🗄️ 데이터베이스 생성 시작 - 버전: $version');
    
    // 운동 기록 테이블
    await db.execute('''
      CREATE TABLE workout_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_date TEXT NOT NULL,
        user_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        synced_to_server INTEGER DEFAULT 0
      )
    ''');
    print('🗄️ workout_logs 테이블 생성 완료');
    
    // 운동 상세 테이블
    await db.execute('''
      CREATE TABLE workout_exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_log_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        exercise_name TEXT NOT NULL,
        log_order INTEGER NOT NULL,
        memo TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (workout_log_id) REFERENCES workout_logs (id) ON DELETE CASCADE
      )
    ''');
    print('🗄️ workout_exercises 테이블 생성 완료');
    
    // 세트 정보 테이블
    await db.execute('''
      CREATE TABLE workout_sets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_exercise_id INTEGER NOT NULL,
        set_number INTEGER NOT NULL,
        weight REAL NOT NULL,
        reps INTEGER NOT NULL,
        memo TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (workout_exercise_id) REFERENCES workout_exercises (id) ON DELETE CASCADE
      )
    ''');
    print('🗄️ workout_sets 테이블 생성 완료');
    
    print('🗄️ 모든 테이블 생성 완료');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('🗄️ 데이터베이스 업그레이드 시작 - $oldVersion -> $newVersion');
    
    if (oldVersion < 2) {
      // 버전 1에서 2로 업그레이드: workout_sets 테이블에 memo 컬럼 추가
      try {
        await db.execute('ALTER TABLE workout_sets ADD COLUMN memo TEXT');
        print('🗄️ workout_sets 테이블에 memo 컬럼 추가 완료');
      } catch (e) {
        print('🗄️ memo 컬럼 추가 실패 (이미 존재할 수 있음): $e');
      }
    }
    
    print('🗄️ 데이터베이스 업그레이드 완료');
  }
  
  // 운동 기록 로컬 저장
  Future<int> saveWorkoutLog(WorkoutLogRequest request, String userId) async {
    try {
      print('🗄️ DB 연결 시작');
      final db = await database;
      final now = DateTime.now().toIso8601String();
      
      print('🗄️ 트랜잭션 시작');
      return await db.transaction((txn) async {
        try {
          // 1. 기존 데이터 삭제 (덮어쓰기 위해)
          print('🗄️ 기존 데이터 삭제 시작 - 날짜: ${request.workoutDate}');
          
          // 해당 날짜의 기존 workout_log_id들을 조회
          final existingLogs = await txn.query(
            'workout_logs',
            columns: ['id'],
            where: 'workout_date = ? AND user_id = ?',
            whereArgs: [request.workoutDate, userId],
          );
          
          // 기존 데이터 삭제
          for (var log in existingLogs) {
            final workoutLogId = log['id'] as int;
            print('🗄️ 기존 workout_log 삭제 - ID: $workoutLogId');
            
            // 세트 삭제
            await txn.delete('workout_sets', 
              where: 'workout_exercise_id IN (SELECT id FROM workout_exercises WHERE workout_log_id = ?)', 
              whereArgs: [workoutLogId]);
            
            // 운동 삭제  
            await txn.delete('workout_exercises', 
              where: 'workout_log_id = ?', 
              whereArgs: [workoutLogId]);
            
            // 운동 기록 삭제
            await txn.delete('workout_logs', 
              where: 'id = ?', 
              whereArgs: [workoutLogId]);
          }
          print('🗄️ 기존 데이터 삭제 완료');

          // 2. 새로운 운동 기록 저장
          print('🗄️ workout_logs 테이블에 저장 시작');
          final workoutLogData = {
            'workout_date': request.workoutDate,
            'user_id': userId,
            'created_at': now,
            'updated_at': now,
            'synced_to_server': 0, // 아직 서버에 동기화되지 않음
          };
          print('🗄️ workout_logs 데이터: $workoutLogData');
          
          final workoutLogId = await txn.insert('workout_logs', workoutLogData);
          print('🗄️ workout_logs 저장 성공 - ID: $workoutLogId');
          
          // 3. 각 운동 저장
          for (var exerciseIndex = 0; exerciseIndex < request.workoutExercises.length; exerciseIndex++) {
            final exercise = request.workoutExercises[exerciseIndex];
            print('🗄️ 운동 $exerciseIndex 저장 시작 - exerciseId: ${exercise.exerciseId}');
            
            final exerciseData = {
              'workout_log_id': workoutLogId,
              'exercise_id': exercise.exerciseId,
              'exercise_name': exercise.exerciseName ?? 'Exercise ${exercise.exerciseId}', // 실제 운동 이름 사용
              'log_order': exercise.logOrder,
              'memo': exercise.exerciseMemo ?? '', // 실제 운동 메모 사용
              'created_at': now,
            };
            print('🗄️ workout_exercises 데이터: $exerciseData');
            
            final exerciseDbId = await txn.insert('workout_exercises', exerciseData);
            print('🗄️ workout_exercises 저장 성공 - ID: $exerciseDbId');
            
            // 4. 각 세트 저장
            for (var setIndex = 0; setIndex < exercise.workoutSets.length; setIndex++) {
              final set = exercise.workoutSets[setIndex];
              print('🗄️ 세트 $setIndex 저장 시작');
              
              final setData = {
                'workout_exercise_id': exerciseDbId,
                'set_number': set.setNumber,
                'weight': set.weight,
                'reps': set.reps,
                'memo': set.feedback, // API 모델의 feedback을 memo로 저장
                'created_at': now,
              };
              print('🗄️ workout_sets 데이터: $setData');
              
              await txn.insert('workout_sets', setData);
              print('🗄️ 세트 $setIndex 저장 성공');
            }
          }
          
          print('🗄️ 모든 데이터 저장 완료');
          return workoutLogId;
        } catch (txnError, stackTrace) {
          print('❌ 트랜잭션 내부 에러: $txnError');
          print('❌ 트랜잭션 스택트레이스: $stackTrace');
          rethrow;
        }
      });
    } catch (e, stackTrace) {
      print('❌ saveWorkoutLog 전체 에러: $e');
      print('❌ saveWorkoutLog 스택트레이스: $stackTrace');
      rethrow;
    }
  }
  
  // 특정 날짜의 운동 기록 조회
  Future<List<Map<String, dynamic>>> getWorkoutLogsByDate(String date) async {
    final db = await database;
    
    final workoutLogs = await db.query(
      'workout_logs',
      where: 'workout_date = ?',
      whereArgs: [date],
      orderBy: 'created_at DESC',
    );
    
    List<Map<String, dynamic>> result = [];
    
    for (var log in workoutLogs) {
      final exercises = await db.rawQuery('''
        SELECT we.*, ws.set_number, ws.weight, ws.reps, ws.memo as set_memo
        FROM workout_exercises we
        LEFT JOIN workout_sets ws ON we.id = ws.workout_exercise_id
        WHERE we.workout_log_id = ?
        ORDER BY we.log_order, ws.set_number
      ''', [log['id']]);
      
      // 운동별로 세트 정보 그룹핑
      Map<int, Map<String, dynamic>> exerciseMap = {};
      
      for (var exercise in exercises) {
        // 안전한 타입 변환
        final exerciseIdValue = exercise['id'];
        int exerciseId;
        if (exerciseIdValue is int) {
          exerciseId = exerciseIdValue;
        } else if (exerciseIdValue is String) {
          exerciseId = int.tryParse(exerciseIdValue) ?? 0;
        } else {
          exerciseId = 0;
        }
        
        if (!exerciseMap.containsKey(exerciseId)) {
          exerciseMap[exerciseId] = {
            'id': exerciseId,
            'exercise_id': _safeInt(exercise['exercise_id']),
            'exercise_name': exercise['exercise_name']?.toString() ?? '',
            'log_order': _safeInt(exercise['log_order']),
            'memo': exercise['memo']?.toString() ?? '',
            'sets': <Map<String, dynamic>>[],
          };
        }
        
        if (exercise['set_number'] != null) {
          exerciseMap[exerciseId]!['sets'].add({
            'set_number': _safeInt(exercise['set_number']),
            'weight': _safeDouble(exercise['weight']),
            'reps': _safeInt(exercise['reps']),
            'memo': exercise['set_memo']?.toString() ?? '',
          });
        }
      }
      
      result.add({
        'id': _safeInt(log['id']),
        'workout_date': log['workout_date']?.toString() ?? '',
        'user_id': log['user_id']?.toString() ?? '',
        'created_at': log['created_at']?.toString() ?? '',
        'updated_at': log['updated_at']?.toString() ?? '',
        'synced_to_server': _safeInt(log['synced_to_server']) == 1,
        'exercises': exerciseMap.values.toList(),
      });
    }
    
    return result;
  }
  
  // 서버 동기화 상태 업데이트
  Future<void> markAsSynced(int workoutLogId) async {
    final db = await database;
    await db.update(
      'workout_logs',
      {'synced_to_server': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [workoutLogId],
    );
  }
  
  // 동기화되지 않은 운동 기록 조회
  Future<List<Map<String, dynamic>>> getUnsyncedWorkoutLogs() async {
    final db = await database;
    return await db.query(
      'workout_logs',
      where: 'synced_to_server = ?',
      whereArgs: [0],
      orderBy: 'created_at ASC',
    );
  }
  
  // 특정 월의 운동 기록이 있는 날짜들 조회 (달력용)
  Future<List<String>> getWorkoutDatesInMonth(String year, String month) async {
    final db = await database;
    final datePattern = '$year-${month.padLeft(2, '0')}%';
    
    final result = await db.query(
      'workout_logs',
      columns: ['workout_date'],
      where: 'workout_date LIKE ?',
      whereArgs: [datePattern],
      distinct: true,
      orderBy: 'workout_date',
    );
    
    return result.map((row) => row['workout_date'] as String).toList();
  }
  
  // 특정 운동 기록 삭제
  Future<void> deleteWorkoutLog(int workoutLogId) async {
    final db = await database;
    await db.transaction((txn) async {
      // 세트 정보 삭제 (CASCADE로 자동 삭제되지만 명시적으로)
      await txn.rawDelete('''
        DELETE FROM workout_sets 
        WHERE workout_exercise_id IN (
          SELECT id FROM workout_exercises WHERE workout_log_id = ?
        )
      ''', [workoutLogId]);
      
      // 운동 상세 삭제
      await txn.delete('workout_exercises', 
        where: 'workout_log_id = ?', 
        whereArgs: [workoutLogId]);
      
      // 운동 기록 삭제
      await txn.delete('workout_logs', 
        where: 'id = ?', 
        whereArgs: [workoutLogId]);
    });
  }

  // 특정 날짜의 모든 운동 기록 삭제
  Future<void> deleteWorkoutLogsByDate(String date) async {
    final db = await database;
    
    // 해당 날짜의 workout_log_id들을 먼저 조회
    final workoutLogs = await db.query(
      'workout_logs',
      columns: ['id'],
      where: 'workout_date = ?',
      whereArgs: [date],
    );
    
    // 각 workout_log_id에 대해 삭제 수행
    for (var log in workoutLogs) {
      final workoutLogId = log['id'] as int;
      await deleteWorkoutLog(workoutLogId);
    }
  }

  // 데이터베이스 완전 초기화 (디버깅용)
  Future<void> clearAllData() async {
    try {
      final db = await database;
      print('🗑️ 모든 데이터 삭제 시작');
      
      await db.transaction((txn) async {
        await txn.delete('workout_sets');
        await txn.delete('workout_exercises');
        await txn.delete('workout_logs');
      });
      
      print('🗑️ 모든 데이터 삭제 완료');
    } catch (e) {
      print('❌ 데이터 삭제 실패: $e');
    }
  }

  // 데이터베이스 상태 확인 (디버깅용)
  Future<void> checkDatabaseStatus() async {
    try {
      final db = await database;
      
      // 모든 운동기록 날짜 출력
      final allLogs = await db.query('workout_logs', columns: ['workout_date', 'created_at']);
      print('📅 저장된 운동기록 날짜들:');
      for (var log in allLogs) {
        print('   - ${log['workout_date']} (생성일: ${log['created_at']})');
      }
      
      // 테이블 존재 확인
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table';"
      );
      print('🗄️ 존재하는 테이블들: $tables');
      
      // workout_sets 테이블 스키마 확인
      final setSchema = await db.rawQuery(
        "PRAGMA table_info(workout_sets);"
      );
      print('🗄️ workout_sets 테이블 스키마: $setSchema');
      
      // 각 테이블의 레코드 수 확인
      final logCount = await db.rawQuery("SELECT COUNT(*) as count FROM workout_logs");
      final exerciseCount = await db.rawQuery("SELECT COUNT(*) as count FROM workout_exercises");
      final setCount = await db.rawQuery("SELECT COUNT(*) as count FROM workout_sets");
      
      print('🗄️ 레코드 수 - logs: ${logCount.first['count']}, exercises: ${exerciseCount.first['count']}, sets: ${setCount.first['count']}');
      
    } catch (e, stackTrace) {
      print('❌ 데이터베이스 상태 확인 실패: $e');
      print('❌ 스택트레이스: $stackTrace');
    }
  }

  // 데이터베이스 완전 재생성 (심각한 오류 시 사용)
  Future<void> recreateDatabase() async {
    try {
      print('🗄️ 데이터베이스 완전 재생성 시작');
      
      final databasesPath = await getDatabasesPath();
      final path = '$databasesPath/workout_local.db';
      
      // 기존 데이터베이스 연결 닫기
      if (_database != null) {
        await _database!.close();
        _database = null;
      }
      
      // 데이터베이스 파일 삭제
      await deleteDatabase(path);
      print('🗄️ 기존 데이터베이스 파일 삭제 완료');
      
      // 새 데이터베이스 생성
      _database = await _initDatabase();
      print('🗄️ 새 데이터베이스 생성 완료');
      
    } catch (e, stackTrace) {
      print('❌ 데이터베이스 재생성 실패: $e');
      print('❌ 스택트레이스: $stackTrace');
      rethrow;
    }
  }

  
  // 기간별 운동 기록 조회 (통계용)
  Future<List<Map<String, dynamic>>> getWorkoutLogsByDateRange(
      String startDate, String endDate) async {
    final db = await database;
    
    final workoutLogs = await db.query(
      'workout_logs',
      where: 'workout_date >= ? AND workout_date <= ?',
      whereArgs: [startDate, endDate],
      orderBy: 'workout_date ASC',
    );
    
    List<Map<String, dynamic>> result = [];
    
    for (var log in workoutLogs) {
      final exercises = await db.rawQuery('''
        SELECT we.*, ws.set_number, ws.weight, ws.reps, ws.memo as set_memo
        FROM workout_exercises we
        LEFT JOIN workout_sets ws ON we.id = ws.workout_exercise_id
        WHERE we.workout_log_id = ?
        ORDER BY we.log_order, ws.set_number
      ''', [log['id']]);
      
      // 운동별로 세트 정보 그룹핑
      Map<int, Map<String, dynamic>> exerciseMap = {};
      
      for (var exercise in exercises) {
        final exerciseIdValue = exercise['id'];
        int exerciseId;
        if (exerciseIdValue is int) {
          exerciseId = exerciseIdValue;
        } else if (exerciseIdValue is String) {
          exerciseId = int.tryParse(exerciseIdValue) ?? 0;
        } else {
          exerciseId = 0;
        }
        
        if (!exerciseMap.containsKey(exerciseId)) {
          exerciseMap[exerciseId] = {
            'id': exerciseId,
            'exercise_id': _safeInt(exercise['exercise_id']),
            'exercise_name': exercise['exercise_name']?.toString() ?? '',
            'log_order': _safeInt(exercise['log_order']),
            'memo': exercise['memo']?.toString() ?? '',
            'sets': <Map<String, dynamic>>[],
          };
        }
        
        // 세트가 있는 경우만 추가
        if (exercise['set_number'] != null) {
          (exerciseMap[exerciseId]!['sets'] as List<Map<String, dynamic>>).add({
            'set_number': _safeInt(exercise['set_number']),
            'weight': _safeDouble(exercise['weight']),
            'reps': _safeInt(exercise['reps']),
            'memo': exercise['set_memo']?.toString() ?? '',
          });
        }
      }
      
      result.add({
        'id': log['id'],
        'workout_date': log['workout_date'],
        'user_id': log['user_id'],
        'log_feedback': log['log_feedback'],
        'created_at': log['created_at'],
        'updated_at': log['updated_at'],
        'synced_to_server': log['synced_to_server'],
        'exercises': exerciseMap.values.toList(),
      });
    }
    
    return result;
  }

  // 안전한 타입 변환 헬퍼 메서드들
  int _safeInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
  
  double _safeDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

// Provider
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});