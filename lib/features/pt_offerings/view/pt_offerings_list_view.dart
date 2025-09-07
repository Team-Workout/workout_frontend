import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../model/pt_offering_model.dart';
import '../viewmodel/pt_offering_viewmodel.dart';
import '../../pt_applications/viewmodel/pt_application_viewmodel.dart';
import '../../../core/theme/notion_colors.dart';
import '../../dashboard/widgets/notion_button.dart';

class PtOfferingsListView extends ConsumerStatefulWidget {
  final int? trainerId; // null이면 현재 로그인한 트레이너의 상품, 값이 있으면 해당 트레이너의 상품
  final bool isTrainerView; // true면 트레이너 관리 뷰, false면 회원 조회 뷰

  const PtOfferingsListView({
    super.key,
    this.trainerId,
    this.isTrainerView = true,
  });

  @override
  ConsumerState<PtOfferingsListView> createState() => _PtOfferingsListViewState();
}

class _PtOfferingsListViewState extends ConsumerState<PtOfferingsListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPtOfferings();
    });
  }

  void _loadPtOfferings() {
    int targetTrainerId;
    
    if (widget.trainerId != null) {
      targetTrainerId = widget.trainerId!;
    } else {
      final user = ref.read(currentUserProvider);
      if (user?.id == null) return;
      targetTrainerId = int.parse(user!.id);
    }

    ref.read(ptOfferingProvider.notifier).loadPtOfferings(targetTrainerId);
  }

  @override
  Widget build(BuildContext context) {
    final ptOfferingsAsync = ref.watch(ptOfferingProvider);
    
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
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.isTrainerView ? 'PT 상품 관리' : 'PT 상품',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        actions: widget.isTrainerView
            ? [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    final result = await context.push('/pt-offerings/create');
                    if (result == true) {
                      _loadPtOfferings();
                    }
                  },
                  tooltip: 'PT 상품 추가',
                ),
              ]
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadPtOfferings();
        },
        child: ptOfferingsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: NotionColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'PT 상품을 불러오는 중 오류가 발생했습니다',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'IBMPlexSansKR',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NotionColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                NotionButton(
                  onPressed: _loadPtOfferings,
                  text: '다시 시도',
                  icon: Icons.refresh,
                ),
              ],
            ),
          ),
          data: (offerings) {
            if (offerings.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: offerings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final offering = offerings[index];
                return _buildOfferingCard(offering);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF10B981).withValues(alpha: 0.1),
                  const Color(0xFF34D399).withValues(alpha: 0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fitness_center_outlined,
              size: 60,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.isTrainerView ? '등록된 PT 상품이 없습니다' : '해당 트레이너의 PT 상품이 없습니다',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF10B981),
              fontWeight: FontWeight.bold,
              fontFamily: 'IBMPlexSansKR',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            widget.isTrainerView
                ? '새로운 PT 상품을 추가해보세요'
                : '다른 트레이너의 상품을 확인해보세요',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
              fontFamily: 'IBMPlexSansKR',
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.isTrainerView) ...[
            const SizedBox(height: 32),
            NotionButton(
              onPressed: () async {
                final result = await context.push('/pt-offerings/create');
                if (result == true) {
                  _loadPtOfferings();
                }
              },
              text: 'PT 상품 추가',
              icon: Icons.add,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOfferingCard(PtOffering offering) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF10B981).withValues(alpha: 0.1),
                        const Color(0xFF34D399).withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offering.title,
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (offering.trainerName != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${offering.trainerName} 트레이너',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.isTrainerView)
                  Container(
                    decoration: BoxDecoration(
                      color: NotionColors.gray100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: NotionColors.error,
                        size: 18,
                      ),
                      onPressed: () => _deleteOffering(offering),
                      tooltip: '삭제',
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ),
              ],
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offering.description,
                    style: TextStyle(
                      color: NotionColors.textSecondary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  
                  // Price and Sessions Info
                  Row(
                    children: [
                      Expanded(
                        child: _buildCleanInfoItem(
                          icon: Icons.payments_outlined,
                          label: '가격',
                          value: '₩${_formatPrice(offering.price)}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCleanInfoItem(
                          icon: Icons.fitness_center_outlined,
                          label: '세션',
                          value: '${offering.totalSessions}회',
                        ),
                      ),
                    ],
                  ),
                  
                  if (!widget.isTrainerView) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: _buildCleanBookingButton(offering),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NotionColors.gray100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: NotionColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: NotionColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: NotionColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: NotionColors.black,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanBookingButton(PtOffering offering) {
    return Container(
      decoration: BoxDecoration(
        color: NotionColors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _bookPtOffering(offering),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: NotionColors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  '예약하기',
                  style: TextStyle(
                    color: NotionColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  void _deleteOffering(PtOffering offering) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PT 상품 삭제'),
        content: Text('${offering.title}을(를) 정말 삭제하시겠습니까?\n\n삭제된 상품은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performDelete(offering);
            },
            style: TextButton.styleFrom(foregroundColor: NotionColors.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  Future<void> _performDelete(PtOffering offering) async {
    try {
      // 현재 로그인한 사용자 ID 가져오기
      final user = ref.read(currentUserProvider);
      if (user?.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인이 필요합니다.')),
        );
        return;
      }

      final trainerId = int.parse(user!.id);

      // 로딩 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final success = await ref
          .read(ptOfferingProvider.notifier)
          .deletePtOffering(offering.id, trainerId);

      if (mounted) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PT 상품이 성공적으로 삭제되었습니다.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _bookPtOffering(PtOffering offering) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: NotionColors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: NotionColors.black,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: NotionColors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fitness_center,
                        color: NotionColors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'PT 신청하기',
                      style: TextStyle(
                        color: NotionColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: NotionColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: NotionColors.border,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_offer,
                                color: NotionColors.black,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  offering.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDialogInfoRow(
                            Icons.payments,
                            '가격',
                            '₩${_formatPrice(offering.price)}',
                            NotionColors.black,
                          ),
                          const SizedBox(height: 8),
                          _buildDialogInfoRow(
                            Icons.event_repeat,
                            '세션',
                            '${offering.totalSessions}회',
                            NotionColors.black,
                          ),
                          if (offering.trainerName != null) ...[
                            const SizedBox(height: 8),
                            _buildDialogInfoRow(
                              Icons.person,
                              '트레이너',
                              offering.trainerName!,
                              NotionColors.black,
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Info Message
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: NotionColors.gray100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: NotionColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: NotionColors.black,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'PT 신청 후 트레이너의 승인을 기다려주세요.',
                              style: TextStyle(
                                color: NotionColors.black,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Actions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: NotionColors.gray100,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: NotionColors.textSecondary),
                          ),
                        ),
                        child: Text(
                          '취소',
                          style: TextStyle(
                            color: NotionColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: NotionColors.black,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: NotionColors.border),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              Navigator.pop(context);
                              await _performBooking(offering);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: const Center(
                                child: Text(
                                  '신청하기',
                                  style: TextStyle(
                                    color: NotionColors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
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
  }

  Widget _buildDialogInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: TextStyle(
            color: NotionColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Future<void> _performBooking(PtOffering offering) async {
    try {
      // 로딩 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('PT를 신청하고 있습니다...'),
            ],
          ),
        ),
      );

      final success = await ref
          .read(ptApplicationProvider.notifier)
          .createPtApplication(offering.id);

      if (mounted) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${offering.title} PT 신청이 완료되었습니다!'),
              backgroundColor: NotionColors.black,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: NotionColors.error,
          ),
        );
      }
    }
  }
}