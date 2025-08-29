import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../model/pt_offering_model.dart';

class PtOfferingApiService {
  final ApiService _apiService;

  PtOfferingApiService(this._apiService);

  // PT 상품 생성 API
  Future<bool> createPtOffering(CreatePtOfferingRequest request) async {
    try {
      final response = await _apiService.post(
        '/pt-offerings',
        data: request.toJson(),
      );

      // 응답이 String이거나 성공 상태코드이면 성공으로 간주
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('PT 상품 생성에 실패했습니다.');
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('403')) {
        throw Exception('트레이너 권한이 없습니다.');
      } else if (errorMessage.contains('400')) {
        throw Exception('잘못된 요청입니다. 입력 데이터를 확인해주세요.');
      } else {
        print(errorMessage);
        throw Exception('PT 상품 생성 실패: 서버 오류가 발생했습니다.');
      }
    }
  }

  // 트레이너별 PT 상품 조회 API
  Future<List<PtOffering>> getPtOfferingsByTrainerId(int trainerId) async {
    try {
      final response = await _apiService.get(
        '/pt-offerings/trainer/$trainerId',
      );

      // 응답이 직접 배열로 오는 경우
      if (response.data is List) {
        final List<dynamic> offeringsData = response.data as List<dynamic>;
        return offeringsData
            .map((data) => PtOffering.fromJson(data as Map<String, dynamic>))
            .toList();
      } 
      // 응답이 래핑된 객체로 오는 경우
      else if (response.data is Map<String, dynamic>) {
        final ptOfferingsResponse = PtOfferingsResponse.fromJson(response.data);
        return ptOfferingsResponse.ptOfferings;
      } 
      else {
        return [];
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('404')) {
        return []; // 상품이 없는 경우 빈 리스트 반환
      } else {
        print('PT 상품 조회 오류: $errorMessage');
        throw Exception('PT 상품 조회 실패: 서버 오류가 발생했습니다.');
      }
    }
  }

  // PT 상품 삭제 API
  Future<bool> deletePtOffering(int offeringId) async {
    try {
      final response = await _apiService.delete(
        '/pt-offerings/$offeringId',
      );

      // 204 No Content 응답이면 삭제 성공
      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('PT 상품 삭제에 실패했습니다.');
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('403')) {
        throw Exception('상품을 삭제할 권한이 없습니다.');
      } else if (errorMessage.contains('404')) {
        throw Exception('해당 PT 상품을 찾을 수 없습니다.');
      } else {
        print('PT 상품 삭제 오류: $errorMessage');
        throw Exception('PT 상품 삭제 실패: 서버 오류가 발생했습니다.');
      }
    }
  }
}

// Provider for PtOfferingApiService
final ptOfferingApiServiceProvider = Provider<PtOfferingApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PtOfferingApiService(apiService);
});
