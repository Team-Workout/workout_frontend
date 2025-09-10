import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../pt_contract/model/pt_appointment_models.dart';
import '../../pt_contract/model/pt_contract_models.dart';
import '../../pt_contract/viewmodel/pt_contract_viewmodel.dart';
import '../../auth/model/user_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../dashboard/widgets/notion_button.dart';
import '../../pt_schedule/model/pt_schedule_models.dart';
import '../widget/weekly_timetable_widget.dart';

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
          );
      
      setState(() {
        _appointmentsResponse = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('PT 예약 목록 로드 실패: $e');
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
          children: [
            // 시간표 보기 버튼
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: _showTimetablePopup,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF34D399)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.calendar_view_week,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        '시간표',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 구분선
            Container(
              width: 1,
              height: 24,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            // 상태 필터들
            ..._statusOptions.map((option) {
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
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    // 실제 예약 데이터 표시
    if (_appointmentsResponse == null || _appointmentsResponse!.data.isEmpty) {
      return _buildEmptyState();
    }

    final appointments = _appointmentsResponse!.data;
    
    return RefreshIndicator(
      onRefresh: _loadAppointments,
      color: const Color(0xFF10B981),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return _buildAppointmentCard(appointment);
        },
      ),
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
                  _buildStatusBadge(appointment.status ?? _selectedStatus),
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

  void _showTimetablePopup() {
    // PtAppointment를 PtSchedule로 변환
    final schedules = _appointmentsResponse?.data.map((appointment) {
      return PtSchedule(
        appointmentId: appointment.appointmentId,
        contractId: appointment.contractId,
        trainerName: appointment.trainerName,
        memberName: appointment.memberName,
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        status: appointment.status ?? _selectedStatus,
        hasChangeRequest: appointment.changeRequestStartTime != null,
        changeRequestBy: appointment.changeRequestBy,
        requestedStartTime: appointment.changeRequestStartTime,
        requestedEndTime: appointment.changeRequestEndTime,
      );
    }).toList() ?? [];

    showDialog(
      context: context,
      builder: (context) => _TimetablePopupDialog(
        schedules: schedules,
        onScheduleTap: (schedule) {
          Navigator.pop(context);
          // PtSchedule를 PtAppointment로 다시 변환
          final appointment = _appointmentsResponse?.data.firstWhere(
            (a) => a.appointmentId == schedule.appointmentId,
          );
          if (appointment != null) {
            _showAppointmentDetail(appointment);
          }
        },
        onScheduleAction: (schedule, action) {
          Navigator.pop(context);
          // 액션 처리
          _handleScheduleAction(schedule, action);
        },
      ),
    );
  }

  void _handleScheduleAction(PtSchedule schedule, String action) async {
    // PtSchedule를 PtAppointment로 변환
    final appointment = _appointmentsResponse?.data.firstWhere(
      (a) => a.appointmentId == schedule.appointmentId,
    );
    
    if (appointment == null) return;

    switch (action) {
      case 'approve_change':
        // 변경 승인 처리
        await ref.read(ptContractViewModelProvider.notifier).memberApproveTrainerChangeRequest(
          appointmentId: appointment.appointmentId,
        );
        _loadAppointments();
        break;
      case 'reject_change':
        // 변경 거절 처리
        await ref.read(ptContractViewModelProvider.notifier).rejectAppointmentChange(
          appointmentId: appointment.appointmentId,
        );
        _loadAppointments();
        break;
      case 'complete':
        // 완료 처리
        await ref.read(ptContractViewModelProvider.notifier).updateAppointmentStatus(
          appointmentId: appointment.appointmentId,
          status: 'COMPLETED',
        );
        _loadAppointments();
        break;
      case 'cancel':
        // 취소 처리
        await ref.read(ptContractViewModelProvider.notifier).updateAppointmentStatus(
          appointmentId: appointment.appointmentId,
          status: 'CANCELLED',
        );
        _loadAppointments();
        break;
      case 'trainer_request_change':
        // 시간 변경 요청
        _showAppointmentDetail(appointment);
        break;
    }
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
    final user = ref.watch(currentUserProvider);
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
        _buildDetailRow('상태', _getStatusText(widget.appointment.status ?? 'MEMBER_REQUESTED')),
        
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
    final user = ref.watch(currentUserProvider);
    final List<Widget> buttons = [];

    // 상태에 따른 버튼들
    final appointmentStatus = widget.appointment.status ?? 'MEMBER_REQUESTED';
    switch (appointmentStatus) {
      case 'MEMBER_REQUESTED':
        // 트레이너인 경우: 승인/거절 버튼
        if (user?.userType == UserType.trainer) {
          buttons.add(
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _confirmAppointment(),
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
                        '예약 승인',
                        style: TextStyle(
                          fontSize: 16,
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
                      onPressed: _isLoading ? null : () => _rejectAppointment(),
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
                        '예약 거절',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } 
        // 회원인 경우: 취소만 가능
        else {
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
        }
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
  Future<void> _confirmAppointment() async {
    setState(() => _isLoading = true);
    
    try {
      await ref.read(ptContractViewModelProvider.notifier).confirmAppointment(
        appointmentId: widget.appointment.appointmentId,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('예약이 승인되었습니다', style: TextStyle(fontFamily: 'IBMPlexSansKR')),
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

  Future<void> _rejectAppointment() async {
    setState(() => _isLoading = true);
    
    try {
      await ref.read(ptContractViewModelProvider.notifier).updateAppointmentStatus(
        appointmentId: widget.appointment.appointmentId,
        status: 'CANCELLED',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('예약이 거절되었습니다', style: TextStyle(fontFamily: 'IBMPlexSansKR')),
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
    // 날짜/시간 선택 다이얼로그 표시
    DateTime? selectedDate;
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    // 현재 예약 시간을 기본값으로 설정
    try {
      final currentStart = DateTime.parse(widget.appointment.startTime);
      selectedDate = currentStart;
      startTime = TimeOfDay.fromDateTime(currentStart);
      endTime = TimeOfDay.fromDateTime(DateTime.parse(widget.appointment.endTime));
    } catch (e) {
      selectedDate = DateTime.now();
      startTime = const TimeOfDay(hour: 9, minute: 0);
      endTime = const TimeOfDay(hour: 10, minute: 0);
    }

    // 날짜 선택
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF10B981),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    // 시작 시간 선택
    final pickedStartTime = await showTimePicker(
      context: context,
      initialTime: startTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF10B981),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedStartTime == null) return;

    // 종료 시간 선택
    final pickedEndTime = await showTimePicker(
      context: context,
      initialTime: endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF10B981),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedEndTime == null) return;

    // 새로운 시간 생성
    final newStartDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedStartTime.hour,
      pickedStartTime.minute,
    );

    final newEndDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedEndTime.hour,
      pickedEndTime.minute,
    );

    // 유효성 검사
    if (newEndDateTime.isBefore(newStartDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('종료 시간은 시작 시간 이후여야 합니다', style: TextStyle(fontFamily: 'IBMPlexSansKR')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 확인 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일정 변경 요청', style: TextStyle(fontFamily: 'IBMPlexSansKR')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('다음 일정으로 변경을 요청하시겠습니까?', style: TextStyle(fontFamily: 'IBMPlexSansKR')),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '날짜: ${DateFormat('yyyy년 M월 d일').format(pickedDate)}',
                    style: const TextStyle(fontFamily: 'IBMPlexSansKR'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '시간: ${pickedStartTime.format(context)} - ${pickedEndTime.format(context)}',
                    style: const TextStyle(fontFamily: 'IBMPlexSansKR'),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소', style: TextStyle(fontFamily: 'IBMPlexSansKR')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            child: const Text('요청', style: TextStyle(fontFamily: 'IBMPlexSansKR')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // API 호출
    setState(() => _isLoading = true);
    
    try {
      final user = ref.read(currentUserProvider);
      
      // 트레이너인지 회원인지에 따라 다른 API 호출
      if (user?.userType == UserType.trainer) {
        await ref.read(ptContractViewModelProvider.notifier).trainerRequestScheduleChange(
          appointmentId: widget.appointment.appointmentId,
          newStartTime: newStartDateTime.toIso8601String(),
          newEndTime: newEndDateTime.toIso8601String(),
        );
      } else {
        await ref.read(ptContractViewModelProvider.notifier).memberRequestScheduleChange(
          appointmentId: widget.appointment.appointmentId,
          newStartTime: newStartDateTime.toIso8601String(),
          newEndTime: newEndDateTime.toIso8601String(),
        );
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('일정 변경이 요청되었습니다', style: TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        widget.onAction();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('변경 요청 실패: ${e.toString()}', style: const TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

class _TimetablePopupDialog extends StatefulWidget {
  final List<PtSchedule> schedules;
  final Function(PtSchedule) onScheduleTap;
  final Function(PtSchedule, String) onScheduleAction;

  const _TimetablePopupDialog({
    required this.schedules,
    required this.onScheduleTap,
    required this.onScheduleAction,
  });

  @override
  State<_TimetablePopupDialog> createState() => _TimetablePopupDialogState();
}

class _TimetablePopupDialogState extends State<_TimetablePopupDialog> {
  DateTime _selectedWeek = DateTime.now();

  void _goToPreviousWeek() {
    setState(() {
      _selectedWeek = _selectedWeek.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _selectedWeek = _selectedWeek.add(const Duration(days: 7));
    });
  }

  void _goToCurrentWeek() {
    setState(() {
      _selectedWeek = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mondayOfWeek = _selectedWeek.subtract(Duration(days: _selectedWeek.weekday - 1));
    final isCurrentWeek = DateFormat('yyyy-MM-dd').format(mondayOfWeek) == 
                         DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)));

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_view_week,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'PT 주간 시간표',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // 주차 네비게이션
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 이전 주 버튼
                  IconButton(
                    onPressed: _goToPreviousWeek,
                    icon: const Icon(Icons.chevron_left, size: 28),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                  
                  // 현재 주차 정보
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${DateFormat('M월 d일').format(mondayOfWeek)} - ${DateFormat('M월 d일').format(mondayOfWeek.add(const Duration(days: 6)))}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        if (!isCurrentWeek) ...[
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: _goToCurrentWeek,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF10B981)),
                              ),
                              child: const Text(
                                '이번 주로 이동',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // 다음 주 버튼
                  IconButton(
                    onPressed: _goToNextWeek,
                    icon: const Icon(Icons.chevron_right, size: 28),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 시간표 위젯
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: WeeklyTimetableWidget(
                  schedules: widget.schedules,
                  selectedWeek: _selectedWeek,
                  onScheduleTap: widget.onScheduleTap,
                  onScheduleAction: widget.onScheduleAction,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
