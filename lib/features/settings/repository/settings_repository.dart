import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/core/services/api_service.dart';
import 'package:pt_service/core/services/session_service.dart';
import 'package:image_picker/image_picker.dart';
import '../model/profile_image_model.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final sessionService = ref.watch(sessionServiceProvider);
  return SettingsRepository(dio, sessionService);
});

class SettingsRepository {
  final Dio _dio;
  final SessionService _sessionService;

  SettingsRepository(this._dio, this._sessionService);

  Future<void> updateWorkoutLogAccess({required bool isOpen}) async {
    try {
      await _dio.put(
        '/member/me/settings/workout-log-access',
        data: {
          'isOpenWorkoutRecord': isOpen,
        },
      );
    } catch (e) {
      throw Exception('운동일지 공개 설정 변경 실패: $e');
    }
  }

  /// 프로필 이미지 업로드
  Future<ProfileImageResponse> uploadProfileImage(XFile imageFile) async {
    try {
      // 파일 확장자와 MIME 타입 확인
      final String fileName = imageFile.name.toLowerCase();
      String mimeType;
      
      if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      } else if (fileName.endsWith('.png')) {
        mimeType = 'image/png';
      } else if (fileName.endsWith('.webp')) {
        mimeType = 'image/webp';
      } else {
        throw Exception('지원하지 않는 이미지 형식입니다. JPG, PNG, WebP만 가능합니다.');
      }

      print('=== Profile Image Upload Debug ===');
      print('File name: ${imageFile.name}');
      print('File path: ${imageFile.path}');
      print('MIME type: $mimeType');

      final formData = FormData.fromMap({
        'image': MultipartFile.fromFileSync(
          imageFile.path,
          filename: imageFile.name,
          contentType: DioMediaType.parse(mimeType),
        ),
      });

      // Request 헤더와 세션 정보 확인
      print('Request headers: ${_dio.options.headers}');
      print('Base URL: ${_dio.options.baseUrl}');
      print('Request URL: ${_dio.options.baseUrl}/common/members/me/profile-image');
      print('Session has session: ${_sessionService.hasSession}');
      print('Session ID: ${_sessionService.sessionId}');
      print('Session Token: ${_sessionService.sessionToken}');
      print('Session headers: ${_sessionService.getSessionHeaders()}');

      final response = await _dio.post(
        '/common/members/me/profile-image',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('Upload success: ${response.statusCode} - ${response.data}');
      
      // Handle response format like {"data": {fileId: 2, fileUrl: "...", ...}}
      if (response.data is Map<String, dynamic> && response.data['data'] != null) {
        return ProfileImageResponse.fromJson(response.data['data']);
      } else {
        return ProfileImageResponse.fromJson(response.data);
      }
    } catch (e) {
      print('=== Upload Error Details ===');
      if (e is DioException) {
        print('Error type: ${e.type}');
        print('Status code: ${e.response?.statusCode}');
        print('Status message: ${e.response?.statusMessage}');
        print('Response headers: ${e.response?.headers}');
        print('Response data: ${e.response?.data}');
        print('Request path: ${e.requestOptions.path}');
        print('Request headers: ${e.requestOptions.headers}');
        print('Request base URL: ${e.requestOptions.baseUrl}');
        
        if (e.response?.statusCode == 401) {
          print('=== 401 Authentication Error ===');
          print('This usually means:');
          print('1. User is not logged in');
          print('2. Session/token has expired');
          print('3. Required authentication headers are missing');
          print('4. Cookie-based session is not being sent');
        }
      }
      print('Original error: $e');
      throw Exception('프로필 이미지 업로드 실패: $e');
    }
  }

  /// 현재 프로필 이미지 조회
  Future<ProfileImageInfo?> getProfileImage() async {
    try {
      print('=== Profile Image Get Debug ===');
      print('Request URL: ${_dio.options.baseUrl}/common/members/me/profile-image');
      print('Request headers: ${_dio.options.headers}');
      print('Session has session: ${_sessionService.hasSession}');
      print('Session ID: ${_sessionService.sessionId}');
      print('Session Token: ${_sessionService.sessionToken}');
      
      final response = await _dio.post('/common/members/me/profile-image');
      print('Get profile image success: ${response.statusCode} - ${response.data}');
      return ProfileImageInfo.fromJson(response.data);
    } catch (e) {
      print('=== Get Profile Image Error ===');
      if (e is DioException) {
        print('Error type: ${e.type}');
        print('Status code: ${e.response?.statusCode}');
        print('Status message: ${e.response?.statusMessage}');
        print('Response data: ${e.response?.data}');
        print('Request headers: ${e.requestOptions.headers}');
        
        if (e.response?.statusCode == 401) {
          print('=== 401 Authentication Error in Get Profile Image ===');
          print('User might not be authenticated for image retrieval');
        } else if (e.response?.statusCode == 404) {
          print('=== 404 Not Found ===');
          print('User might not have a profile image set');
        } else if (e.response?.statusCode == 500) {
          print('=== 500 Server Error ===');
          print('Server internal error - profile image feature might not be fully implemented');
          // Return null or default instead of throwing exception
          return null;
        }
      }
      print('Get profile image error: $e');
      throw Exception('프로필 이미지 조회 실패: $e');
    }
  }
}
