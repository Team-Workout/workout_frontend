import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/services/api_service.dart';
import '../model/pt_contract_models.dart';
import '../model/pt_session_models.dart';
import '../model/pt_appointment_models.dart';

class PtContractRepository {
  final ApiService _apiService;

  PtContractRepository(this._apiService);

  Future<PtContractResponse> getMyContracts({
    int page = 0,
    int size = 10,
    String sort = 'startDate,desc',
  }) async {
    final response = await _apiService.get(
      '/pt/contract/me',
      queryParameters: {
        'page': page,
        'size': size,
        'sort': sort,
      },
    );

    return PtContractResponse.fromJson(response.data);
  }

  Future<void> proposeAppointment({
    required int contractId,
    required String startTime,
    required String endTime,
  }) async {
    final requestData = {
      'contractId': contractId,
      'startTime': startTime,
      'endTime': endTime,
    };

    await _apiService.post(
      '/pt-appointments/propose',
      data: requestData,
    );
  }

  Future<void> createAppointment({
    required int contractId,
    required String startTime,
    required String endTime,
  }) async {
    final requestData = {
      'contractId': contractId,
      'startTime': startTime,
      'endTime': endTime,
    };

    await _apiService.post(
      '/pt-appointments',
      data: requestData,
    );
  }

  Future<void> confirmAppointment({
    required int appointmentId,
  }) async {
    await _apiService.patch(
      '/pt-appointments/$appointmentId/confirm',
    );
  }

  Future<void> updateAppointmentStatus({
    required int appointmentId,
    required String status,
  }) async {
    final requestData = {
      'status': status,
    };

    await _apiService.patch(
      '/pt-appointments/$appointmentId/status',
      data: requestData,
    );
  }

  Future<void> requestScheduleChange({
    required int appointmentId,
    required String newStartTime,
    required String newEndTime,
  }) async {
    final requestData = {
      'newStartTime': newStartTime,
      'newEndTime': newEndTime,
    };

    await _apiService.patch(
      '/pt-appointments/$appointmentId/change-request',
      data: requestData,
    );
  }

  Future<void> approveScheduleChange({
    required int appointmentId,
  }) async {
    await _apiService.patch(
      '/pt-appointments/$appointmentId/change-approval',
    );
  }

  Future<void> rejectScheduleChange({
    required int appointmentId,
  }) async {
    await _apiService.patch(
      '/pt-appointments/$appointmentId/change-rejection',
    );
  }

  Future<void> trainerRequestScheduleChange({
    required int appointmentId,
    required String newStartTime,
    required String newEndTime,
  }) async {
    final requestData = {
      'newStartTime': newStartTime,
      'newEndTime': newEndTime,
    };

    await _apiService.patch(
      '/pt-appointments/$appointmentId/trainer-change-request',
      data: requestData,
    );
  }

  Future<void> memberApproveScheduleChange({
    required int appointmentId,
  }) async {
    await _apiService.patch(
      '/pt-appointments/$appointmentId/member-approve-change',
    );
  }

  Future<PtSession> createPtSession({
    required PtSessionCreate sessionData,
  }) async {
    final response = await _apiService.post(
      '/pt-sessions',
      data: sessionData.toJson(),
    );

    return PtSession.fromJson(response.data);
  }

  Future<void> deletePtSession({
    required int ptSessionId,
  }) async {
    await _apiService.delete(
      '/pt-sessions/$ptSessionId',
    );
  }

  // PT 예약 관련 메서드들 추가
  
  /// 내 예약 일정 조회 (기간/상태별)
  Future<PtAppointmentsResponse> getMyScheduledAppointments({
    String? startDate,
    String? endDate,
    String? status,
    int page = 0,
    int size = 10,
  }) async {
    try {
      // 현재 날짜를 기준으로 기본값 설정 (다양한 날짜 형식 시도)
      final now = DateTime.now();
      
      // ISO 8601 형식으로 시도 (시간 포함)
      final defaultStartDate = startDate ?? DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime(now.year, now.month, 1));
      final defaultEndDate = endDate ?? DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime(now.year, now.month + 1, 0, 23, 59, 59));
      
      // 서버에서 허용하는 정확한 status 값들
      final defaultStatus = status ?? 'SCHEDULED';
      
      print('🔧 시도할 status 값: $defaultStatus');
      
      // page, size 파라미터를 제거하고 필수 파라미터만 전송
      final Map<String, dynamic> queryParams = {
        'startDate': defaultStartDate, // startDate는 필수 파라미터
        'endDate': defaultEndDate,     // endDate도 필수 파라미터
        'status': defaultStatus,       // status도 필수 파라미터
      };

      print('🔍 PT Appointments API 호출 파라미터 (page,size 제거): $queryParams');

      final response = await _apiService.get(
        '/pt-appointments/me/scheduled',
        queryParameters: queryParams,
      );

      print('✅ PT Appointments API 응답: ${response.data}');
      return PtAppointmentsResponse.fromJson(response.data);
    } catch (e) {
      print('❌ PT Appointments API 오류 (첫 번째 시도): $e');
      
      // 다른 날짜 형식들로 시도
      final List<Map<String, dynamic>> dateFormatsToTry = [
        {
          'name': 'yyyy-MM-dd',
          'format': DateFormat('yyyy-MM-dd'),
        },
        {
          'name': 'yyyy/MM/dd',
          'format': DateFormat('yyyy/MM/dd'),
        },
        {
          'name': 'dd-MM-yyyy',
          'format': DateFormat('dd-MM-yyyy'),
        },
      ];
      
      final List<String> statusesToTry = ['MEMBER_REQUESTED', 'COMPLETED', 'CANCELLED'];
      
      for (var dateFormat in dateFormatsToTry) {
        for (String tryStatus in statusesToTry) {
          try {
            print('🔄 다른 날짜형식(${dateFormat['name']}) + status($tryStatus)로 재시도');
            final now = DateTime.now();
            final tryStartDate = startDate ?? (dateFormat['format'] as DateFormat).format(DateTime(now.year, now.month, 1));
            final tryEndDate = endDate ?? (dateFormat['format'] as DateFormat).format(DateTime(now.year, now.month + 1, 0));
            
            final Map<String, dynamic> retryParams = {
              'startDate': tryStartDate,
              'endDate': tryEndDate,
              'status': tryStatus,
            };

            print('🔍 재시도 파라미터: $retryParams');

            final response = await _apiService.get(
              '/pt-appointments/me/scheduled',
              queryParameters: retryParams,
            );

            print('✅ ${dateFormat['name']} + $tryStatus로 재시도 성공: ${response.data}');
            return PtAppointmentsResponse.fromJson(response.data);
          } catch (e2) {
            print('❌ ${dateFormat['name']} + $tryStatus 재시도 실패: $e2');
            continue;
          }
        }
      }
      
      // 모든 조합 시도 후 실패하면 빈 응답 반환
      print('❌ 모든 날짜형식 + status 조합 시도 실패');
      return const PtAppointmentsResponse(
        data: [],
        totalElements: 0,
        totalPages: 0,
        currentPage: 0,
        hasNext: false,
        hasPrevious: false,
      );
    }
  }


  /// [회원] 수업 일정 변경 요청
  Future<void> memberRequestScheduleChange({
    required int appointmentId,
    required String newStartTime,
    required String newEndTime,
  }) async {
    final requestData = AppointmentChangeRequest(
      newStartTime: newStartTime,
      newEndTime: newEndTime,
    );

    await _apiService.patch(
      '/pt-appointments/$appointmentId/change-request',
      data: requestData.toJson(),
    );
  }

  /// [회원] 트레이너의 수업 변경 요청 승인
  Future<void> memberApproveTrainerChangeRequest({
    required int appointmentId,
  }) async {
    await _apiService.patch(
      '/pt-appointments/$appointmentId/member-approve-change',
    );
  }

  /// 수업 변경 거절 (공통)
  Future<void> rejectAppointmentChange({
    required int appointmentId,
  }) async {
    await _apiService.patch(
      '/pt-appointments/$appointmentId/change-rejection',
    );
  }

  /// 수업 변경 승인 (공통)
  Future<void> approveAppointmentChange({
    required int appointmentId,
  }) async {
    await _apiService.patch(
      '/pt-appointments/$appointmentId/change-approval',
    );
  }
}

final ptContractRepositoryProvider = Provider<PtContractRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PtContractRepository(apiService);
});
