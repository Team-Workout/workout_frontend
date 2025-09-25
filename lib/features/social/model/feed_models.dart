import '../../../core/config/api_config.dart';

// 페이지 정보 모델
class PageInfo {
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool last;

  const PageInfo({
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        page: json['page'] as int,
        size: json['size'] as int,
        totalElements: json['totalElements'] as int,
        totalPages: json['totalPages'] as int,
        last: json['last'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'page': page,
        'size': size,
        'totalElements': totalElements,
        'totalPages': totalPages,
        'last': last,
      };
}

// 기본 피드 정보 (목록용)
class Feed {
  final int feedId;
  final String imageUrl;
  final String? authorUsername;
  final String? authorProfileImageUrl;
  final int? likeCount;
  final int? commentCount;
  final bool? isLiked;
  final String? createdAt;

  const Feed({
    required this.feedId,
    required this.imageUrl,
    this.authorUsername,
    this.authorProfileImageUrl,
    this.likeCount,
    this.commentCount,
    this.isLiked,
    this.createdAt,
  });

  // 완전한 이미지 URL 반환
  String get fullImageUrl {
    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }
    return imageUrl.startsWith('/')
        ? '${ApiConfig.imageBaseUrl}$imageUrl'
        : '${ApiConfig.imageBaseUrl}/images/$imageUrl';
  }

  // 완전한 프로필 이미지 URL 반환
  String get fullAuthorProfileImageUrl {
    if (authorProfileImageUrl == null || authorProfileImageUrl!.isEmpty) return '';
    if (authorProfileImageUrl!.startsWith('http')) {
      return authorProfileImageUrl!;
    }
    return authorProfileImageUrl!.startsWith('/')
        ? '${ApiConfig.imageBaseUrl}$authorProfileImageUrl'
        : '${ApiConfig.imageBaseUrl}/images/$authorProfileImageUrl';
  }

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        feedId: json['feedId'] as int,
        imageUrl: json['imageUrl'] as String,
        authorUsername: json['authorUsername'] as String?,
        authorProfileImageUrl: json['authorProfileImageUrl'] as String?,
        likeCount: json['likeCount'] as int?,
        commentCount: json['commentCount'] as int?,
        isLiked: json['isLiked'] as bool?,
        createdAt: json['createdAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'feedId': feedId,
        'imageUrl': imageUrl,
        if (authorUsername != null) 'authorUsername': authorUsername,
        if (authorProfileImageUrl != null) 'authorProfileImageUrl': authorProfileImageUrl,
        if (likeCount != null) 'likeCount': likeCount,
        if (commentCount != null) 'commentCount': commentCount,
        if (isLiked != null) 'isLiked': isLiked,
        if (createdAt != null) 'createdAt': createdAt,
      };
}

// 피드 요약 정보 (상세보기용)
class FeedSummary {
  final int feedId;
  final String imageUrl;
  final String authorUsername;
  final String authorProfileImageUrl;
  final int likeCount;
  final int commentCount;

  const FeedSummary({
    required this.feedId,
    required this.imageUrl,
    required this.authorUsername,
    required this.authorProfileImageUrl,
    required this.likeCount,
    required this.commentCount,
  });

  // 완전한 이미지 URL 반환
  String get fullImageUrl {
    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }
    return imageUrl.startsWith('/')
        ? '${ApiConfig.imageBaseUrl}$imageUrl'
        : '${ApiConfig.imageBaseUrl}/images/$imageUrl';
  }

  // 완전한 프로필 이미지 URL 반환
  String get fullAuthorProfileImageUrl {
    if (authorProfileImageUrl.isEmpty) return '';
    if (authorProfileImageUrl.startsWith('http')) {
      return authorProfileImageUrl;
    }
    return authorProfileImageUrl.startsWith('/')
        ? '${ApiConfig.imageBaseUrl}$authorProfileImageUrl'
        : '${ApiConfig.imageBaseUrl}/images/$authorProfileImageUrl';
  }

  factory FeedSummary.fromJson(Map<String, dynamic> json) => FeedSummary(
        feedId: json['feedId'] as int,
        imageUrl: json['imageUrl'] as String,
        authorUsername: json['authorUsername'] as String,
        authorProfileImageUrl: json['authorProfileImageUrl'] as String,
        likeCount: json['likeCount'] as int,
        commentCount: json['commentCount'] as int,
      );

  Map<String, dynamic> toJson() => {
        'feedId': feedId,
        'imageUrl': imageUrl,
        'authorUsername': authorUsername,
        'authorProfileImageUrl': authorProfileImageUrl,
        'likeCount': likeCount,
        'commentCount': commentCount,
      };
}

// 댓글 모델
class Comment {
  final int commentId;
  final String content;
  final String authorUsername;
  final String authorProfileImageUrl;
  final DateTime createdAt;
  final int? parentId;
  final List<Comment>? replies;  // 중첩된 대댓글 추가

  const Comment({
    required this.commentId,
    required this.content,
    required this.authorUsername,
    required this.authorProfileImageUrl,
    required this.createdAt,
    this.parentId,
    this.replies,
  });

  // 완전한 프로필 이미지 URL 반환
  String get fullAuthorProfileImageUrl {
    if (authorProfileImageUrl.isEmpty) return '';
    if (authorProfileImageUrl.startsWith('http')) {
      return authorProfileImageUrl;
    }
    return authorProfileImageUrl.startsWith('/')
        ? '${ApiConfig.imageBaseUrl}$authorProfileImageUrl'
        : '${ApiConfig.imageBaseUrl}/images/$authorProfileImageUrl';
  }

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentId: json['commentId'] as int,
        content: json['content'] as String,
        authorUsername: json['authorUsername'] as String,
        authorProfileImageUrl: json['authorProfileImageUrl'] as String,
        createdAt: json['createdAt'] is String
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.fromMillisecondsSinceEpoch((json['createdAt'] as num).toInt() * 1000),
        parentId: json['parentId'] as int?,
        replies: json['replies'] != null
            ? (json['replies'] as List<dynamic>)
                .map((reply) => Comment.fromJson(reply as Map<String, dynamic>))
                .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'commentId': commentId,
        'content': content,
        'authorUsername': authorUsername,
        'authorProfileImageUrl': authorProfileImageUrl,
        'createdAt': createdAt.toIso8601String(),
        if (parentId != null) 'parentId': parentId,
      };
}

// 좋아요/댓글 요청 모델
class LikeRequest {
  final String targetType; // "FEED" or "COMMENT"
  final int targetId;

  const LikeRequest({
    required this.targetType,
    required this.targetId,
  });

  Map<String, dynamic> toJson() => {
        'targetType': targetType,
        'targetId': targetId,
      };
}

// 댓글 작성 요청 모델
class CommentRequest {
  final int targetId;
  final String targetType; // "FEED" or "COMMENT"
  final String content;

  const CommentRequest({
    required this.targetId,
    required this.targetType,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'targetId': targetId,
      'targetType': targetType,
      'content': content,
    };
  }
}

// API 응답 래퍼
class ApiResponse<T> {
  final T data;
  final PageInfo pageInfo;

  const ApiResponse({
    required this.data,
    required this.pageInfo,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) =>
      ApiResponse(
        data: fromJsonT(json['data']),
        pageInfo: PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
      );
}

// 대상 타입 열거형
enum TargetType {
  feed('FEED'),
  comment('COMMENT');

  const TargetType(this.value);
  final String value;
}