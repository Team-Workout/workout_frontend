import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../model/feed_models.dart';
import '../service/feed_service.dart';
import 'feed_detail_view.dart';

class SocialFeedView extends ConsumerStatefulWidget {
  const SocialFeedView({Key? key}) : super(key: key);

  @override
  ConsumerState<SocialFeedView> createState() => _SocialFeedViewState();
}

class _SocialFeedViewState extends ConsumerState<SocialFeedView> {
  final ScrollController _scrollController = ScrollController();
  List<Feed> _feeds = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int? _lastFeedId;
  bool _isPullingUp = false;
  double _pullDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadFeeds();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _loadMoreFeeds();
      }
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      // 스크롤이 끝에 도달했고 아래로 더 당기고 있는 경우
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
        final overscroll = _scrollController.position.pixels - _scrollController.position.maxScrollExtent;
        if (overscroll > 0) {
          setState(() {
            _pullDistance = overscroll;
            _isPullingUp = overscroll > 50; // 50px 이상 당기면 활성화
          });
        }
      } else {
        if (_isPullingUp) {
          setState(() {
            _isPullingUp = false;
            _pullDistance = 0.0;
          });
        }
      }
    } else if (notification is ScrollEndNotification) {
      // 당기기가 끝났을 때
      if (_isPullingUp && _pullDistance > 50) {
        _onRefresh(); // 새로고침 실행
      }
      setState(() {
        _isPullingUp = false;
        _pullDistance = 0.0;
      });
    }
    return true;
  }

  Future<void> _loadFeeds() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final feedService = ref.read(feedServiceProvider);
      // TODO: 실제 gymId 가져오기 (임시로 1 사용)
      final response = await feedService.getFeeds(gymId: 1);
      
      setState(() {
        _feeds = response.data;
        _lastFeedId = _feeds.isNotEmpty ? _feeds.last.feedId : null;
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
              '피드를 불러오는데 실패했습니다: ${e.toString()}',
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

  Future<void> _loadMoreFeeds() async {
    if (_isLoading || !_hasMore) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final feedService = ref.read(feedServiceProvider);
      // TODO: 실제 gymId 가져오기 (임시로 1 사용)
      final response = await feedService.getFeeds(
        gymId: 1, 
        lastFeedId: _lastFeedId,
      );
      
      setState(() {
        _feeds.addAll(response.data);
        _lastFeedId = response.data.isNotEmpty ? response.data.last.feedId : _lastFeedId;
        _isLoading = false;
        _hasMore = !response.pageInfo.last;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '추가 피드를 불러오는데 실패했습니다: ${e.toString()}',
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

  Future<void> _onRefresh() async {
    // 전체 피드를 처음부터 다시 로드 (인스타그램 스타일)
    setState(() {
      _feeds.clear();
      _lastFeedId = null;
      _hasMore = true;
    });
    await _loadFeeds();
  }

  void _onFeedTap(Feed feed) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FeedDetailView(feedId: feed.feedId),
      ),
    );
  }

  void _showCreateFeedBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateFeedBottomSheet(
        onFeedCreated: () {
          // 새 피드 생성 후 자동 새로고침
          _onRefresh();
        },
      ),
    );
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
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            '소셜',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: _showCreateFeedBottomSheet,
              icon: const Icon(
                Icons.add_circle_outline,
                color: Color(0xFF10B981),
                size: 28,
              ),
            ),
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: const Color(0xFF10B981),
            backgroundColor: Colors.white,
            strokeWidth: 2.5,
            displacement: 40.0,
            child: _feeds.isEmpty && _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF10B981),
                  ),
                )
              : CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    const SliverPadding(
                      padding: EdgeInsets.only(top: 8),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= _feeds.length) {
                              return const SizedBox();
                            }
                            return _FeedGridItem(
                              feed: _feeds[index],
                              onTap: () => _onFeedTap(_feeds[index]),
                            );
                          },
                          childCount: _feeds.length,
                        ),
                      ),
                    ),
                    if (_isLoading && _feeds.isNotEmpty)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ),
                    if (!_hasMore && _feeds.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Text(
                              '모든 피드를 확인했습니다',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ),
                        ),
                      ),
                    // 아래로 당기기 피드백 위젯
                    if (_isPullingUp)
                      SliverToBoxAdapter(
                        child: Container(
                          height: _pullDistance.clamp(0, 100),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.rotate(
                                  angle: (_pullDistance / 100) * 3.14159, // 180도 회전
                                  child: Icon(
                                    Icons.refresh,
                                    color: Color(0xFF10B981),
                                    size: 20 + (_pullDistance / 10).clamp(0, 8),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _pullDistance > 50 ? '놓으면 새로고침' : '아래로 당겨서 새로고침',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontFamily: 'IBMPlexSansKR',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SliverPadding(
                      padding: EdgeInsets.only(bottom: 100),
                    ),
                  ],
                ),
            ),
          ),
        ),
    );
  }
}

class _FeedGridItem extends StatelessWidget {
  final Feed feed;
  final VoidCallback onTap;

  const _FeedGridItem({
    required this.feed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            feed.fullImageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: const Color(0xFF10B981),
                    strokeWidth: 2,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: Icon(
                  Icons.error_outline,
                  color: Colors.grey[400],
                  size: 32,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CreateFeedBottomSheet extends ConsumerStatefulWidget {
  final VoidCallback? onFeedCreated;
  
  const _CreateFeedBottomSheet({
    this.onFeedCreated,
  });
  
  @override
  ConsumerState<_CreateFeedBottomSheet> createState() => _CreateFeedBottomSheetState();
}

class _CreateFeedBottomSheetState extends ConsumerState<_CreateFeedBottomSheet> {
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    try {
      // 이미지 선택 (프로필 이미지 업로드와 동일한 설정)
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image == null) return;

      // 파일 형식 검증 (서버 업로드 전에 미리 확인)
      final String fileName = image.name.toLowerCase();
      if (!fileName.endsWith('.jpg') && 
          !fileName.endsWith('.jpeg') && 
          !fileName.endsWith('.png') && 
          !fileName.endsWith('.webp')) {
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                '지원하지 않는 이미지 형식입니다. JPG, PNG, WebP만 가능합니다.',
                style: TextStyle(fontFamily: 'IBMPlexSansKR'),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        return;
      }
      
      setState(() {
        _isUploading = true;
      });
      
      // 실제 API 호출
      final feedService = ref.read(feedServiceProvider);
      final response = await feedService.createFeed(
        imageFile: File(image.path),
      );
      
      setState(() {
        _isUploading = false;
      });
      
      if (mounted) {
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '피드가 업로드되었습니다! 🎉',
              style: const TextStyle(fontFamily: 'IBMPlexSansKR'),
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        
        // 피드 목록 새로고침을 위해 부모에게 알림
        widget.onFeedCreated?.call();
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '업로드 실패: ${e.toString()}',
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '오운완 인증하기',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '운동 완료 사진을 업로드해 보세요!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
            const SizedBox(height: 32),
            if (_isUploading)
              const Column(
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF10B981),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '업로드 중...',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_camera, color: Colors.white),
                  label: const Text(
                    '사진 선택하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}