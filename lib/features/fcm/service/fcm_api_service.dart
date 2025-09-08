import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/fcm_service.dart';

final fcmApiServiceProvider = Provider<FCMApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final fcmService = ref.watch(fcmServiceProvider);
  return FCMApiService(apiService, fcmService);
});

class FCMApiService {
  final ApiService _apiService;
  final FCMService _fcmService;

  FCMApiService(this._apiService, this._fcmService);

  Future<void> updateFCMToken() async {
    try {
      final token = await _fcmService.getTokenForBackend();

      if (token == null) {
        throw Exception('FCM 토큰을 가져올 수 없습니다.');
      }

      final response = await _apiService.post(
        '/fcm/me/token',
        data: token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('FCM 토큰이 성공적으로 업데이트되었습니다.');
      }
    } catch (e) {
      print('FCM 토큰 업데이트 실패: $e');
      rethrow;
    }
  }

  Future<void> deleteFCMToken() async {
    try {
      final response = await _apiService.delete('/fcm/me/token');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('FCM 토큰이 성공적으로 삭제되었습니다.');
      }
    } catch (e) {
      print('FCM 토큰 삭제 실패: $e');
      rethrow;
    }
  }
}
