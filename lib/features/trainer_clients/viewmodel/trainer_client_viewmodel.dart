import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/trainer_client_model.dart';
import '../repository/trainer_client_repository.dart';

// 트레이너 회원 목록 상태 관리
final trainerClientListProvider = StateNotifierProvider<TrainerClientListNotifier, AsyncValue<TrainerClientResponse>>((ref) {
  return TrainerClientListNotifier(ref.watch(trainerClientRepositoryProvider));
});

// 특정 회원의 몸 사진 목록
final memberBodyImagesProvider = StateNotifierProviderFamily<MemberBodyImagesNotifier, AsyncValue<MemberBodyImageResponse>, int>((ref, memberId) {
  return MemberBodyImagesNotifier(ref.watch(trainerClientRepositoryProvider), memberId);
});

// 특정 회원의 체성분 데이터
final memberBodyCompositionsProvider = StateNotifierProviderFamily<MemberBodyCompositionsNotifier, AsyncValue<MemberBodyCompositionResponse>, int>((ref, memberId) {
  return MemberBodyCompositionsNotifier(ref.watch(trainerClientRepositoryProvider), memberId);
});

class TrainerClientListNotifier extends StateNotifier<AsyncValue<TrainerClientResponse>> {
  final TrainerClientRepository _repository;
  int _currentPage = 0;
  static const int _pageSize = 20;

  TrainerClientListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadClients();
  }

  Future<void> loadClients({int page = 0}) async {
    if (page == 0) {
      state = const AsyncValue.loading();
    }

    try {
      _currentPage = page;
      final response = await _repository.getMyClients(
        page: page,
        size: _pageSize,
      );
      
      state = AsyncValue.data(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMoreClients() async {
    final currentState = state;
    if (currentState is AsyncData<TrainerClientResponse>) {
      final currentResponse = currentState.value;
      
      if (currentResponse.pageInfo.last) {
        return;
      }

      try {
        final nextPage = _currentPage + 1;
        final newResponse = await _repository.getMyClients(
          page: nextPage,
          size: _pageSize,
        );

        final mergedData = [
          ...currentResponse.data,
          ...newResponse.data,
        ];

        final mergedResponse = TrainerClientResponse(
          data: mergedData,
          pageInfo: newResponse.pageInfo,
        );

        _currentPage = nextPage;
        state = AsyncValue.data(mergedResponse);
      } catch (error, stackTrace) {
        print('더 많은 회원을 불러오는데 실패했습니다: $error');
      }
    }
  }

  Future<void> refresh() async {
    await loadClients(page: 0);
  }
}

class MemberBodyImagesNotifier extends StateNotifier<AsyncValue<MemberBodyImageResponse>> {
  final TrainerClientRepository _repository;
  final int memberId;
  int _currentPage = 0;
  static const int _pageSize = 20;

  MemberBodyImagesNotifier(this._repository, this.memberId) : super(const AsyncValue.loading());

  Future<void> loadBodyImages({
    required String startDate,
    required String endDate,
    int page = 0,
  }) async {
    if (page == 0) {
      state = const AsyncValue.loading();
    }

    try {
      _currentPage = page;
      final response = await _repository.getMemberBodyImages(
        memberId: memberId,
        startDate: startDate,
        endDate: endDate,
        page: page,
        size: _pageSize,
      );
      
      state = AsyncValue.data(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMoreImages({
    required String startDate,
    required String endDate,
  }) async {
    final currentState = state;
    if (currentState is AsyncData<MemberBodyImageResponse>) {
      final currentResponse = currentState.value;
      
      if (currentResponse.pageInfo.last) {
        return;
      }

      try {
        final nextPage = _currentPage + 1;
        final newResponse = await _repository.getMemberBodyImages(
          memberId: memberId,
          startDate: startDate,
          endDate: endDate,
          page: nextPage,
          size: _pageSize,
        );

        final mergedData = [
          ...currentResponse.data,
          ...newResponse.data,
        ];

        final mergedResponse = MemberBodyImageResponse(
          data: mergedData,
          pageInfo: newResponse.pageInfo,
        );

        _currentPage = nextPage;
        state = AsyncValue.data(mergedResponse);
      } catch (error, stackTrace) {
        print('더 많은 이미지를 불러오는데 실패했습니다: $error');
      }
    }
  }
}

class MemberBodyCompositionsNotifier extends StateNotifier<AsyncValue<MemberBodyCompositionResponse>> {
  final TrainerClientRepository _repository;
  final int memberId;
  int _currentPage = 0;
  static const int _pageSize = 20;

  MemberBodyCompositionsNotifier(this._repository, this.memberId) : super(const AsyncValue.loading());

  Future<void> loadBodyCompositions({
    required String startDate,
    required String endDate,
    int page = 0,
  }) async {
    if (page == 0) {
      state = const AsyncValue.loading();
    }

    try {
      _currentPage = page;
      final response = await _repository.getMemberBodyCompositions(
        memberId: memberId,
        startDate: startDate,
        endDate: endDate,
        page: page,
        size: _pageSize,
      );
      
      state = AsyncValue.data(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMoreCompositions({
    required String startDate,
    required String endDate,
  }) async {
    final currentState = state;
    if (currentState is AsyncData<MemberBodyCompositionResponse>) {
      final currentResponse = currentState.value;
      
      if (currentResponse.pageInfo.last) {
        return;
      }

      try {
        final nextPage = _currentPage + 1;
        final newResponse = await _repository.getMemberBodyCompositions(
          memberId: memberId,
          startDate: startDate,
          endDate: endDate,
          page: nextPage,
          size: _pageSize,
        );

        final mergedData = [
          ...currentResponse.data,
          ...newResponse.data,
        ];

        final mergedResponse = MemberBodyCompositionResponse(
          data: mergedData,
          pageInfo: newResponse.pageInfo,
        );

        _currentPage = nextPage;
        state = AsyncValue.data(mergedResponse);
      } catch (error, stackTrace) {
        print('더 많은 체성분 데이터를 불러오는데 실패했습니다: $error');
      }
    }
  }
}