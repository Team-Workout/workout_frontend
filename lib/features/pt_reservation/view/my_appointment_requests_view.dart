import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../pt_schedule/viewmodel/pt_schedule_viewmodel.dart';
import '../../pt_schedule/model/pt_schedule_models.dart';
import '../../pt_schedule/repository/pt_schedule_repository.dart';
import '../../../core/providers/auth_provider.dart';
import '../../auth/model/user_model.dart';

class MyAppointmentRequestsView extends ConsumerStatefulWidget {
  const MyAppointmentRequestsView({super.key});

  @override
  ConsumerState<MyAppointmentRequestsView> createState() => _MyAppointmentRequestsViewState();
}

class _MyAppointmentRequestsViewState extends ConsumerState<MyAppointmentRequestsView> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // 각 탭별 데이터를 저장할 상태 변수들
  AsyncValue<List<PtSchedule>> memberRequestedData = const AsyncValue.loading();
  AsyncValue<List<PtSchedule>> scheduledData = const AsyncValue.loading();
  AsyncValue<List<PtSchedule>> changeRequestedData = const AsyncValue.loading();
  AsyncValue<List<PtSchedule>> trainerChangeRequestedData = const AsyncValue.loading();
  AsyncValue<List<PtSchedule>> completedData = const AsyncValue.loading();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAppointments();
  }
  
  void _loadAppointments() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    
    print('🔍 [DEBUG] 데이터 로드 시작 - 사용자 타입: ${user.userType}');
    
    try {
      final repository = ref.read(ptScheduleRepositoryProvider);
      final now = DateTime.now();
      
      // 각 상태별로 데이터 로드
      if (user.userType == UserType.member) {
        print('🔍 [DEBUG] 회원으로 데이터 로드');
        
        final memberRequested = await repository.getMonthlySchedule(
          month: now,
          status: 'MEMBER_REQUESTED',
        );
        print('🔍 [DEBUG] MEMBER_REQUESTED: ${memberRequested.length}개');
        
        final trainerChangeRequested = await repository.getMonthlySchedule(
          month: now,
          status: 'TRAINER_CHANGE_REQUESTED',
        );
        print('🔍 [DEBUG] TRAINER_CHANGE_REQUESTED: ${trainerChangeRequested.length}개');
        
        setState(() {
          memberRequestedData = AsyncValue.data(memberRequested);
          trainerChangeRequestedData = AsyncValue.data(trainerChangeRequested);
          changeRequestedData = const AsyncValue.data([]); // 회원은 CHANGE_REQUESTED 상태가 없음
        });
      } else if (user.userType == UserType.trainer) {
        print('🔍 [DEBUG] 트레이너로 데이터 로드');
        
        final memberRequested = await repository.getMonthlySchedule(
          month: now,
          status: 'MEMBER_REQUESTED',
        );
        print('🔍 [DEBUG] MEMBER_REQUESTED: ${memberRequested.length}개');
        
        final changeRequested = await repository.getMonthlySchedule(
          month: now,
          status: 'CHANGE_REQUESTED',
        );
        print('🔍 [DEBUG] CHANGE_REQUESTED: ${changeRequested.length}개');
        
        setState(() {
          memberRequestedData = AsyncValue.data(memberRequested);
          changeRequestedData = AsyncValue.data(changeRequested);
          trainerChangeRequestedData = const AsyncValue.data([]); // 트레이너는 TRAINER_CHANGE_REQUESTED 볼 필요 없음
        });
      }
      
      // 공통: 확정된 것과 완료된 것
      final scheduled = await repository.getMonthlySchedule(
        month: now,
        status: 'SCHEDULED',
      );
      print('🔍 [DEBUG] SCHEDULED: ${scheduled.length}개');
      
      final completed = await repository.getMonthlySchedule(
        month: now,
        status: 'COMPLETED',
      );
      print('🔍 [DEBUG] COMPLETED: ${completed.length}개');
      
      setState(() {
        scheduledData = AsyncValue.data(scheduled);
        completedData = AsyncValue.data(completed);
      });
      
      print('🔍 [DEBUG] 데이터 로드 완료');
    } catch (error, stackTrace) {
      setState(() {
        memberRequestedData = AsyncValue.error(error, stackTrace);
        scheduledData = AsyncValue.error(error, stackTrace);
        changeRequestedData = AsyncValue.error(error, stackTrace);
        trainerChangeRequestedData = AsyncValue.error(error, stackTrace);
        completedData = AsyncValue.error(error, stackTrace);
      });
      print('❌ 데이터 로드 오류: $error');
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          user?.userType == UserType.member ? '나의 PT 신청 내역' : 'PT 요청 관리',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAppointments,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(text: user?.userType == UserType.member ? '승인 대기' : '승인 요청'),
            const Tab(text: '예약 확정'),
            const Tab(text: '변경 요청'),
            const Tab(text: '완료'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 신청중/승인대기 탭
          _buildAppointmentList(
            memberRequestedData,
            'MEMBER_REQUESTED',
            user?.userType == UserType.member,
          ),
          // 예약확정 탭
          _buildAppointmentList(
            scheduledData,
            'SCHEDULED',
            user?.userType == UserType.member,
          ),
          // 변경요청 탭
          _buildChangeRequestList(user?.userType == UserType.member),
          // 완료 탭
          _buildAppointmentList(
            completedData,
            'COMPLETED',
            user?.userType == UserType.member,
          ),
        ],
      ),
    );
  }
  
  Widget _buildChangeRequestList(bool? isMember) {
    return changeRequestedData.when(
      data: (memberChanges) {
        return trainerChangeRequestedData.when(
          data: (trainerChanges) {
            final allChanges = [...memberChanges, ...trainerChanges];
            
            print('🔍 [DEBUG] 변경요청 탭 - memberChanges: ${memberChanges.length}, trainerChanges: ${trainerChanges.length}, 총 ${allChanges.length}개');
            
            if (allChanges.isEmpty) {
              return _buildEmptyState('변경 요청이 없습니다');
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allChanges.length,
              itemBuilder: (context, index) {
                final appointment = allChanges[index];
                print('🔍 [DEBUG] 변경요청 항목 ${index + 1}: ${appointment.memberName} - ${appointment.status}');
                return _buildAppointmentCard(appointment, isMember ?? false);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
          )),
          error: (error, stack) => _buildErrorState(error.toString()),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
      )),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }
  
  Widget _buildAppointmentList(
    AsyncValue<List<PtSchedule>> appointmentsAsync,
    String statusType,
    bool? isMember,
  ) {
    return appointmentsAsync.when(
      data: (appointments) {
        if (appointments.isEmpty) {
          return _buildEmptyState(_getEmptyMessage(statusType));
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return _buildAppointmentCard(appointment, isMember ?? false);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
      )),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }
  
  Widget _buildAppointmentCard(PtSchedule appointment, bool isMember) {
    final startTime = DateTime.parse(appointment.startTime);
    final endTime = DateTime.parse(appointment.endTime);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showAppointmentDetails(appointment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isMember ? appointment.trainerName : appointment.memberName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${appointment.appointmentId}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(appointment.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('yyyy년 MM월 dd일').format(startTime),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              if (appointment.hasChangeRequest == true) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.schedule, size: 14, color: Colors.orange[700]),
                      const SizedBox(width: 4),
                      Text(
                        appointment.changeRequestBy == 'member' 
                          ? '회원 변경 요청'
                          : '트레이너 변경 요청',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
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
  
  Widget _buildStatusChip(String status) {
    Color color;
    String text;
    final user = ref.read(currentUserProvider);
    
    switch (status) {
      case 'MEMBER_REQUESTED':
        color = Colors.orange;
        text = user?.userType == UserType.member ? '승인 대기' : '회원 승인 대기';
        break;
      case 'SCHEDULED':
        color = Colors.green;
        text = '예약확정';
        break;
      case 'COMPLETED':
        color = Colors.blue;
        text = '완료';
        break;
      case 'CANCELLED':
        color = Colors.red;
        text = '취소';
        break;
      case 'CHANGE_REQUESTED':
        color = Colors.purple;
        text = '회원 변경 요청';
        break;
      case 'TRAINER_CHANGE_REQUESTED':
        color = Colors.indigo;
        text = '트레이너 변경 요청';
        break;
      default:
        color = Colors.grey;
        text = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            '오류가 발생했습니다',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  String _getEmptyMessage(String statusType) {
    switch (statusType) {
      case 'MEMBER_REQUESTED':
        return '신청중인 PT가 없습니다';
      case 'SCHEDULED':
        return '예약 확정된 PT가 없습니다';
      case 'COMPLETED':
        return '완료된 PT가 없습니다';
      default:
        return '내역이 없습니다';
    }
  }
  
  void _showAppointmentDetails(PtSchedule appointment) {
    final startTime = DateTime.parse(appointment.startTime);
    final endTime = DateTime.parse(appointment.endTime);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PT 상세 정보'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('트레이너', appointment.trainerName),
            _buildDetailRow('회원', appointment.memberName),
            _buildDetailRow('약속 ID', appointment.appointmentId.toString()),
            _buildDetailRow('계약 ID', appointment.contractId.toString()),
            _buildDetailRow('날짜', DateFormat('yyyy년 MM월 dd일').format(startTime)),
            _buildDetailRow('시간', '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}'),
            _buildDetailRow('상태', _getStatusText(appointment.status)),
            if (appointment.requestedStartTime != null && appointment.requestedEndTime != null) ...[
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                '변경 요청 시간',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(appointment.requestedStartTime!))} - ${DateFormat('HH:mm').format(DateTime.parse(appointment.requestedEndTime!))}',
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  String _getStatusText(String status) {
    switch (status) {
      case 'MEMBER_REQUESTED':
        return '회원 요청';
      case 'SCHEDULED':
        return '예약 확정';
      case 'COMPLETED':
        return '완료';
      case 'CANCELLED':
        return '취소';
      case 'CHANGE_REQUESTED':
        return '변경 요청(회원)';
      case 'TRAINER_CHANGE_REQUESTED':
        return '변경 요청(트레이너)';
      default:
        return status;
    }
  }
}

