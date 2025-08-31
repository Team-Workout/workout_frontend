import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/core/services/api_service.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SettingsRepository(dio);
});

class SettingsRepository {
  final Dio _dio;

  SettingsRepository(this._dio);

  Future<void> updateWorkoutLogAccess({required bool isOpen}) async {
    try {
      await _dio.put(
        '/member/me/settings/workout-log-access',
        data: {
          'isOpenWorkoutRecord': isOpen,
        },
      );
    } catch (e) {
      throw Exception('운동일지 공개 설정 변경 실패: $e');
    }
  }
}
