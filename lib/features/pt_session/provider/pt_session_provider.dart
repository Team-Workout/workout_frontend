import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/pt_session_model.dart';
import '../repository/pt_session_repository.dart';

// 현재 페이지 상태 관리
final ptSessionPageProvider = StateProvider<int>((ref) => 0);

// PT 세션 목록 프로바이더
final ptSessionListProvider = FutureProvider.family<PtSessionListResponse, int>(
  (ref, page) async {
    final repository = ref.watch(ptSessionRepositoryProvider);
    return await repository.getMyPtSessions(
      page: page,
      size: 20,
    );
  },
);

// 전체 PT 세션 상태 관리 (페이징 포함)
class PtSessionNotifier extends StateNotifier<AsyncValue<PtSessionListResponse>> {
  final PtSessionRepository _repository;
  
  PtSessionNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadSessions();
  }

  int _currentPage = 0;
  List<PtSessionResponse> _allSessions = [];
  bool _hasMore = true;
  
  bool get hasMore => _hasMore;
  List<PtSessionResponse> get allSessions => _allSessions;

  Future<void> loadSessions({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _allSessions = [];
      _hasMore = true;
      state = const AsyncValue.loading();
    }

    try {
      final response = await _repository.getMyPtSessions(
        page: _currentPage,
        size: 20,
      );

      if (refresh) {
        _allSessions = response.data;
      } else {
        _allSessions.addAll(response.data);
      }

      _hasMore = !response.pageInfo.last;
      
      state = AsyncValue.data(
        PtSessionListResponse(
          data: _allSessions,
          pageInfo: response.pageInfo,
        ),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    _currentPage++;
    await loadSessions();
  }
}

// StateNotifier 프로바이더
final ptSessionNotifierProvider = 
    StateNotifierProvider<PtSessionNotifier, AsyncValue<PtSessionListResponse>>(
  (ref) {
    final repository = ref.watch(ptSessionRepositoryProvider);
    return PtSessionNotifier(repository);
  },
);