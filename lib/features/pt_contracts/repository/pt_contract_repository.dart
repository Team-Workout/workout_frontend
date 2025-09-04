import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../model/pt_contract_model.dart';

final ptContractRepositoryProvider = Provider<PtContractRepository>((ref) {
  return PtContractRepository(ref.watch(apiServiceProvider));
});

class PtContractRepository {
  final ApiService _apiService;

  PtContractRepository(this._apiService);

  Future<PtContractResponse> getMyContracts({
    int page = 0,
    int size = 10,
    String sort = 'paymentDate,desc',
  }) async {
    try {
      final response = await _apiService.get(
        '/api/pt/contract/me',
        queryParameters: {
          'page': page,
          'size': size,
          'sort': sort,
        },
      );

      return PtContractResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('인증되지 않은 사용자입니다');
      }
      throw Exception('PT 계약 목록을 불러오는데 실패했습니다: ${e.message}');
    } catch (e) {
      throw Exception('PT 계약 목록을 불러오는데 실패했습니다: $e');
    }
  }

  Future<PtContract> getContractById(int contractId) async {
    try {
      final response = await _apiService.get('/api/pt/contract/$contractId');
      return PtContract.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('인증되지 않은 사용자입니다');
      } else if (e.response?.statusCode == 404) {
        throw Exception('계약을 찾을 수 없습니다');
      }
      throw Exception('계약 정보를 불러오는데 실패했습니다: ${e.message}');
    } catch (e) {
      throw Exception('계약 정보를 불러오는데 실패했습니다: $e');
    }
  }

  // 활성 계약만 조회 (대시보드용)
  Future<List<PtContract>> getActiveContracts() async {
    try {
      final response = await getMyContracts(size: 50); // 충분한 사이즈로 조회
      return response.data.where((contract) => contract.isActive).toList();
    } catch (e) {
      throw Exception('활성 계약을 불러오는데 실패했습니다: $e');
    }
  }

  // 가장 최근 활성 계약 하나만 조회 (대시보드 요약용)
  Future<PtContract?> getLatestActiveContract() async {
    try {
      final activeContracts = await getActiveContracts();
      if (activeContracts.isEmpty) return null;
      
      // paymentDate 기준으로 가장 최근 계약 반환
      activeContracts.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
      return activeContracts.first;
    } catch (e) {
      print('최근 활성 계약을 불러오는데 실패했습니다: $e');
      return null;
    }
  }
}