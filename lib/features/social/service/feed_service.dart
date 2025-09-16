import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/feed_models.dart';
import '../../../core/services/api_service.dart';

class FeedService {
  final Dio _dio;

  FeedService(this._dio);

  // 피드 목록 조회 (커서 기반 페이징)
  Future<ApiResponse<List<Feed>>> getFeeds({
    required int gymId,
    int? lastFeedId,
    int? firstFeedId,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'gymId': gymId,
        'size': size,
      };

      if (lastFeedId != null) {
        queryParams['lastFeedId'] = lastFeedId;
      }

      if (firstFeedId != null) {
        queryParams['firstFeedId'] = firstFeedId;
      }

      final response = await _dio.get(
        '/feeds',
        queryParameters: queryParams,
      );

      // 응답이 null이거나 data 필드가 없는 경우 빈 리스트 반환
      if (response.data == null) {
        return ApiResponse<List<Feed>>(
          data: <Feed>[],
          pageInfo: PageInfo(
            page: 0,
            size: size,
            totalElements: 0,
            totalPages: 0,
            last: true,
          ),
        );
      }

      // data 필드가 있는 경우와 없는 경우 모두 처리
      final responseData = response.data is Map<String, dynamic> && response.data['data'] != null 
          ? response.data['data'] 
          : response.data;
      
      final feedsList = responseData is List ? responseData : <dynamic>[];
      
      return ApiResponse<List<Feed>>(
        data: feedsList
            .where((item) => item != null)
            .map((item) => Feed.fromJson(item as Map<String, dynamic>))
            .toList(),
        pageInfo: response.data is Map<String, dynamic> && response.data['pageInfo'] != null
            ? PageInfo.fromJson(response.data['pageInfo'] as Map<String, dynamic>)
            : PageInfo(
                page: 0,
                size: size,
                totalElements: feedsList.length,
                totalPages: 1,
                last: true,
              ),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 피드 생성 (이미지 업로드)
  Future<ApiResponse<int>> createFeed({
    required File imageFile,
  }) async {
    try {
      // 파일 확장자와 MIME 타입 확인 (프로필 이미지 업로드와 동일)
      final String fileName = imageFile.path.split('/').last.toLowerCase();
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

      final formData = FormData.fromMap({
        'image': MultipartFile.fromFileSync(
          imageFile.path,
          filename: fileName,
          contentType: DioMediaType.parse(mimeType),
        ),
      });

      final response = await _dio.post(
        '/feeds',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // POST 응답: 201 상태코드에 숫자만 반환
      // response.data가 숫자인 경우와 {"data": 숫자} 형태인 경우 모두 처리
      int feedId;
      if (response.data is int) {
        feedId = response.data;
      } else if (response.data is Map<String, dynamic> && response.data['data'] != null) {
        feedId = response.data['data'] as int;
      } else {
        // 혹시 문자열로 온 경우
        feedId = int.parse(response.data.toString());
      }

      return ApiResponse<int>(
        data: feedId,
        pageInfo: PageInfo(
          page: 0,
          size: 1,
          totalElements: 1,
          totalPages: 1,
          last: true,
        ),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 피드 요약 정보 조회
  Future<ApiResponse<FeedSummary>> getFeedSummary(int feedId) async {
    try {
      final response = await _dio.get('/feeds/$feedId/summary');

      if (response.data == null) {
        throw Exception('피드 정보가 존재하지 않습니다.');
      }

      // data 필드가 있는 경우와 없는 경우 모두 처리
      final responseData = response.data is Map<String, dynamic> && response.data['data'] != null 
          ? response.data['data'] 
          : response.data;

      return ApiResponse<FeedSummary>(
        data: FeedSummary.fromJson(responseData as Map<String, dynamic>),
        pageInfo: response.data is Map<String, dynamic> && response.data['pageInfo'] != null
            ? PageInfo.fromJson(response.data['pageInfo'] as Map<String, dynamic>)
            : PageInfo(
                page: 0,
                size: 1,
                totalElements: 1,
                totalPages: 1,
                last: true,
              ),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 피드 댓글 목록 조회
  Future<ApiResponse<List<Comment>>> getFeedComments({
    required int feedId,
    int page = 0,
    int size = 20,
    List<String>? sort,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
      };

      if (sort != null && sort.isNotEmpty) {
        queryParams['sort'] = sort;
      }

      final response = await _dio.get(
        '/feeds/$feedId/comments',
        queryParameters: queryParams,
      );

      // 응답이 null이거나 data 필드가 없는 경우 빈 리스트 반환
      if (response.data == null) {
        return ApiResponse<List<Comment>>(
          data: <Comment>[],
          pageInfo: PageInfo(
            page: page,
            size: size,
            totalElements: 0,
            totalPages: 0,
            last: true,
          ),
        );
      }

      // data 필드가 있는 경우와 없는 경우 모두 처리
      final responseData = response.data is Map<String, dynamic> && response.data['data'] != null 
          ? response.data['data'] 
          : response.data;
      
      final commentsList = responseData is List ? responseData : <dynamic>[];
      
      return ApiResponse<List<Comment>>(
        data: commentsList
            .where((item) => item != null)
            .map((item) => Comment.fromJson(item as Map<String, dynamic>))
            .toList(),
        pageInfo: response.data is Map<String, dynamic> && response.data['pageInfo'] != null
            ? PageInfo.fromJson(response.data['pageInfo'] as Map<String, dynamic>)
            : PageInfo(
                page: page,
                size: size,
                totalElements: commentsList.length,
                totalPages: 1,
                last: true,
              ),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 좋아요/좋아요 취소
  Future<bool> toggleLike({
    required String targetType, // "FEED" or "COMMENT"
    required int targetId,
  }) async {
    try {
      final response = await _dio.post(
        '/feeds/like',
        data: LikeRequest(
          targetType: targetType,
          targetId: targetId,
        ).toJson(),
      );

      // 성공시 true 반환 (응답 형태에 관계없이)
      return true;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 댓글/대댓글 작성
  Future<ApiResponse<int>> createComment({
    required int targetId,
    required String targetType, // "FEED" or "COMMENT"
    required String content,
  }) async {
    try {
      final response = await _dio.post(
        '/feeds/comments',
        data: CommentRequest(
          targetId: targetId,
          targetType: targetType,
          content: content,
        ).toJson(),
      );

      // POST 응답: 201 상태코드에 숫자만 반환 (피드 생성과 동일)
      int commentId;
      if (response.data is int) {
        commentId = response.data;
      } else if (response.data is Map<String, dynamic> && response.data['data'] != null) {
        commentId = response.data['data'] as int;
      } else {
        commentId = int.parse(response.data.toString());
      }

      return ApiResponse<int>(
        data: commentId,
        pageInfo: PageInfo(
          page: 0,
          size: 1,
          totalElements: 1,
          totalPages: 1,
          last: true,
        ),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 피드 삭제
  Future<ApiResponse<String>> deleteFeed(int feedId) async {
    try {
      final response = await _dio.delete('/feeds/$feedId');

      return ApiResponse<String>.fromJson(
        response.data,
        (data) => data as String,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 에러 처리
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('네트워크 연결이 불안정합니다. 다시 시도해주세요.');
        
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? '서버 오류가 발생했습니다.';
          
          switch (statusCode) {
            case 400:
              return Exception('잘못된 요청입니다: $message');
            case 401:
              return Exception('인증이 필요합니다. 다시 로그인해주세요.');
            case 403:
              return Exception('권한이 없습니다: $message');
            case 404:
              return Exception('요청한 데이터를 찾을 수 없습니다.');
            case 500:
              return Exception('서버 내부 오류가 발생했습니다.');
            default:
              return Exception('서버 오류 ($statusCode): $message');
          }
        
        case DioExceptionType.cancel:
          return Exception('요청이 취소되었습니다.');
        
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return Exception('인터넷 연결을 확인해주세요.');
          }
          return Exception('알 수 없는 오류가 발생했습니다.');
        
        default:
          return Exception('네트워크 오류가 발생했습니다.');
      }
    }
    
    return Exception('예상치 못한 오류가 발생했습니다: ${error.toString()}');
  }
}

// Riverpod 프로바이더
final feedServiceProvider = Provider<FeedService>((ref) {
  final dio = ref.watch(dioProvider);
  return FeedService(dio);
});