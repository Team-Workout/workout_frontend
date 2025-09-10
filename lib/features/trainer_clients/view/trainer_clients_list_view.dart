import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/trainer_client_viewmodel.dart';
import '../model/trainer_client_model.dart';
import '../../../services/image_cache_manager.dart';
import 'trainer_client_detail_view.dart';
import '../../dashboard/widgets/notion_button.dart';
class TrainerClientsListView extends ConsumerStatefulWidget {
  const TrainerClientsListView({super.key});

  @override
  ConsumerState<TrainerClientsListView> createState() => _TrainerClientsListViewState();
}

class _TrainerClientsListViewState extends ConsumerState<TrainerClientsListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      ref.read(trainerClientListProvider.notifier).loadMoreClients();
    }
  }

  List<TrainerClient> _filterClients(List<TrainerClient> clients) {
    if (_searchQuery.isEmpty) {
      return clients;
    }
    return clients.where((client) {
      return client.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             (client.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final clientsState = ref.watch(trainerClientListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10B981), Color(0xFF34D399), Color(0xFF6EE7B7)],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '내 PT 회원',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(trainerClientListProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색 바
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  fontFamily: 'IBMPlexSansKR',
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: '회원 이름 또는 이메일로 검색...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontFamily: 'IBMPlexSansKR',
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFF10B981),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
          
          Expanded(
            child: clientsState.when(
              data: (clientsResponse) {
                final allClients = clientsResponse.data;
                final filteredClients = _filterClients(allClients);
                
                if (filteredClients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _searchQuery.isEmpty ? Icons.people_outline : Icons.search_off,
                            size: 64,
                            color: const Color(0xFF10B981).withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _searchQuery.isEmpty 
                              ? '아직 관리 중인 회원이 없습니다'
                              : '검색 결과가 없습니다',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'PT 계약이 체결된 회원이 여기에 표시됩니다',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'IBMPlexSansKR',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.read(trainerClientListProvider.notifier).refresh(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredClients.length + 1, // +1 for loading indicator
                    itemBuilder: (context, index) {
                      if (index == filteredClients.length) {
                        // 로딩 인디케이터 (더 불러올 데이터가 있을 때)
                        if (!clientsResponse.pageInfo.last && _searchQuery.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return const SizedBox.shrink();
                      }

                      final client = filteredClients[index];
                      return _buildClientCard(client);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '회원 목록을 불러오는데 실패했습니다',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    NotionButton(
                      onPressed: () {
                        ref.read(trainerClientListProvider.notifier).refresh();
                      },
                      text: '다시 시도',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(TrainerClient client) {
    return FutureBuilder<String?>(
      future: client.profileImageUrl != null && client.profileImageUrl!.isNotEmpty
          ? ImageCacheManager().getCachedImage(
              imageUrl: client.profileImageUrl!,
              cacheKey: 'member_${client.memberId}',
              type: ImageType.profile,
            ).catchError((error) {
              // 이미지 로딩 실패 시 null 반환
              print('프로필 이미지 로딩 실패: $error');
              return null;
            })
          : Future.value(null),
      builder: (context, snapshot) {
        // 이미지 로딩 상태 확인
        final hasValidImage = snapshot.connectionState == ConnectionState.done && 
                             !snapshot.hasError &&
                             snapshot.hasData && 
                             snapshot.data != null && 
                             File(snapshot.data!).existsSync();
        final isGenderMale = client.gender == 'MALE';
        final genderColor = isGenderMale ? const Color(0xFF3B82F6) : const Color(0xFFEC4899);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainerClientDetailView(
                      client: client,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // 프로필 섹션
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF10B981).withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: const Color(0xFF10B981).withOpacity(0.1),
                                backgroundImage: hasValidImage
                                    ? FileImage(File(snapshot.data!))
                                    : null,
                                child: hasValidImage
                                    ? null
                                    : snapshot.connectionState == ConnectionState.waiting
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                                            ),
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: 36,
                                            color: const Color(0xFF10B981).withOpacity(0.7),
                                          ),
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(width: 20),
                        
                        // 회원 정보 섹션
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      client.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontFamily: 'IBMPlexSansKR',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: genderColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: genderColor.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      isGenderMale ? '남성' : '여성',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: genderColor,
                                        fontFamily: 'IBMPlexSansKR',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      client.email ?? '이메일 정보 없음',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontFamily: 'IBMPlexSansKR',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    client.gymName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      fontFamily: 'IBMPlexSansKR',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 상태 및 액션 섹션
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF10B981).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '활성',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    fontFamily: 'IBMPlexSansKR',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '상세 정보',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'IBMPlexSansKR',
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: Color(0xFF10B981),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}