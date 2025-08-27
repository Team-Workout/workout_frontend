import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/trainer_model.dart';
import '../repository/trainer_repository.dart';

final trainerViewModelProvider = StateNotifierProvider<TrainerViewModel, AsyncValue<List<Trainer>>>((ref) {
  return TrainerViewModel(ref.watch(trainerRepositoryProvider));
});

final trainerProfileViewModelProvider = StateNotifierProvider<TrainerProfileViewModel, AsyncValue<List<TrainerProfile>>>((ref) {
  return TrainerProfileViewModel(ref.watch(trainerRepositoryProvider));
});

class TrainerViewModel extends StateNotifier<AsyncValue<List<Trainer>>> {
  final TrainerRepository _repository;
  List<Trainer> _allTrainers = [];
  
  TrainerViewModel(this._repository) : super(const AsyncValue.loading()) {
    loadTrainers();
  }

  Future<void> loadTrainers() async {
    try {
      state = const AsyncValue.loading();
      _allTrainers = await _repository.getTrainers();
      state = AsyncValue.data(_allTrainers);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void searchTrainers(String query) {
    if (query.isEmpty) {
      state = AsyncValue.data(_allTrainers);
      return;
    }

    final filtered = _allTrainers.where((trainer) {
      return trainer.name.toLowerCase().contains(query.toLowerCase()) ||
          trainer.specialization.toLowerCase().contains(query.toLowerCase()) ||
          trainer.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();

    state = AsyncValue.data(filtered);
  }

  void filterByCategory(String category) {
    if (category == 'All Trainers') {
      state = AsyncValue.data(_allTrainers);
      return;
    }

    final filtered = _allTrainers.where((trainer) {
      return trainer.tags.contains(category) || 
             trainer.specialization.contains(category);
    }).toList();

    state = AsyncValue.data(filtered);
  }

  Future<void> bookTrainer(String trainerId) async {
    try {
      await _repository.bookTrainer(trainerId);
    } catch (e) {
      throw Exception('Failed to book trainer: $e');
    }
  }
}

class TrainerProfileViewModel extends StateNotifier<AsyncValue<List<TrainerProfile>>> {
  final TrainerRepository _repository;
  List<TrainerProfile> _allTrainerProfiles = [];
  
  TrainerProfileViewModel(this._repository) : super(const AsyncValue.loading());

  Future<void> loadTrainersByGymId(int gymId) async {
    try {
      state = const AsyncValue.loading();
      _allTrainerProfiles = await _repository.getTrainersByGymId(gymId);
      state = AsyncValue.data(_allTrainerProfiles);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void searchTrainers(String query) {
    if (query.isEmpty) {
      state = AsyncValue.data(_allTrainerProfiles);
      return;
    }

    final filtered = _allTrainerProfiles.where((trainer) {
      return trainer.name.toLowerCase().contains(query.toLowerCase()) ||
          (trainer.introduction?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();

    state = AsyncValue.data(filtered);
  }
}