import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/pt_contract_model.dart';
import '../repository/pt_contract_repository.dart';

// PT 계약 목록 상태 관리
final ptContractListProvider = StateNotifierProvider<PtContractListNotifier, AsyncValue<PtContractResponse>>((ref) {
  return PtContractListNotifier(ref.watch(ptContractRepositoryProvider));
});

// 대시보드용 최근 활성 계약
final latestActiveContractProvider = FutureProvider<PtContract?>((ref) {
  final repository = ref.watch(ptContractRepositoryProvider);
  return repository.getLatestActiveContract();
});

// 활성 계약 목록
final activeContractsProvider = FutureProvider<List<PtContract>>((ref) {
  final repository = ref.watch(ptContractRepositoryProvider);
  return repository.getActiveContracts();
});

class PtContractListNotifier extends StateNotifier<AsyncValue<PtContractResponse>> {
  final PtContractRepository _repository;
  int _currentPage = 0;
  static const int _pageSize = 10;

  PtContractListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadContracts();
  }

  Future<void> loadContracts({int page = 0}) async {
    if (page == 0) {
      state = const AsyncValue.loading();
    }

    try {
      _currentPage = page;
      final response = await _repository.getMyContracts(
        page: page,
        size: _pageSize,
        sort: 'paymentDate,desc',
      );
      
      state = AsyncValue.data(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMoreContracts() async {
    final currentState = state;
    if (currentState is AsyncData<PtContractResponse>) {
      final currentResponse = currentState.value;
      
      // 마지막 페이지인지 확인
      if (currentResponse.pageInfo.last) {
        return;
      }

      try {
        final nextPage = _currentPage + 1;
        final newResponse = await _repository.getMyContracts(
          page: nextPage,
          size: _pageSize,
          sort: 'paymentDate,desc',
        );

        // 기존 데이터와 새 데이터 병합
        final mergedData = [
          ...currentResponse.data,
          ...newResponse.data,
        ];

        final mergedResponse = PtContractResponse(
          data: mergedData,
          pageInfo: newResponse.pageInfo,
        );

        _currentPage = nextPage;
        state = AsyncValue.data(mergedResponse);
      } catch (error, stackTrace) {
        // 에러가 발생해도 기존 상태 유지
        print('더 많은 계약을 불러오는데 실패했습니다: $error');
      }
    }
  }

  Future<void> refresh() async {
    await loadContracts(page: 0);
  }

  // 특정 상태의 계약만 필터링
  List<PtContract> getContractsByStatus(PtContractStatus status) {
    final currentState = state;
    if (currentState is AsyncData<PtContractResponse>) {
      return currentState.value.data
          .where((contract) => contract.contractStatus == status)
          .toList();
    }
    return [];
  }

  // 활성 계약 개수
  int get activeContractCount {
    return getContractsByStatus(PtContractStatus.active).length;
  }

  // 완료된 계약 개수
  int get completedContractCount {
    return getContractsByStatus(PtContractStatus.completed).length;
  }

  // 총 남은 세션 수
  int get totalRemainingSessions {
    final activeContracts = getContractsByStatus(PtContractStatus.active);
    return activeContracts.fold<int>(
      0, 
      (total, contract) => total + contract.remainingSessions,
    );
  }
}

// 개별 계약 상세 정보
final ptContractDetailProvider = FutureProviderFamily<PtContract, int>((ref, contractId) {
  final repository = ref.watch(ptContractRepositoryProvider);
  return repository.getContractById(contractId);
});