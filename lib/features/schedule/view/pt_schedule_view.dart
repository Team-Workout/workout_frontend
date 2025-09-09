import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../pt_contract/model/pt_appointment_models.dart';
import '../../pt_contract/model/pt_contract_models.dart';
import '../../pt_contract/viewmodel/pt_contract_viewmodel.dart';
import '../../auth/model/user_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../dashboard/widgets/notion_button.dart';

class PTScheduleView extends ConsumerStatefulWidget {
  final bool isDirectAccess;
  
  const PTScheduleView({
    super.key,
    this.isDirectAccess = false,
  });

  @override
  ConsumerState<PTScheduleView> createState() => _PTScheduleViewState();
}

class _PTScheduleViewState extends ConsumerState<PTScheduleView> {
  PtAppointmentsResponse? _appointmentsResponse;
  bool _isLoading = true;
  String _selectedStatus = 'SCHEDULED';
  
  final List<Map<String, String>> _statusOptions = [
    {'value': 'MEMBER_REQUESTED', 'label': '요청됨'},
    {'value': 'SCHEDULED', 'label': '예정됨'},
    {'value': 'COMPLETED', 'label': '완료됨'},
    {'value': 'CANCELLED', 'label': '취소됨'},
    {'value': 'CHANGE_REQUESTED', 'label': '변경요청'},
    {'value': 'TRAINER_CHANGE_REQUESTED', 'label': '트레이너변경요청'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContracts();
      _loadAppointments();
    });
  }
  
  Future<void> _loadContracts() async {
    try {
      await ref.read(ptContractViewModelProvider.notifier).loadMyContracts(
        page: 0,
        size: 20,
      );
    } catch (e) {
      print('PT 계약 정보 로드 실패: $e');
    }
  }
  
  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ref
          .read(ptContractViewModelProvider.notifier)
          .getMyScheduledAppointments(
            status: _selectedStatus,
            size: 50,
          );
      
      setState(() {
        _appointmentsResponse = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // 에러가 발생해도 빈 응답으로 처리하여 UI가 정상적으로 표시되도록 함
        _appointmentsResponse = const PtAppointmentsResponse(
          data: [],
          totalElements: 0,
          totalPages: 0,
          currentPage: 0,
          hasNext: false,
          hasPrevious: false,
        );
      });
      
      print('PT 예약 목록 로드 실패: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'PT 예약 조회 API가 개발 중입니다.\n현재는 PT 계약 관리 기능을 사용해주세요.',
                    style: TextStyle(fontFamily: 'IBMPlexSansKR'),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.blue[600],
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    // 직접 접근시 또는 트레이너일 때 Scaffold로 감싸고 AppBar 추가
    if (widget.isDirectAccess || user?.userType == UserType.trainer) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
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
          title: const Text(
            'PT 예약 목록',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          centerTitle: true,
        ),
        body: _buildScheduleContent(),
      );
    }

    // 탭 뷰에서 사용시 Container로 반환
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF10B981).withValues(alpha: 0.02),
            const Color(0xFF34D399).withValues(alpha: 0.03),
            const Color(0xFF6EE7B7).withValues(alpha: 0.02),
          ],
        ),
      ),
      child: _buildScheduleContent(),
    );
  }

  Widget _buildScheduleContent() {
    return Column(
      children: [
        // 상태 필터 탭
        _buildStatusFilter(),
        
        // 예약 목록
        Expanded(
          child: _isLoading 
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF10B981),
                    strokeWidth: 3,
                  ),
                )
              : _buildAppointmentsList(),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: _statusOptions.map((option) {
            final isSelected = _selectedStatus == option['value'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStatus = option['value']!;
                  });
                  _loadAppointments();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF34D399)],
                          )
                        : null,
                    color: isSelected ? null : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected 
                          ? Colors.transparent 
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    option['label']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    final contractState = ref.watch(ptContractViewModelProvider);
    
    return contractState.when(
      data: (contractResponse) {
        if (contractResponse == null || contractResponse.data.isEmpty) {
          return _buildEmptyState();
        }

        final contracts = contractResponse.data;
        
        return RefreshIndicator(
          onRefresh: _loadContracts,
          color: const Color(0xFF10B981),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: contracts.length,
            itemBuilder: (context, index) {
              final contract = contracts[index];
              return _buildContractCard(contract);
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF10B981),
        ),
      ),
      error: (error, stackTrace) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'PT 계약 정보를 불러올 수 없습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _loadContracts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppointmentCard(PtAppointment appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showAppointmentDetail(appointment),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 (트레이너명 + 상태)
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.person,
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
                          '${appointment.trainerName} 트레이너',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDateTime(appointment.startTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(appointment.status),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 시간 정보
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_formatTime(appointment.startTime)} - ${_formatTime(appointment.endTime)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF10B981),
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ],
                ),
              ),
              
              // 변경 요청이 있는 경우
              if (appointment.changeRequestStartTime != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.schedule_outlined,
                        size: 16,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '변경 요청: ${_formatTime(appointment.changeRequestStartTime!)} - ${_formatTime(appointment.changeRequestEndTime!)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    
    switch (status) {
      case 'MEMBER_REQUESTED':
        color = Colors.blue;
        text = '요청됨';
        break;
      case 'SCHEDULED':
        color = const Color(0xFF10B981);
        text = '예정됨';
        break;
      case 'COMPLETED':
        color = Colors.purple;
        text = '완료됨';
        break;
      case 'CANCELLED':
        color = Colors.red;
        text = '취소됨';
        break;
      case 'CHANGE_REQUESTED':
        color = Colors.orange;
        text = '변경요청';
        break;
      case 'TRAINER_CHANGE_REQUESTED':
        color = Colors.deepOrange;
        text = '트레이너변경요청';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          fontFamily: 'IBMPlexSansKR',
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.event_busy_outlined,
              size: 48,
              color: const Color(0xFF10B981).withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '해당 상태의 PT 예약이 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontFamily: 'IBMPlexSansKR',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'PT 예약 탭에서 새로운 수업을 요청해보세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 16),
          NotionButton(
            text: '새로고침',
            onPressed: _loadAppointments,
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetail(PtAppointment appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AppointmentDetailSheet(
        appointment: appointment,
        onAction: () {
          Navigator.pop(context);
          _loadAppointments(); // 새로고침
        },
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  String _formatTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  Widget _buildContractCard(PtContract contract) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showContractDetail(contract),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 (트레이너명 + 상태)
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.1),
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
                          '${contract.trainerName} 트레이너',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          contract.startDate != null 
                            ? '시작일: ${contract.startDate}'
                            : '시작일 미정',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildContractStatusBadge(contract.status),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 세션 정보
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 16,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '남은 세션: ${contract.remainingSessions}/${contract.totalSessions}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                    if (contract.price != null) ...[
                      Text(
                        '₩${NumberFormat('#,###').format(contract.price)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // 진행률 바
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: contract.totalSessions > 0 
                  ? (contract.totalSessions - contract.remainingSessions) / contract.totalSessions
                  : 0.0,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContractStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'active':
      case 'ongoing':
        backgroundColor = const Color(0xFF10B981);
        textColor = Colors.white;
        displayText = '진행중';
        break;
      case 'pending':
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        displayText = '대기중';
        break;
      case 'completed':
        backgroundColor = Colors.blue;
        textColor = Colors.white;
        displayText = '완료';
        break;
      case 'cancelled':
      case 'expired':
        backgroundColor = Colors.red;
        textColor = Colors.white;
        displayText = '만료/취소';
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        displayText = status;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          fontFamily: 'IBMPlexSansKR',
        ),
      ),
    );
  }

  void _showContractDetail(PtContract contract) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContractDetailSheet(
        contract: contract,
        onAction: () {
          Navigator.pop(context);
          _loadContracts();
        },
      ),
    );
  }
}

class ContractDetailSheet extends ConsumerStatefulWidget {
  final PtContract contract;
  final VoidCallback onAction;

  const ContractDetailSheet({
    super.key,
    required this.contract,
    required this.onAction,
  });

  @override
  ConsumerState<ContractDetailSheet> createState() => _ContractDetailSheetState();
}

class _ContractDetailSheetState extends ConsumerState<ContractDetailSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 핸들
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 헤더
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'PT 계약 상세',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // 내용
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContractDetailSection(),
                  const SizedBox(height: 24),
                  _buildContractActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractDetailSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContractDetailRow('트레이너', widget.contract.trainerName),
          _buildContractDetailRow('총 세션', '${widget.contract.totalSessions}회'),
          _buildContractDetailRow('남은 세션', '${widget.contract.remainingSessions}회'),
          _buildContractDetailRow('상태', _getContractStatusText(widget.contract.status)),
          if (widget.contract.startDate != null)
            _buildContractDetailRow('시작일', widget.contract.startDate!),
          if (widget.contract.price != null)
            _buildContractDetailRow('계약 금액', '₩${NumberFormat('#,###').format(widget.contract.price)}'),
        ],
      ),
    );
  }

  Widget _buildContractDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractActionButtons() {
    final List<Widget> buttons = [];

    // 계약 상태에 따른 버튼들
    if (widget.contract.status.toLowerCase() == 'active' || 
        widget.contract.status.toLowerCase() == 'ongoing') {
      buttons.add(
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoading ? null : () => _createAppointment(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'PT 예약하기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
        ),
      );
    }

    return Column(children: buttons);
  }

  Future<void> _createAppointment() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'PT 예약 기능은 곧 추가될 예정입니다.\n현재 API 개발이 진행 중입니다.', 
          style: TextStyle(fontFamily: 'IBMPlexSansKR')
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3),
      ),
    );
  }

  String _getContractStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'ongoing':
        return '진행중';
      case 'pending':
        return '대기중';
      case 'completed':
        return '완료';
      case 'cancelled':
      case 'expired':
        return '만료/취소';
      default:
        return status;
    }
  }
}

// 예약 상세 정보 시트
class _AppointmentDetailSheet extends ConsumerStatefulWidget {
  final PtAppointment appointment;
  final VoidCallback onAction;
  
  const _AppointmentDetailSheet({
    required this.appointment,
    required this.onAction,
  });

  @override
  ConsumerState<_AppointmentDetailSheet> createState() => _AppointmentDetailSheetState();
}

class _AppointmentDetailSheetState extends ConsumerState<_AppointmentDetailSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 핸들
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 헤더
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'PT 예약 상세',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // 내용
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailSection(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('트레이너', widget.appointment.trainerName),
        _buildDetailRow('회원', widget.appointment.memberName),
        _buildDetailRow('날짜', _formatDate(widget.appointment.startTime)),
        _buildDetailRow('시간', '${_formatTime(widget.appointment.startTime)} - ${_formatTime(widget.appointment.endTime)}'),
        _buildDetailRow('상태', _getStatusText(widget.appointment.status)),
        
        // 변경 요청 정보
        if (widget.appointment.changeRequestStartTime != null) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '⏱️ 일정 변경 요청',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '요청자: ${widget.appointment.changeRequestBy == 'TRAINER' ? '트레이너' : '회원'}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                Text(
                  '변경 시간: ${_formatTime(widget.appointment.changeRequestStartTime!)} - ${_formatTime(widget.appointment.changeRequestEndTime!)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                Text(
                  '상태: ${_getChangeRequestStatusText(widget.appointment.changeRequestStatus!)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final List<Widget> buttons = [];

    // 상태에 따른 버튼들
    switch (widget.appointment.status) {
      case 'MEMBER_REQUESTED':
        // 회원이 요청한 경우, 취소만 가능
        buttons.add(
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () => _cancelAppointment(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                '예약 취소',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ),
          ),
        );
        break;
        
      case 'SCHEDULED':
        // 확정된 예약 - 일정 변경 요청, 취소 가능
        buttons.addAll([
          NotionButton(
            text: '일정 변경 요청',
            onPressed: _isLoading ? null : () => _requestScheduleChange(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () => _cancelAppointment(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                '예약 취소',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ),
          ),
        ]);
        
        // 변경 요청이 있고 트레이너가 요청한 경우 승인/거절 버튼
        if (widget.appointment.changeRequestBy == 'TRAINER' && 
            widget.appointment.changeRequestStatus == 'PENDING') {
          buttons.insertAll(0, [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _approveChange(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '변경 승인',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _rejectChange(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '변경 거절',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ]);
        }
        break;
    }

    return Column(children: buttons);
  }

  // API 호출 메서드들
  Future<void> _cancelAppointment() async {
    setState(() => _isLoading = true);
    
    try {
      await ref.read(ptContractViewModelProvider.notifier).updateAppointmentStatus(
        appointmentId: widget.appointment.appointmentId,
        status: 'CANCELLED',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('예약이 취소되었습니다', style: TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        widget.onAction();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('취소 실패: ${e.toString()}', style: const TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _requestScheduleChange() async {
    // TODO: 일정 변경 요청 다이얼로그 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('일정 변경 요청 기능은 곧 추가될 예정입니다', style: TextStyle(fontFamily: 'IBMPlexSansKR')),
      ),
    );
  }

  Future<void> _approveChange() async {
    setState(() => _isLoading = true);
    
    try {
      await ref.read(ptContractViewModelProvider.notifier).memberApproveTrainerChangeRequest(
        appointmentId: widget.appointment.appointmentId,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('일정 변경이 승인되었습니다', style: TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        widget.onAction();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('승인 실패: ${e.toString()}', style: const TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _rejectChange() async {
    setState(() => _isLoading = true);
    
    try {
      await ref.read(ptContractViewModelProvider.notifier).rejectAppointmentChange(
        appointmentId: widget.appointment.appointmentId,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('일정 변경이 거절되었습니다', style: TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        widget.onAction();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('거절 실패: ${e.toString()}', style: const TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  String _formatTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'MEMBER_REQUESTED':
        return '요청됨';
      case 'SCHEDULED':
        return '예정됨';
      case 'COMPLETED':
        return '완료됨';
      case 'CANCELLED':
        return '취소됨';
      case 'CHANGE_REQUESTED':
        return '변경요청';
      case 'TRAINER_CHANGE_REQUESTED':
        return '트레이너변경요청';
      default:
        return status;
    }
  }

  String _getChangeRequestStatusText(String status) {
    switch (status) {
      case 'PENDING':
        return '대기 중';
      case 'APPROVED':
        return '승인됨';
      case 'REJECTED':
        return '거절됨';
      default:
        return status;
    }
  }
}
