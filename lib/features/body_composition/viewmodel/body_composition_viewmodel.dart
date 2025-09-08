import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/api_service.dart';
import '../model/body_composition_model.dart';
import '../model/body_image_model.dart';
import '../repository/body_composition_repository.dart';

final bodyCompositionRepositoryProvider = Provider<BodyCompositionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return BodyCompositionRepository(dio);
});

enum DateRangeType { oneWeek, oneMonth, threeMonths, sixMonths, oneYear }

class DateRangeNotifier extends StateNotifier<DateRange> {
  DateRangeNotifier() : super(DateRange(
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    endDate: DateTime.now(),
    selectedType: DateRangeType.oneMonth,
  ));

  void updateDateRange(DateTime startDate, DateTime endDate, {DateRangeType? selectedType}) {
    state = DateRange(
      startDate: startDate, 
      endDate: endDate,
      selectedType: selectedType ?? state.selectedType,
    );
  }

  void setQuickDateRange(DateRangeType type) {
    final now = DateTime.now();
    DateTime startDate;
    
    switch (type) {
      case DateRangeType.oneWeek:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case DateRangeType.oneMonth:
        startDate = now.subtract(const Duration(days: 30));
        break;
      case DateRangeType.threeMonths:
        startDate = now.subtract(const Duration(days: 90));
        break;
      case DateRangeType.sixMonths:
        startDate = now.subtract(const Duration(days: 180));
        break;
      case DateRangeType.oneYear:
        startDate = now.subtract(const Duration(days: 365));
        break;
    }
    
    state = DateRange(
      startDate: startDate,
      endDate: now,
      selectedType: type,
    );
  }
}

class DateRange {
  final DateTime startDate;
  final DateTime endDate;
  final DateRangeType selectedType;

  DateRange({
    required this.startDate, 
    required this.endDate, 
    required this.selectedType
  });
}

final dateRangeProvider = StateNotifierProvider<DateRangeNotifier, DateRange>((ref) {
  return DateRangeNotifier();
});

final bodyCompositionListProvider = FutureProvider<List<BodyComposition>>((ref) async {
  final repository = ref.watch(bodyCompositionRepositoryProvider);
  final dateRange = ref.watch(dateRangeProvider);
  
  final startDate = dateRange.startDate.toIso8601String().split('T')[0];
  final endDate = dateRange.endDate.toIso8601String().split('T')[0];
  
  return await repository.getBodyCompositionInfo(
    startDate: startDate,
    endDate: endDate,
  );
});

final bodyStatsProvider = Provider<BodyStats?>((ref) {
  final bodyCompositionAsync = ref.watch(bodyCompositionListProvider);
  
  return bodyCompositionAsync.when(
    data: (compositions) {
      if (compositions.isEmpty) return null;
      
      compositions.sort((a, b) => b.measurementDate.compareTo(a.measurementDate));
      
      final latest = compositions.first;
      final previous = compositions.length > 1 ? compositions[1] : null;
      
      final currentWeight = latest.weightKg;
      final weightChange = previous != null ? currentWeight - previous.weightKg : 0.0;
      
      final bodyFatPercentage = (latest.fatKg / latest.weightKg) * 100;
      final previousFatPercentage = previous != null 
          ? (previous.fatKg / previous.weightKg) * 100 
          : bodyFatPercentage;
      final fatChange = bodyFatPercentage - previousFatPercentage;
      
      // Use a default height of 1.70m if not available from user profile
      // In a real app, this would come from user profile
      final height = 1.70;
      final bmi = currentWeight / (height * height);
      final previousBmi = previous != null 
          ? previous.weightKg / (height * height) 
          : bmi;
      final bmiChange = bmi - previousBmi;
      
      return BodyStats(
        currentWeight: currentWeight,
        weightChange: weightChange,
        bodyFatPercentage: bodyFatPercentage,
        fatChange: fatChange,
        bmi: bmi,
        bmiChange: bmiChange,
        muscleMass: latest.muscleMassKg,
        goalWeight: null,  // Remove hardcoded goal
        goalProgress: null,  // Remove hardcoded progress
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

class BodyCompositionNotifier extends StateNotifier<AsyncValue<List<BodyComposition>>> {
  final BodyCompositionRepository repository;
  String? _lastStartDate;
  String? _lastEndDate;

  BodyCompositionNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> loadBodyCompositions({String? startDate, String? endDate}) async {
    state = const AsyncValue.loading();
    try {
      final defaultEndDate = DateTime.now();
      final defaultStartDate = defaultEndDate.subtract(const Duration(days: 30));
      
      final finalStartDate = startDate ?? defaultStartDate.toIso8601String().split('T')[0];
      final finalEndDate = endDate ?? defaultEndDate.toIso8601String().split('T')[0];
      
      // 마지막 날짜 범위 저장
      _lastStartDate = finalStartDate;
      _lastEndDate = finalEndDate;
      
      final compositions = await repository.getBodyCompositionInfo(
        startDate: finalStartDate,
        endDate: finalEndDate,
      );
      state = AsyncValue.data(compositions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addBodyComposition({
    required double weightKg,
    required double fatKg,
    required double muscleMassKg,
    required String measurementDate,
  }) async {
    try {
      await repository.addBodyComposition(
        weightKg: weightKg,
        fatKg: fatKg,
        muscleMassKg: muscleMassKg,
        measurementDate: measurementDate,
      );
      await loadBodyCompositions();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteBodyComposition(int id) async {
    try {
      await repository.deleteBodyComposition(id);
      // 마지막에 사용한 날짜 범위로 다시 조회
      await loadBodyCompositions(
        startDate: _lastStartDate,
        endDate: _lastEndDate,
      );
    } catch (e) {
      throw e;
    }
  }
}

final bodyCompositionNotifierProvider = 
    StateNotifierProvider<BodyCompositionNotifier, AsyncValue<List<BodyComposition>>>((ref) {
  final repository = ref.watch(bodyCompositionRepositoryProvider);
  return BodyCompositionNotifier(repository);
});

// 몸사진 관련 Provider들
final bodyImagesProvider = FutureProvider<List<BodyImageResponse>>((ref) async {
  final repository = ref.watch(bodyCompositionRepositoryProvider);
  final dateRange = ref.watch(dateRangeProvider);
  
  final startDate = dateRange.startDate.toIso8601String().split('T')[0];
  final endDate = dateRange.endDate.toIso8601String().split('T')[0];
  
  return await repository.getBodyImages(
    startDate: startDate,
    endDate: endDate,
  );
});

class BodyImageNotifier extends StateNotifier<AsyncValue<List<BodyImageResponse>>> {
  final BodyCompositionRepository repository;

  BodyImageNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> loadBodyImages({String? startDate, String? endDate}) async {
    state = const AsyncValue.loading();
    try {
      final defaultEndDate = DateTime.now();
      final defaultStartDate = defaultEndDate.subtract(const Duration(days: 30));
      
      final finalStartDate = startDate ?? defaultStartDate.toIso8601String().split('T')[0];
      final finalEndDate = endDate ?? defaultEndDate.toIso8601String().split('T')[0];
      
      print('=== Body Images Load Debug ===');
      print('Loading body images from $finalStartDate to $finalEndDate');
      
      final images = await repository.getBodyImages(
        startDate: finalStartDate,
        endDate: finalEndDate,
      );
      
      print('Loaded ${images.length} body images');
      for (final image in images) {
        print('Image: ${image.fileUrl} on ${image.recordDate}');
      }
      
      state = AsyncValue.data(images);
    } catch (e, st) {
      print('Error loading body images: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> uploadBodyImages({
    required List<XFile> images,
    required String date,
  }) async {
    try {
      await repository.uploadBodyImages(
        images: images,
        date: date,
      );
      // 업로드 후 목록 새로고침
      await loadBodyImages();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteBodyImage(int fileId) async {
    try {
      await repository.deleteBodyImage(fileId);
      // 삭제 후 목록 새로고침
      await loadBodyImages();
    } catch (e) {
      throw e;
    }
  }
}

final bodyImageNotifierProvider = 
    StateNotifierProvider<BodyImageNotifier, AsyncValue<List<BodyImageResponse>>>((ref) {
  final repository = ref.watch(bodyCompositionRepositoryProvider);
  return BodyImageNotifier(repository);
});