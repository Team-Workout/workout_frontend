import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../model/pt_application_model.dart';

class PtApplicationApiService {
  final ApiService _apiService;

  PtApplicationApiService(this._apiService);

  // PT 신청 API
  Future<bool> createPtApplication(CreatePtApplicationRequest request) async {
    try {
      final response = await _apiService.post(
        '/pt-applications',
        data: request.toJson(),
      );

      // 200 OK 응답이면 신청 성공
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('PT 신청에 실패했습니다.');
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('404')) {
        throw Exception('해당 PT 상품을 찾을 수 없습니다.');
      } else {
        print('PT 신청 오류: $errorMessage');
        throw Exception('PT 신청 실패: 서버 오류가 발생했습니다.');
      }
    }
  }

  // PT 신청 내역 조회 API
  Future<List<PtApplication>> getPtApplications() async {
    try {
      final response = await _apiService.get('/pt-applications');

      // 응답이 래핑된 객체로 오는 경우: {"data": {"applications": []}}
      if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        
        // Check if data key exists and contains applications
        if (responseMap['data'] != null && responseMap['data'] is Map<String, dynamic>) {
          final dataMap = responseMap['data'] as Map<String, dynamic>;
          final ptApplicationsResponse = PtApplicationsResponse.fromJson(dataMap);
          return ptApplicationsResponse.applications;
        }
        // Handle direct applications in response.data
        else if (responseMap['applications'] != null) {
          final ptApplicationsResponse = PtApplicationsResponse.fromJson(responseMap);
          return ptApplicationsResponse.applications;
        }
        // Handle empty data
        else {
          return [];
        }
      }
      // 응답이 직접 배열로 오는 경우
      else if (response.data is List) {
        final List<dynamic> applicationsData = response.data as List<dynamic>;
        return applicationsData
            .map((data) => PtApplication.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('404')) {
        return []; // 신청 내역이 없는 경우 빈 리스트 반환
      } else {
        print('PT 신청 내역 조회 오류: $errorMessage');
        throw Exception('PT 신청 내역 조회 실패: 서버 오류가 발생했습니다.');
      }
    }
  }

  // PT 신청 취소 API (회원용)
  Future<bool> cancelPtApplication(int applicationId) async {
    try {
      final response = await _apiService.patch(
        '/pt-applications/$applicationId/cancellation',
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('PT 신청 취소에 실패했습니다.');
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('403')) {
        throw Exception('신청을 취소할 권한이 없습니다.');
      } else if (errorMessage.contains('404')) {
        throw Exception('해당 PT 신청을 찾을 수 없습니다.');
      } else {
        print('PT 신청 취소 오류: $errorMessage');
        throw Exception('PT 신청 취소 실패: 서버 오류가 발생했습니다.');
      }
    }
  }

  // PT 신청 수락 API (트레이너용)
  Future<bool> acceptPtApplication(int applicationId) async {
    try {
      final response = await _apiService.patch(
        '/pt-applications/$applicationId/acceptance',
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('PT 신청 수락에 실패했습니다.');
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('403')) {
        throw Exception('신청을 수락할 권한이 없습니다.');
      } else if (errorMessage.contains('404')) {
        throw Exception('해당 PT 신청을 찾을 수 없습니다.');
      } else {
        print('PT 신청 수락 오류: $errorMessage');
        throw Exception('PT 신청 수락 실패: 서버 오류가 발생했습니다.');
      }
    }
  }

  // PT 신청 거절 API (트레이너용)
  Future<bool> rejectPtApplication(int applicationId) async {
    try {
      final response = await _apiService.patch(
        '/pt-applications/$applicationId/rejection',
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('PT 신청 거절에 실패했습니다.');
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('403')) {
        throw Exception('신청을 거절할 권한이 없습니다.');
      } else if (errorMessage.contains('404')) {
        throw Exception('해당 PT 신청을 찾을 수 없습니다.');
      } else {
        print('PT 신청 거절 오류: $errorMessage');
        throw Exception('PT 신청 거절 실패: 서버 오류가 발생했습니다.');
      }
    }
  }
}

// Provider for PtApplicationApiService
final ptApplicationApiServiceProvider =
    Provider<PtApplicationApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PtApplicationApiService(apiService);
});
