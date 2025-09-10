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
  
  /// 내 예약 일정 조회 (최대 일주일 범위)
  Future<PtAppointmentsResponse> getMyScheduledAppointments({
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    // 현재 날짜 기준 일주일 범위 (최대 허용 기간 - 7일 이내)
    final now = DateTime.now();
    final weekStart = startDate ?? DateFormat('yyyy-MM-dd').format(now);
    // 6일 후로 설정 (오늘 포함 7일)
    final weekEnd = endDate ?? DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 6)));
    final appointmentStatus = status ?? 'SCHEDULED';
    
    final Map<String, dynamic> queryParams = {
      'startDate': weekStart,
      'endDate': weekEnd,
      'status': appointmentStatus,
    };

    print('🔍 PT Appointments API 호출 (일주일 범위): $queryParams');

    try {
      final response = await _apiService.get(
        '/pt-appointments/me/scheduled',
        queryParameters: queryParams,
      );

      print('✅ PT Appointments API 응답: ${response.data}');
      
      // API 응답 형식 처리 (페이지 정보가 없는 경우도 처리)
      final responseData = response.data as Map<String, dynamic>;
      final appointments = (responseData['data'] as List<dynamic>?) ?? [];
      
      return PtAppointmentsResponse(
        data: appointments.map((e) {
          final appointment = PtAppointment.fromJson(e as Map<String, dynamic>);
          // status 필드가 없으면 요청한 status로 설정
          if (appointment.status == null) {
            return appointment.copyWith(status: appointmentStatus);
          }
          return appointment;
        }).toList(),
        totalElements: responseData['totalElements'] as int? ?? appointments.length,
        totalPages: responseData['totalPages'] as int? ?? 1,
        currentPage: responseData['currentPage'] as int? ?? 0,
        hasNext: responseData['hasNext'] as bool? ?? false,
        hasPrevious: responseData['hasPrevious'] as bool? ?? false,
      );
    } catch (e) {
      print('❌ PT Appointments API 오류: $e');
      
      // 7일이 안되면 더 짧은 기간으로 재시도
      try {
        print('🔄 더 짧은 기간(3일)으로 재시도');
        final shortEnd = DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 3)));
        final retryParams = {
          'startDate': weekStart,
          'endDate': shortEnd,
          'status': appointmentStatus,
        };
        
        final retryResponse = await _apiService.get(
          '/pt-appointments/me/scheduled',
          queryParameters: retryParams,
        );
        
        print('✅ 재시도 성공: ${retryResponse.data}');
        
        // API 응답 형식 처리 (페이지 정보가 없는 경우도 처리)
        final retryData = retryResponse.data as Map<String, dynamic>;
        final retryAppointments = (retryData['data'] as List<dynamic>?) ?? [];
        
        return PtAppointmentsResponse(
          data: retryAppointments.map((e) {
            final appointment = PtAppointment.fromJson(e as Map<String, dynamic>);
            // status 필드가 없으면 요청한 status로 설정
            if (appointment.status == null) {
              return appointment.copyWith(status: appointmentStatus);
            }
            return appointment;
          }).toList(),
          totalElements: retryData['totalElements'] as int? ?? retryAppointments.length,
          totalPages: retryData['totalPages'] as int? ?? 1,
          currentPage: retryData['currentPage'] as int? ?? 0,
          hasNext: retryData['hasNext'] as bool? ?? false,
          hasPrevious: retryData['hasPrevious'] as bool? ?? false,
        );
      } catch (e2) {
        print('❌ 재시도도 실패: $e2');
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
