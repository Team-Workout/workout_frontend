import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../model/feed_models.dart';
import '../service/feed_service.dart';
import '../widget/profile_avatar.dart';
import 'comment_bottom_sheet.dart';

class FeedDetailView extends ConsumerStatefulWidget {
  final int feedId;

  const FeedDetailView({
    Key? key,
    required this.feedId,
  }) : super(key: key);

  @override
  ConsumerState<FeedDetailView> createState() => _FeedDetailViewState();
}

class _FeedDetailViewState extends ConsumerState<FeedDetailView> {
  FeedSummary? _feedSummary;
  bool _isLoading = true;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadFeedSummary();
  }

  Future<void> _loadFeedSummary() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final feedService = ref.read(feedServiceProvider);
      final response = await feedService.getFeedSummary(widget.feedId);
      
      setState(() {
        _feedSummary = response.data;
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
              '피드 정보를 불러오는데 실패했습니다: ${e.toString()}',
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

  Future<void> _toggleLike() async {
    if (_feedSummary == null) return;

    final wasLiked = _isLiked;
    setState(() {
      _isLiked = !_isLiked;
      _feedSummary = FeedSummary(
        feedId: _feedSummary!.feedId,
        imageUrl: _feedSummary!.imageUrl,
        authorUsername: _feedSummary!.authorUsername,
        authorProfileImageUrl: _feedSummary!.authorProfileImageUrl,
        likeCount: _isLiked 
            ? _feedSummary!.likeCount + 1 
            : _feedSummary!.likeCount - 1,
        commentCount: _feedSummary!.commentCount,
      );
    });

    try {
      final feedService = ref.read(feedServiceProvider);
      await feedService.toggleLike(
        targetType: "FEED",
        targetId: widget.feedId,
      );
    } catch (e) {
      // 실패 시 원복
      setState(() {
        _isLiked = wasLiked;
        _feedSummary = FeedSummary(
          feedId: _feedSummary!.feedId,
          imageUrl: _feedSummary!.imageUrl,
          authorUsername: _feedSummary!.authorUsername,
          authorProfileImageUrl: _feedSummary!.authorProfileImageUrl,
          likeCount: wasLiked 
              ? _feedSummary!.likeCount + 1 
              : _feedSummary!.likeCount - 1,
          commentCount: _feedSummary!.commentCount,
        );
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '좋아요 처리에 실패했습니다: ${e.toString()}',
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

  void _showComments() {
    if (_feedSummary == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentBottomSheet(
        feedId: widget.feedId,
        commentCount: _feedSummary!.commentCount,
        onCommentAdded: () {
          setState(() {
            _feedSummary = FeedSummary(
              feedId: _feedSummary!.feedId,
              imageUrl: _feedSummary!.imageUrl,
              authorUsername: _feedSummary!.authorUsername,
              authorProfileImageUrl: _feedSummary!.authorProfileImageUrl,
              likeCount: _feedSummary!.likeCount,
              commentCount: _feedSummary!.commentCount + 1,
            );
          });
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmDialog() async {
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
                      '피드 삭제',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '이 피드를 삭제하시겠습니까?\n삭제된 피드는 복구할 수 없습니다.',
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
      await _deleteFeed();
    }
  }

  Future<void> _deleteFeed() async {
    try {
      final feedService = ref.read(feedServiceProvider);
      await feedService.deleteFeed(widget.feedId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('피드가 삭제되었습니다.')),
        );
        // 피드 목록으로 돌아가기
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('피드 삭제에 실패했습니다: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'IBMPlexSansKR',
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            if (_feedSummary != null)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                elevation: 8,
                shadowColor: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 8),
                onSelected: (value) async {
                  if (value == 'delete') {
                    await _showDeleteConfirmDialog();
                  }
                },
                itemBuilder: (context) {
                  final currentUser = ref.watch(authStateProvider).value;
                  final isAuthor = currentUser?.name == _feedSummary?.authorUsername;

                  return [
                    if (isAuthor)
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Color(0xFFEF4444),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                '삭제하기',
                                style: TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (!isAuthor)
                      PopupMenuItem<String>(
                        value: 'report',
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.flag_outlined,
                                  color: Colors.grey[600],
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '신고하기',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ];
                },
              ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF10B981),
                ),
              )
            : _feedSummary == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '피드를 불러올 수 없습니다',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      // 사용자 정보
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            ProfileAvatar(
                              radius: 20,
                              imageUrl: _feedSummary!.fullAuthorProfileImageUrl,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _feedSummary!.authorUsername,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 이미지
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: InteractiveViewer(
                            minScale: 1.0,
                            maxScale: 3.0,
                            child: Image.network(
                              _feedSummary!.fullImageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: const Color(0xFF10B981),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        '이미지를 불러올 수 없습니다',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontFamily: 'IBMPlexSansKR',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      // 하단 액션 바
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 좋아요, 댓글 버튼
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: _toggleLike,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      _isLiked ? Icons.favorite : Icons.favorite_border,
                                      color: _isLiked ? Colors.red : Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: _showComments,
                                  child: const Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // 좋아요 수
                            if (_feedSummary!.likeCount > 0)
                              Text(
                                '좋아요 ${NumberFormat('#,###').format(_feedSummary!.likeCount)}개',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                            
                            const SizedBox(height: 8),
                            
                            // 댓글 보기
                            if (_feedSummary!.commentCount > 0)
                              GestureDetector(
                                onTap: _showComments,
                                child: Text(
                                  '댓글 ${NumberFormat('#,###').format(_feedSummary!.commentCount)}개 보기',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
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
    );
  }
}