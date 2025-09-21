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

      // 새로운 API 응답 형태: { "data": [...], "pageInfo": {...} }
      final responseMap = response.data as Map<String, dynamic>;
      final dataList = responseMap['data'] as List<dynamic>? ?? [];
      final pageInfoMap = responseMap['pageInfo'] as Map<String, dynamic>?;

      return ApiResponse<List<Feed>>(
        data: dataList
            .map((item) => Feed.fromJson(item as Map<String, dynamic>))
            .toList(),
        pageInfo: pageInfoMap != null
            ? PageInfo.fromJson(pageInfoMap)
            : PageInfo(
                page: 0,
                size: size,
                totalElements: dataList.length,
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

      // POST 응답도 새로운 형태를 따를 수 있음: { "data": 숫자, "pageInfo": {...} }
      if (response.data is int) {
        // 기존 방식: 숫자만 반환
        return ApiResponse<int>(
          data: response.data as int,
          pageInfo: PageInfo(
            page: 0,
            size: 1,
            totalElements: 1,
            totalPages: 1,
            last: true,
          ),
        );
      } else if (response.data is Map<String, dynamic>) {
        // 새로운 방식: { "data": 숫자, "pageInfo": {...} }
        final responseMap = response.data as Map<String, dynamic>;
        final feedId = responseMap['data'] as int;
        final pageInfoMap = responseMap['pageInfo'] as Map<String, dynamic>?;

        return ApiResponse<int>(
          data: feedId,
          pageInfo: pageInfoMap != null
              ? PageInfo.fromJson(pageInfoMap)
              : PageInfo(
                  page: 0,
                  size: 1,
                  totalElements: 1,
                  totalPages: 1,
                  last: true,
                ),
        );
      } else {
        // 혹시 문자열로 온 경우
        final feedId = int.parse(response.data.toString());
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
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 피드 요약 정보 조회 (전체 피드 목록에서 특정 feedId 찾기)
  Future<ApiResponse<FeedSummary>> getFeedSummary(int feedId) async {
    try {
      // TODO: 실제 사용자의 gymId 가져오기 (임시로 1 사용)
      const int gymId = 1;

      // 전체 피드 목록을 가져와서 특정 feedId 찾기
      // 큰 size로 설정하여 모든 피드를 가져오거나, 페이징으로 처리
      final response = await _dio.get(
        '/feeds',
        queryParameters: {
          'gymId': gymId,
          'size': 100, // 충분히 큰 사이즈로 설정
        },
      );

      if (response.data == null) {
        throw Exception('피드 목록을 가져올 수 없습니다.');
      }

      // 응답 형태: { "data": [...], "pageInfo": {...} }
      final responseMap = response.data as Map<String, dynamic>;
      final dataList = responseMap['data'] as List<dynamic>? ?? [];

      // 특정 feedId를 가진 피드 찾기
      final targetFeed = dataList.firstWhere(
        (feed) => (feed as Map<String, dynamic>)['feedId'] == feedId,
        orElse: () => null,
      );

      if (targetFeed == null) {
        throw Exception('해당 피드를 찾을 수 없습니다.');
      }

      final feedData = targetFeed as Map<String, dynamic>;

      print('=== Feed Summary Debug ===');
      print('Found feed data: $feedData');
      print('Available keys: ${feedData.keys.toList()}');

      // 실제 댓글 수를 가져오기 위해 댓글 API 호출
      int actualCommentCount = 0;
      try {
        final commentsResponse = await _dio.get(
          '/feeds/${feedData['feedId']}/comments',
          queryParameters: {'page': 0, 'size': 1}, // 첫 페이지만 가져와서 totalElements 확인
        );
        if (commentsResponse.data != null) {
          final commentsResponseMap = commentsResponse.data as Map<String, dynamic>;
          final pageInfo = commentsResponseMap['pageInfo'] as Map<String, dynamic>?;
          actualCommentCount = pageInfo?['totalElements'] ?? 0;
        }
      } catch (e) {
        print('Failed to get comment count: $e');
      }

      // Feed 객체에서 FeedSummary에 필요한 데이터 추출
      final feedSummaryData = {
        'feedId': feedData['feedId'],
        'imageUrl': feedData['imageUrl'],
        'authorUsername': feedData['authorUsername'] ?? '',
        'authorProfileImageUrl': feedData['authorProfileImageUrl'] ?? '',
        'likeCount': feedData['likeCount'] ?? 0,
        'commentCount': actualCommentCount, // 실제 댓글 수 사용
      };

      print('Extracted feed summary data: $feedSummaryData');

      return ApiResponse<FeedSummary>(
        data: FeedSummary.fromJson(feedSummaryData),
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

      // 새로운 API 응답 형태: { "data": [...], "pageInfo": {...} }
      final responseMap = response.data as Map<String, dynamic>;
      final dataList = responseMap['data'] as List<dynamic>? ?? [];
      final pageInfoMap = responseMap['pageInfo'] as Map<String, dynamic>?;

      return ApiResponse<List<Comment>>(
        data: dataList
            .map((item) => Comment.fromJson(item as Map<String, dynamic>))
            .toList(),
        pageInfo: pageInfoMap != null
            ? PageInfo.fromJson(pageInfoMap)
            : PageInfo(
                page: page,
                size: size,
                totalElements: dataList.length,
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
    int? parentId, // 대댓글인 경우 부모 댓글 ID
  }) async {
    try {
      // 멘션이 포함된 경우 임시로 처리해보기
      String processedContent = content;

      final commentRequest = CommentRequest(
        targetId: targetId,
        targetType: targetType,
        content: processedContent,
        parentId: parentId,
      );

      print('=== Comment Request Debug ===');
      print('Original content: $content');
      print('Processed content: $processedContent');
      print('Request data: ${commentRequest.toJson()}');
      print('Is reply: ${parentId != null}');

      final response = await _dio.post(
        '/feeds/comments',
        data: commentRequest.toJson(),
      );

      // POST 응답도 새로운 형태를 따를 수 있음: { "data": 숫자, "pageInfo": {...} }
      if (response.data is int) {
        // 기존 방식: 숫자만 반환
        return ApiResponse<int>(
          data: response.data as int,
          pageInfo: PageInfo(
            page: 0,
            size: 1,
            totalElements: 1,
            totalPages: 1,
            last: true,
          ),
        );
      } else if (response.data is Map<String, dynamic>) {
        // 새로운 방식: { "data": 숫자, "pageInfo": {...} }
        final responseMap = response.data as Map<String, dynamic>;
        final commentId = responseMap['data'] as int;
        final pageInfoMap = responseMap['pageInfo'] as Map<String, dynamic>?;

        return ApiResponse<int>(
          data: commentId,
          pageInfo: pageInfoMap != null
              ? PageInfo.fromJson(pageInfoMap)
              : PageInfo(
                  page: 0,
                  size: 1,
                  totalElements: 1,
                  totalPages: 1,
                  last: true,
                ),
        );
      } else {
        // 혹시 문자열로 온 경우
        final commentId = int.parse(response.data.toString());
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
      }
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