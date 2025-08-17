import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/session_service.dart';

class AuthInterceptor extends Interceptor {
  final SessionService sessionService;
  final Ref ref;

  AuthInterceptor(this.sessionService, this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add session headers to all requests except login/signup
    if (!options.path.contains('/auth/signin') && 
        !options.path.contains('/auth/signup')) {
      final sessionHeaders = sessionService.getSessionHeaders();
      options.headers.addAll(sessionHeaders);
    }

    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Save session info from login/signup responses
    if (response.requestOptions.path.contains('/auth/signin') ||
        response.requestOptions.path.contains('/auth/signup')) {
      sessionService.saveSession(response);
    }

    
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - session expired
    if (err.response?.statusCode == 401) {
      // Clear session and redirect to login
      sessionService.clearSession();
      // You can add navigation to login here if needed
    }

    
    super.onError(err, handler);
  }
}