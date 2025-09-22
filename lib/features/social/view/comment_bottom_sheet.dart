import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/auth_provider.dart';
import '../model/feed_models.dart';
import '../service/feed_service.dart';
import '../widget/profile_avatar.dart';

class CommentBottomSheet extends ConsumerStatefulWidget {
  final int feedId;
  final int commentCount;
  final VoidCallback onCommentAdded;

  const CommentBottomSheet({
    Key? key,
    required this.feedId,
    required this.commentCount,
    required this.onCommentAdded,
  }) : super(key: key);

  @override
  ConsumerState<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends ConsumerState<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  List<Comment> _comments = [];
  Map<int, List<Comment>> _replies = {};  // 댓글ID별 대댓글 리스트
  bool _isLoading = true;
  bool _isSubmitting = false;
  Comment? _replyingTo;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final feedService = ref.read(feedServiceProvider);
      final response = await feedService.getFeedComments(
        feedId: widget.feedId,
        page: 0,
        size: 50,
        sort: ['createdAt,asc'],  // 시간순으로 정렬하여 대댓글이 부모 댓글 아래 나오도록
      );
      
      // 평면 구조의 댓글을 부모-자식 구조로 변환
      List<Comment> parentComments = [];
      Map<int, List<Comment>> repliesMap = {};
      
      for (var comment in response.data) {
        if (comment.parentId == null) {
          // 부모 댓글
          parentComments.add(comment);
        } else {
          // 대댓글
          if (!repliesMap.containsKey(comment.parentId)) {
            repliesMap[comment.parentId!] = [];
          }
          repliesMap[comment.parentId!]!.add(comment);
        }
      }
      
      setState(() {
        _comments = parentComments;
        _replies = repliesMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '댓글을 불러오는데 실패했습니다: ${e.toString()}',
              style: const TextStyle(fontFamily: 'IBMPlexSansKR'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }


  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final feedService = ref.read(feedServiceProvider);
      
      // 임시로 parentId 없이 시도 (백엔드 대댓글 기능 확인용)
      final response = await feedService.createComment(
        targetId: widget.feedId,               // 항상 피드 ID 사용
        targetType: "FEED",                   // 항상 FEED 타입 사용
        content: content,
        // parentId: _replyingTo?.commentId,   // 임시로 주석 처리
      );

      // 댓글 목록 새로고침
      await _loadComments();
      
      setState(() {
        _commentController.clear();
        _isSubmitting = false;
        _replyingTo = null;
      });
      
      widget.onCommentAdded();

      // 새 댓글이 추가되었다는 메시지
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _replyingTo != null ? '답글이 작성되었습니다' : '댓글이 작성되었습니다',
              style: const TextStyle(fontFamily: 'IBMPlexSansKR'),
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '댓글 작성에 실패했습니다: ${e.toString()}',
              style: const TextStyle(fontFamily: 'IBMPlexSansKR'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _onReplyTap(Comment comment) {
    setState(() {
      _replyingTo = comment;
      _commentController.text = '@${comment.authorUsername} ';
    });
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
      _commentController.clear();
    });
  }

  Future<void> _deleteComment(Comment comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEF4444), Color(0xFFF87171)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '댓글 삭제',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '이 댓글을 삭제하시겠습니까?\n삭제된 댓글은 복구할 수 없습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'IBMPlexSansKR',
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                        child: Text(
                          '취소',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, height: 50, color: Colors.grey[300]),
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                        child: const Text(
                          '삭제',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      try {
        final feedService = ref.read(feedServiceProvider);
        await feedService.deleteComment(comment.commentId);

        // 댓글 목록 새로고침
        await _loadComments();
        widget.onCommentAdded(); // 댓글 수 업데이트

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('댓글이 삭제되었습니다.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('댓글 삭제에 실패했습니다: ${e.toString()}')),
          );
        }
      }
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return DateFormat('MM월 dd일').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 핸들러
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '댓글 ${NumberFormat('#,###').format(widget.commentCount)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // 댓글 목록
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF10B981),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      return _CommentItem(
                        comment: _comments[index],
                        replies: _replies[_comments[index].commentId] ?? [],
                        onReplyTap: _onReplyTap,
                        onDeleteTap: _deleteComment,
                        formatTimeAgo: _formatTimeAgo,
                      );
                    },
                  ),
          ),
          
          // 답글 표시 (있는 경우)
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[50],
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '@${_replyingTo!.authorUsername}님에게 답글 작성 중',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _cancelReply,
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          
          // 댓글 입력
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    focusNode: _focusNode,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: _replyingTo != null ? '답글 작성...' : '댓글 작성...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontFamily: 'IBMPlexSansKR',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFF10B981)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _isSubmitting ? null : _submitComment,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _isSubmitting 
                          ? Colors.grey[300] 
                          : const Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentItem extends ConsumerWidget {
  final Comment comment;
  final List<Comment> replies;
  final Function(Comment) onReplyTap;
  final Function(Comment) onDeleteTap;
  final String Function(DateTime) formatTimeAgo;

  const _CommentItem({
    required this.comment,
    required this.replies,
    required this.onReplyTap,
    required this.onDeleteTap,
    required this.formatTimeAgo,
  });

  Widget _buildCommentText(String content, {required double fontSize}) {
    final mentionRegex = RegExp(r'@(\w+)');
    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (final match in mentionRegex.allMatches(content)) {
      // 멘션 이전 텍스트 추가
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: content.substring(lastEnd, match.start),
          style: TextStyle(
            fontSize: fontSize,
            color: const Color(0xFF374151),
            fontFamily: 'IBMPlexSansKR',
          ),
        ));
      }

      // 멘션 텍스트 추가 (파란색)
      spans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(
          fontSize: fontSize,
          color: const Color(0xFF3B82F6), // 파란색
          fontWeight: FontWeight.w600,
          fontFamily: 'IBMPlexSansKR',
        ),
      ));

      lastEnd = match.end;
    }

    // 남은 텍스트 추가
    if (lastEnd < content.length) {
      spans.add(TextSpan(
        text: content.substring(lastEnd),
        style: TextStyle(
          fontSize: fontSize,
          color: const Color(0xFF374151),
          fontFamily: 'IBMPlexSansKR',
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateProvider).value;

    return Column(
      children: [
        // 원댓글
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatar(
                radius: 16,
                imageUrl: comment.fullAuthorProfileImageUrl,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.authorUsername,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formatTimeAgo(comment.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        const Spacer(),
                        if (currentUser?.name == comment.authorUsername)
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'delete') {
                                onDeleteTap(comment);
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.black.withValues(alpha: 0.2),
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          color: Color(0xFFEF4444),
                                          size: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        '삭제',
                                        style: TextStyle(
                                          color: Color(0xFFEF4444),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'IBMPlexSansKR',
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            icon: Icon(
                              Icons.more_horiz,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildCommentText(
                      comment.content,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => onReplyTap(comment),
                      child: Text(
                        '답글 달기',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // 대댓글들
        if (replies.isNotEmpty)
          ...replies.map(
            (reply) => Container(
              margin: const EdgeInsets.only(left: 32, right: 16, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border(
                  left: BorderSide(
                    color: Colors.grey[300]!,
                    width: 3,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileAvatar(
                      radius: 12,
                      imageUrl: reply.fullAuthorProfileImageUrl,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                reply.authorUsername,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Color(0xFF1F2937),
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                formatTimeAgo(reply.createdAt),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                              const Spacer(),
                              if (currentUser?.name == reply.authorUsername)
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      onDeleteTap(reply);
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.white,
                                  elevation: 8,
                                  shadowColor: Colors.black.withValues(alpha: 0.2),
                                  itemBuilder: (context) => [
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Icon(
                                                Icons.delete_outline,
                                                color: Color(0xFFEF4444),
                                                size: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              '삭제',
                                              style: TextStyle(
                                                color: Color(0xFFEF4444),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'IBMPlexSansKR',
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  icon: Icon(
                                    Icons.more_horiz,
                                    size: 14,
                                    color: Colors.grey[400],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          _buildCommentText(
                            reply.content,
                            fontSize: 13,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}