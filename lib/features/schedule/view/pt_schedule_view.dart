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
import '../widget/everytime_timetable_widget.dart';
import '../../pt_schedule/widget/schedule_change_request_dialog.dart';
import '../widgets/session_create_dialog.dart';
import '../../pt_contract/repository/pt_contract_repository.dart';

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
  bool _isListView = false; // 기본값을 false로 설정 (시간표가 기본)

  final List<Map<String, String>> _statusOptions = [
    {'value': 'MEMBER_REQUESTED', 'label': '요청'},
    {'value': 'SCHEDULED', 'label': '예정'},
    {'value': 'CANCELLED', 'label': '취소'},
    {'value': 'CHANGE_REQUESTED', 'label': '변경요청'}, // 트레이너변경요청도 함께 포함
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContracts();
      if (_isListView) {
        if (!_isListView) {
          _loadTimetableAppointments();
        } else {
          _loadAppointments();
        }
      } else {
        _loadTimetableAppointments();
      }
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
      // 변경요청 탭일 때는 TRAINER_CHANGE_REQUESTED도 함께 로드
      if (_selectedStatus == 'CHANGE_REQUESTED') {
        final futures = [
          ref
              .read(ptContractViewModelProvider.notifier)
              .getMyScheduledAppointments(status: 'CHANGE_REQUESTED'),
          ref
              .read(ptContractViewModelProvider.notifier)
              .getMyScheduledAppointments(status: 'TRAINER_CHANGE_REQUESTED'),
        ];

        final responses = await Future.wait(futures);

        final allAppointments = <PtAppointment>[];
        for (final response in responses) {
          if (response != null) {
            allAppointments.addAll(response.data);
          }
        }

        // 중복 제거
        final uniqueAppointments = <int, PtAppointment>{};
        for (final appointment in allAppointments) {
          uniqueAppointments[appointment.appointmentId] = appointment;
        }

        setState(() {
          _appointmentsResponse = PtAppointmentsResponse(
            data: uniqueAppointments.values.toList(),
            totalElements: uniqueAppointments.length,
            totalPages: 1,
            currentPage: 0,
            hasNext: false,
            hasPrevious: false,
          );
          _isLoading = false;
        });
      } else {
        final response = await ref
            .read(ptContractViewModelProvider.notifier)
            .getMyScheduledAppointments(
              status: _selectedStatus,
            );

        setState(() {
          _appointmentsResponse = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('PT 예약 목록 로드 실패: $e');
    }
  }

  Future<void> _loadTimetableAppointments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 시간표에는 예정됨과 변경요청만 로드
      final timetableStatuses = [
        'SCHEDULED',
        'CHANGE_REQUESTED',
        'TRAINER_CHANGE_REQUESTED'
      ];
      final futures = timetableStatuses.map((status) {
        return ref
            .read(ptContractViewModelProvider.notifier)
            .getMyScheduledAppointments(status: status);
      }).toList();

      final responses = await Future.wait(futures);

      // 모든 응답을 하나로 합치기
      final allAppointments = <PtAppointment>[];
      for (final response in responses) {
        if (response != null) {
          allAppointments.addAll(response.data);
        }
      }

      // 중복 제거 (appointmentId 기준)
      final uniqueAppointments = <int, PtAppointment>{};
      for (final appointment in allAppointments) {
        uniqueAppointments[appointment.appointmentId] = appointment;
      }

      setState(() {
        _appointmentsResponse = PtAppointmentsResponse(
          data: uniqueAppointments.values.toList(),
          totalElements: uniqueAppointments.length,
          totalPages: 1,
          currentPage: 0,
          hasNext: false,
          hasPrevious: false,
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('모든 PT 예약 목록 로드 실패: $e');
      // 실패 시 현재 상태로 다시 로드 시도
      _loadAppointments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    // 직접 접근시에만 AppBar 추가 (트레이너는 네비게이션바 유지를 위해 AppBar 제거)
    if (widget.isDirectAccess && user?.userType != UserType.trainer) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF10B981),
                    Color(0xFF34D399),
                    Color(0xFF6EE7B7)
                  ],
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
        ),
      );
    }

    // 탭 뷰에서 사용시 Container로 반환
    return SafeArea(
      child: Container(
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
      ),
    );
  }

  Widget _buildScheduleContent() {
    return Column(
      children: [
        // 상태 필터 탭 (리스트 뷰일 때만 표시)
        if (_isListView) _buildStatusFilter(),

        // 예약 목록 또는 시간표
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF10B981),
                    strokeWidth: 3,
                  ),
                )
              : _isListView
                  ? _buildAppointmentsList()
                  : _buildTimetableView(),
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
            // 뷰 토글 버튼 (리스트 뷰일 때만 상단에 표시)
            if (_isListView)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildSwitchButton(),
              ),
            // 구분선
            if (!_isListView)
              Container(
                width: 1,
                height: 24,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
            // 상태 필터들 (리스트 뷰일 때만 표시)
            if (_isListView)
              ..._statusOptions.map((option) {
                final isSelected = _selectedStatus == option['value'];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedStatus = option['value']!;
                      });
                      if (!_isListView) {
                        _loadTimetableAppointments();
                      } else {
                        _loadAppointments();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
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
                    backgroundColor:
                        const Color(0xFF10B981).withValues(alpha: 0.1),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        color: Colors.black,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: Colors.orange.withValues(alpha: 0.3)),
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

  void _showScheduleDetailPopup(PtSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => _ScheduleDetailPopupDialog(
        schedule: schedule,
        onScheduleAction: (schedule, action) {
          Navigator.pop(context);
          _handleScheduleAction(schedule, action);
        },
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
        }).toList() ??
        [];

    showDialog(
      context: context,
      builder: (context) => _TimetablePopupDialog(
        schedules: schedules,
        onScheduleTap: (schedule) {
          Navigator.pop(context);
          // 모든 경로에서 동일한 다이얼로그 사용
          _showScheduleDetailPopup(schedule);
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
      case 'approve':
        // 트레이너가 예약 요청 승인
        await ref
            .read(ptContractRepositoryProvider)
            .confirmAppointment(appointmentId: appointment.appointmentId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('예약을 승인했습니다.',
                  style: TextStyle(fontFamily: 'IBMPlexSansKR')),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        }
        if (!_isListView) {
          _loadTimetableAppointments();
        } else {
          _loadAppointments();
        }
        break;
      case 'reject':
        // 트레이너가 예약 요청 거절
        await ref
            .read(ptContractRepositoryProvider)
            .updateAppointmentStatus(
              appointmentId: appointment.appointmentId,
              status: 'REJECTED',
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('예약을 거절했습니다.',
                  style: TextStyle(fontFamily: 'IBMPlexSansKR')),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (!_isListView) {
          _loadTimetableAppointments();
        } else {
          _loadAppointments();
        }
        break;
      case 'approve_change':
        // 트레이너가 멤버 변경요청 승인 처리
        await ref.read(ptContractRepositoryProvider).approveAppointmentChange(
              appointmentId: appointment.appointmentId,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('변경 요청을 승인했습니다.',
                  style: TextStyle(fontFamily: 'IBMPlexSansKR')),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        }
        if (!_isListView) {
          _loadTimetableAppointments();
        } else {
          _loadAppointments();
        }
        break;
      case 'reject_change':
        // 변경 거절 처리
        await ref.read(ptContractRepositoryProvider).rejectAppointmentChange(
              appointmentId: appointment.appointmentId,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('변경 요청을 거절했습니다.',
                  style: TextStyle(fontFamily: 'IBMPlexSansKR')),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (!_isListView) {
          _loadTimetableAppointments();
        } else {
          _loadAppointments();
        }
        break;
      case 'complete':
        // 세션 작성 다이얼로그 표시
        _showSessionCreateDialog(appointment);
        break;
      case 'cancel':
        // 취소 처리
        await ref
            .read(ptContractViewModelProvider.notifier)
            .updateAppointmentStatus(
              appointmentId: appointment.appointmentId,
              status: 'CANCELLED',
            );
        if (!_isListView) {
          _loadTimetableAppointments();
        } else {
          _loadAppointments();
        }
        break;
      case 'trainer_request_change':
        // 시간 변경 요청 다이얼로그 표시 (통일된 다이얼로그 사용)
        showDialog(
          context: context,
          builder: (context) => ScheduleChangeRequestDialog(
            schedule: schedule,
            isTrainerRequest: true, // 트레이너가 요청하는 경우
          ),
        ).then((_) {
          // 다이얼로그 종료 후 새로고침
          _loadTimetableAppointments();
        });
        break;
      case 'member_approve_change':
        // 멤버가 트레이너 변경요청 승인
        await ref
            .read(ptContractRepositoryProvider)
            .memberApproveTrainerChangeRequest(
              appointmentId: appointment.appointmentId,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('변경 요청을 승인했습니다.',
                  style: TextStyle(fontFamily: 'IBMPlexSansKR')),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        }
        if (!_isListView) {
          _loadTimetableAppointments();
        } else {
          _loadAppointments();
        }
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
    // PtAppointment를 PtSchedule로 변환해서 시간표 다이얼로그 사용
    final schedule = PtSchedule(
      appointmentId: appointment.appointmentId,
      contractId: appointment.contractId,
      trainerName: appointment.trainerName,
      memberName: appointment.memberName,
      startTime: appointment.startTime,
      endTime: appointment.endTime,
      status: appointment.status ?? 'SCHEDULED',
      hasChangeRequest: appointment.changeRequestStartTime != null,
      changeRequestBy: appointment.changeRequestBy,
      requestedStartTime: appointment.changeRequestStartTime,
      requestedEndTime: appointment.changeRequestEndTime,
    );

    // 시간표 뷰와 동일한 다이얼로그 사용
    _showScheduleDetailPopup(schedule);
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
                    backgroundColor:
                        const Color(0xFF10B981).withValues(alpha: 0.1),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    ? (contract.totalSessions - contract.remainingSessions) /
                        contract.totalSessions
                    : 0.0,
                backgroundColor: Colors.grey[300],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
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

  Widget _buildTimetableView() {
    // 빈 시간표라도 항상 표시
    final schedules = (_appointmentsResponse?.data ?? []).map((appointment) {
      return PtSchedule(
        appointmentId: appointment.appointmentId,
        contractId: appointment.contractId,
        trainerName: appointment.trainerName,
        memberName: appointment.memberName,
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        status: appointment.status ?? 'SCHEDULED',
        hasChangeRequest: appointment.changeRequestStartTime != null,
        changeRequestBy: appointment.changeRequestBy,
        requestedStartTime: appointment.changeRequestStartTime,
        requestedEndTime: appointment.changeRequestEndTime,
      );
    }).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 20, 12, 12), // 상단 패딩 추가
      child: EverytimeTimetableWidget(
        schedules: schedules,
        selectedWeek: DateTime.now(),
        switchButton: _buildSwitchButton(), // 스위치 버튼을 시간표 위젯으로 전달
        onScheduleTap: (schedule) {
          // PtSchedule를 PtAppointment로 다시 변환
          final appointment = _appointmentsResponse?.data.firstWhere(
            (a) => a.appointmentId == schedule.appointmentId,
            orElse: () => throw StateError('Appointment not found'),
          );
          // 시간표뷰에서는 시간표 형태의 상세 팝업 표시
          _showScheduleDetailPopup(schedule);
        },
        onScheduleAction: (schedule, action) {
          _handleScheduleAction(schedule, action);
        },
      ),
    );
  }

  // 스위치 버튼 대상체를 별도 메서드로 추출
  Widget _buildSwitchButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isListView = !_isListView;
        });
        // 뷰 변경 시 적절한 데이터 로드
        if (!_isListView) {
          _loadTimetableAppointments();
        } else {
          // 리스트 뷰로 전환 시 현재 선택된 상태로 다시 로드
          if (!_isListView) {
            _loadTimetableAppointments();
          } else {
            _loadAppointments();
          }
        }
      },
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isListView ? Icons.calendar_view_week : Icons.view_list,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              _isListView ? '시간표' : '목록',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScheduleChangeDialog(PtAppointment appointment) {
    // PtAppointment을 PtSchedule로 변환
    final schedule = PtSchedule(
      appointmentId: appointment.appointmentId,
      contractId: appointment.contractId,
      trainerName: appointment.trainerName,
      memberName: appointment.memberName,
      startTime: appointment.startTime,
      endTime: appointment.endTime,
      status: appointment.status ?? 'SCHEDULED',
      hasChangeRequest: appointment.changeRequestStartTime != null,
      changeRequestBy: appointment.changeRequestBy,
      requestedStartTime: appointment.changeRequestStartTime,
      requestedEndTime: appointment.changeRequestEndTime,
    );

    showDialog(
      context: context,
      builder: (context) => ScheduleChangeRequestDialog(
        schedule: schedule,
        isTrainerRequest: false, // 회원이 요청하는 경우
      ),
    ).then((_) {
      // 다이얼로그 종료 후 새로고침
      if (!_isListView) {
        _loadTimetableAppointments();
      } else {
        if (!_isListView) {
          _loadTimetableAppointments();
        } else {
          _loadAppointments();
        }
      }
    });
  }

  void _showSessionCreateDialog(PtAppointment appointment) {
    showDialog(
      context: context,
      builder: (context) => SessionCreateDialog(
        appointmentId: appointment.appointmentId,
        memberName: appointment.memberName,
        appointmentDate: DateTime.parse(appointment.startTime),
        onSubmit: (sessionData) async {
          try {
            await ref
                .read(ptContractRepositoryProvider)
                .createPtSession(sessionData: sessionData);

            // 세션 생성 후 자동으로 완료 처리
            await ref
                .read(ptContractViewModelProvider.notifier)
                .updateAppointmentStatus(
                  appointmentId: appointment.appointmentId,
                  status: 'COMPLETED',
                );

            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('세션이 완료되었습니다.'),
                backgroundColor: Color(0xFF10B981),
              ),
            );

            // 새로고침
            if (!_isListView) {
              _loadTimetableAppointments();
            } else {
              if (!_isListView) {
                _loadTimetableAppointments();
              } else {
                _loadAppointments();
              }
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('세션 완료에 실패했습니다.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
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
  ConsumerState<ContractDetailSheet> createState() =>
      _ContractDetailSheetState();
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
          _buildContractDetailRow(
              '남은 세션', '${widget.contract.remainingSessions}회'),
          _buildContractDetailRow(
              '상태', _getContractStatusText(widget.contract.status)),
          if (widget.contract.startDate != null)
            _buildContractDetailRow('시작일', widget.contract.startDate!),
          if (widget.contract.price != null)
            _buildContractDetailRow('계약 금액',
                '₩${NumberFormat('#,###').format(widget.contract.price)}'),
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
          child: FilledButton(
            onPressed: _isLoading ? null : () => _createAppointment(),
            style: FilledButton.styleFrom(
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
        content: Text('PT 예약 기능은 곧 추가될 예정입니다.\n현재 API 개발이 진행 중입니다.',
            style: TextStyle(fontFamily: 'IBMPlexSansKR')),
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
  ConsumerState<_AppointmentDetailSheet> createState() =>
      _AppointmentDetailSheetState();
}

class _AppointmentDetailSheetState
    extends ConsumerState<_AppointmentDetailSheet> {
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
        _buildDetailRow('시간',
            '${_formatTime(widget.appointment.startTime)} - ${_formatTime(widget.appointment.endTime)}'),
        _buildDetailRow('상태',
            _getStatusText(widget.appointment.status ?? 'MEMBER_REQUESTED')),

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
                      onPressed:
                          _isLoading ? null : () => _confirmAppointment(),
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

        // 변경 요청이 있고 상대방이 요청한 경우 승인/거절 버튼
        final currentUser = ref.read(currentUserProvider);
        final isTrainer = currentUser?.userType == UserType.trainer;
        final shouldShowApproveReject = ((isTrainer &&
                widget.appointment.changeRequestBy == 'MEMBER') ||
            (!isTrainer && widget.appointment.changeRequestBy == 'TRAINER'));

        if (shouldShowApproveReject) {
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

      case 'CHANGE_REQUESTED':
      case 'TRAINER_CHANGE_REQUESTED':
        // 변경요청 상태 - 승인/거절 버튼만 표시
        final currentUser = ref.read(currentUserProvider);
        final isTrainer = currentUser?.userType == UserType.trainer;

        // 상태 기반으로 버튼 표시 결정
        // CHANGE_REQUESTED: 회원이 요청했으므로 트레이너가 승인/거절 가능
        // TRAINER_CHANGE_REQUESTED: 트레이너가 요청했으므로 회원이 승인/거절 가능
        final shouldShowApproveReject =
            (appointmentStatus == 'CHANGE_REQUESTED' && isTrainer) ||
                (appointmentStatus == 'TRAINER_CHANGE_REQUESTED' && !isTrainer);

        if (shouldShowApproveReject) {
          buttons.addAll([
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
          ]);
        }
        break;

      default:
        // 기본 케이스 - 변경요청이 있는 다른 상태들 처리
        if (widget.appointment.changeRequestStartTime != null) {
          final currentUser = ref.read(currentUserProvider);
          final isTrainer = currentUser?.userType == UserType.trainer;

          final shouldShowApproveReject = ((isTrainer &&
                  widget.appointment.changeRequestBy == 'MEMBER') ||
              (!isTrainer && widget.appointment.changeRequestBy == 'TRAINER'));

          if (shouldShowApproveReject) {
            buttons.addAll([
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
            ]);
          }
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
            content: Text('예약이 승인되었습니다',
                style: TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        widget.onAction();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('승인 실패: ${e.toString()}',
                style: const TextStyle(fontFamily: 'IBMPlexSansKR')),
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
      await ref
          .read(ptContractViewModelProvider.notifier)
          .updateAppointmentStatus(
            appointmentId: widget.appointment.appointmentId,
            status: 'CANCELLED',
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('예약이 거절되었습니다',
                style: TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        widget.onAction();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('거절 실패: ${e.toString()}',
                style: const TextStyle(fontFamily: 'IBMPlexSansKR')),
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
      await ref
          .read(ptContractViewModelProvider.notifier)
          .updateAppointmentStatus(
            appointmentId: widget.appointment.appointmentId,
            status: 'CANCELLED',
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('예약이 취소되었습니다',
                style: TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        widget.onAction();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('취소 실패: ${e.toString()}',
                style: const TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _requestScheduleChange() async {
    // PtAppointment을 PtSchedule로 변환
    final schedule = PtSchedule(
      appointmentId: widget.appointment.appointmentId,
      contractId: widget.appointment.contractId,
      trainerName: widget.appointment.trainerName,
      memberName: widget.appointment.memberName,
      startTime: widget.appointment.startTime,
      endTime: widget.appointment.endTime,
      status: widget.appointment.status ?? 'SCHEDULED',
      hasChangeRequest: widget.appointment.changeRequestStartTime != null,
      changeRequestBy: widget.appointment.changeRequestBy,
      requestedStartTime: widget.appointment.changeRequestStartTime,
      requestedEndTime: widget.appointment.changeRequestEndTime,
    );

    final user = ref.read(currentUserProvider);
    final isTrainerRequest = user?.userType == UserType.trainer;

    showDialog(
      context: context,
      builder: (context) => ScheduleChangeRequestDialog(
        schedule: schedule,
        isTrainerRequest: isTrainerRequest,
      ),
    ).then((_) {
      // 다이얼로그 종료 후 액션 콜백 호출
      widget.onAction();
    });
  }

  Future<void> _approveChange() async {
    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider);
      final isTrainer = user?.userType == UserType.trainer;
      final appointmentStatus = widget.appointment.status ?? 'MEMBER_REQUESTED';

      // 트레이너 변경요청을 회원이 승인하는 경우는 member-approve-change 사용
      if (appointmentStatus == 'TRAINER_CHANGE_REQUESTED' && !isTrainer) {
        await ref
            .read(ptContractRepositoryProvider)
            .memberApproveTrainerChangeRequest(
              appointmentId: widget.appointment.appointmentId,
            );
      } else {
        // 회원 변경요청을 트레이너가 승인하는 경우는 공통 change-approval 사용
        await ref.read(ptContractRepositoryProvider).approveAppointmentChange(
              appointmentId: widget.appointment.appointmentId,
            );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('일정 변경이 승인되었습니다',
                style: TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        widget.onAction();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('승인 실패: ${e.toString()}',
                style: const TextStyle(fontFamily: 'IBMPlexSansKR')),
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
      await ref.read(ptContractRepositoryProvider).rejectAppointmentChange(
            appointmentId: widget.appointment.appointmentId,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('일정 변경이 거절되었습니다',
                style: TextStyle(fontFamily: 'IBMPlexSansKR')),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        widget.onAction();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('거절 실패: ${e.toString()}',
                style: const TextStyle(fontFamily: 'IBMPlexSansKR')),
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
    final mondayOfWeek =
        _selectedWeek.subtract(Duration(days: _selectedWeek.weekday - 1));
    final isCurrentWeek = DateFormat('yyyy-MM-dd').format(mondayOfWeek) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now()
            .subtract(Duration(days: DateTime.now().weekday - 1)));

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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFF10B981)),
                              ),
                              child: const Text(
                                '이번 주로 이동',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black87,
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

// 시간표 형태의 일정 상세 팝업
class _ScheduleDetailPopupDialog extends ConsumerWidget {
  final PtSchedule schedule;
  final Function(PtSchedule, String) onScheduleAction;

  const _ScheduleDetailPopupDialog({
    required this.schedule,
    required this.onScheduleAction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                    Icons.event,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'PT 일정 상세',
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

            // 내용
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDetailSection(),
                    const SizedBox(height: 20),
                    _buildActionButtons(context, ref),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildDetailRow('트레이너', schedule.trainerName),
          _buildDetailRow('회원', schedule.memberName),
          _buildDetailRow('날짜', _formatDate(schedule.startTime)),
          _buildDetailRow('시간',
              '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}'),
          _buildDetailRow('상태', _getStatusText(schedule.status)),

          // 변경 요청 정보
          if ((schedule.hasChangeRequest ?? false) &&
              schedule.requestedStartTime != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
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
                  const SizedBox(height: 4),
                  Text(
                    '요청자: ${schedule.changeRequestBy == 'TRAINER' ? '트레이너' : '회원'}',
                    style: const TextStyle(
                        fontSize: 12, fontFamily: 'IBMPlexSansKR'),
                  ),
                  Text(
                    '변경 시간: ${_formatTime(schedule.requestedStartTime!)} - ${_formatTime(schedule.requestedEndTime!)}',
                    style: const TextStyle(
                        fontSize: 12, fontFamily: 'IBMPlexSansKR'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
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

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    final List<Widget> buttons = [];
    final currentUser = ref.read(currentUserProvider);
    final isTrainer = currentUser?.userType == UserType.trainer;

    // 상태에 따른 버튼들
    switch (schedule.status) {
      case 'MEMBER_REQUESTED':
        // 트레이너인 경우 승인/거절 버튼 표시
        if (isTrainer) {
          buttons.add(
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => onScheduleAction(schedule, 'approve'),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('예약 승인'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'IBMPlexSansKR',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onScheduleAction(schedule, 'reject'),
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('예약 거절'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'IBMPlexSansKR',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // 회원인 경우 취소 버튼만 표시
          buttons.add(
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => onScheduleAction(schedule, 'cancel'),
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: const Text('예약 취소'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'IBMPlexSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }
        break;
      case 'SCHEDULED':
        buttons.addAll([
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  onScheduleAction(schedule, 'trainer_request_change'),
              icon: const Icon(Icons.schedule, size: 18),
              label: const Text('시간 변경 요청'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'IBMPlexSansKR',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onScheduleAction(schedule, 'complete'),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('완료'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF10B981),
                    side: const BorderSide(color: Color(0xFF10B981)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'IBMPlexSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onScheduleAction(schedule, 'cancel'),
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text('취소'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'IBMPlexSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]);

        // 상대방 변경요청에 대한 승인/거절 버튼
        final currentUser = ref.read(currentUserProvider);
        final isTrainer = currentUser?.userType == UserType.trainer;
        final shouldShowChangeActions = (schedule.hasChangeRequest ?? false) &&
            ((isTrainer && schedule.changeRequestBy == 'MEMBER') ||
                (!isTrainer && schedule.changeRequestBy == 'TRAINER'));

        if (shouldShowChangeActions) {
          buttons.insertAll(0, [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => onScheduleAction(schedule,
                        isTrainer ? 'approve_change' : 'member_approve_change'),
                    icon: const Icon(Icons.thumb_up_outlined, size: 18),
                    label: const Text('변경 승인'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'IBMPlexSansKR',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        onScheduleAction(schedule, 'reject_change'),
                    icon: const Icon(Icons.thumb_down_outlined, size: 18),
                    label: const Text('변경 거절'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'IBMPlexSansKR',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ]);
        }
        break;
    }

    return Column(children: buttons);
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
}
