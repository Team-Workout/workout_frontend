import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/api_config.dart';
import 'session_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final sessionService = ref.watch(sessionServiceProvider);
  
  final dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: ApiConfig.connectionTimeout,
    receiveTimeout: ApiConfig.receiveTimeout,
    headers: {
      'Content-Type': 'application/json',
    },
    validateStatus: (status) {
      // 2xx 및 201 응답을 모두 성공으로 처리
      return status != null && status >= 200 && status < 300;
    },
  ));

  // Add cookie manager for automatic cookie handling
  dio.interceptors.add(CookieManager(sessionService.cookieJar));

  // Add session interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      // Add session headers to all requests
      final sessionHeaders = sessionService.getSessionHeaders();
      options.headers.addAll(sessionHeaders);
      handler.next(options);
    },
    onResponse: (response, handler) {
      // Save session from response
      sessionService.saveSession(response);
      handler.next(response);
    },
  ));

  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    requestHeader: true,
    responseHeader: true,
  ));

  return dio;
});

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patch(String path, {dynamic data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('연결 시간이 초과되었습니다.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        // 201 Created는 성공 응답이므로 에러로 처리하지 않음
        if (statusCode == 201) {
          // 201은 성공이므로 에러가 아님 - 이 경우는 발생하지 않아야 함
          return Exception('예상치 못한 에러 처리');
        }
        final message = error.response?.data['message'] ?? '오류가 발생했습니다.';
        if (statusCode == 400) {
          return Exception(message);
        } else if (statusCode == 401) {
          return Exception('인증이 필요합니다.');
        } else if (statusCode == 403) {
          return Exception('접근 권한이 없습니다.');
        } else if (statusCode == 404) {
          return Exception('요청한 리소스를 찾을 수 없습니다.');
        } else if (statusCode == 500) {
          return Exception('서버 오류가 발생했습니다.');
        }
        return Exception(message);
      case DioExceptionType.cancel:
        return Exception('요청이 취소되었습니다.');
      case DioExceptionType.unknown:
        try {
          if (error.error.toString().contains('SocketException')) {
            return Exception('인터넷 연결을 확인해주세요.');
          }
        } catch (e) {
          // toString() 실패 시 안전하게 처리
        }
        return Exception('알 수 없는 오류가 발생했습니다.');
      default:
        return Exception('오류가 발생했습니다.');
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});