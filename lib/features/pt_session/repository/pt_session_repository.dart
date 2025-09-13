import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../model/pt_session_model.dart';

final ptSessionRepositoryProvider = Provider<PtSessionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PtSessionRepository(dio);
});

class PtSessionRepository {
  final Dio _dio;

  PtSessionRepository(this._dio);

  Future<PtSessionListResponse> getMyPtSessions({
    int page = 0,
    int size = 20,
    List<String>? sort,
  }) async {
    try {
      final response = await _dio.get(
        '/pt-sessions/me',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      return PtSessionListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deletePtSession(int ptSessionId) async {
    try {
      await _dio.delete('/pt-sessions/$ptSessionId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다';
      
      switch (statusCode) {
        case 401:
          return '인증이 필요합니다. 다시 로그인해주세요.';
        case 403:
          return '접근 권한이 없습니다.';
        case 404:
          return '요청한 데이터를 찾을 수 없습니다.';
        case 500:
          return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
        default:
          return message;
      }
    }
    
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return '네트워크 연결이 불안정합니다. 다시 시도해주세요.';
    }
    
    return '네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.';
  }
}