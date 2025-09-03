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

class DateRangeNotifier extends StateNotifier<DateRange> {
  DateRangeNotifier() : super(DateRange(
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    endDate: DateTime.now(),
  ));

  void updateDateRange(DateTime startDate, DateTime endDate) {
    state = DateRange(startDate: startDate, endDate: endDate);
  }
}

class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  DateRange({required this.startDate, required this.endDate});
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

  BodyCompositionNotifier(this.repository) : super(const AsyncValue.loading());

  Future<void> loadBodyCompositions({String? startDate, String? endDate}) async {
    state = const AsyncValue.loading();
    try {
      final defaultEndDate = DateTime.now();
      final defaultStartDate = defaultEndDate.subtract(const Duration(days: 30));
      
      final compositions = await repository.getBodyCompositionInfo(
        startDate: startDate ?? defaultStartDate.toIso8601String().split('T')[0],
        endDate: endDate ?? defaultEndDate.toIso8601String().split('T')[0],
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
      await loadBodyCompositions();
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
      
      final images = await repository.getBodyImages(
        startDate: startDate ?? defaultStartDate.toIso8601String().split('T')[0],
        endDate: endDate ?? defaultEndDate.toIso8601String().split('T')[0],
      );
      state = AsyncValue.data(images);
    } catch (e, st) {
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