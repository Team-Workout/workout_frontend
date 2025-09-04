import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../model/trainer_client_model.dart';

final trainerClientRepositoryProvider =
    Provider<TrainerClientRepository>((ref) {
  return TrainerClientRepository(ref.watch(apiServiceProvider));
});

class TrainerClientRepository {
  final ApiService _apiService;

  TrainerClientRepository(this._apiService);

  // 트레이너의 PT 회원 목록 조회
  Future<TrainerClientResponse> getMyClients({
    int page = 0,
    int size = 20,
    String? sort,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'size': size,
        if (sort != null) 'sort': sort,
      };

      final response = await _apiService.get(
        '/trainer/clients/me',
        queryParameters: queryParams,
      );

      return TrainerClientResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('인증되지 않은 사용자입니다');
      }
      throw Exception('회원 목록을 불러오는데 실패했습니다: ${e.message}');
    } catch (e) {
      throw Exception('회원 목록을 불러오는데 실패했습니다: $e');
    }
  }

  // 특정 회원의 몸 사진 조회
  Future<MemberBodyImageResponse> getMemberBodyImages({
    required int memberId,
    required String startDate,
    required String endDate,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = {
        'startDate': startDate,
        'endDate': endDate,
        'page': page,
        'size': size,
      };

      final response = await _apiService.get(
        '/trainers/members/$memberId/body-images',
        queryParameters: queryParams,
      );

      return MemberBodyImageResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('인증되지 않은 사용자입니다');
      } else if (e.response?.statusCode == 403) {
        throw Exception('회원 정보에 접근할 권한이 없습니다');
      }
      throw Exception('회원 몸 사진을 불러오는데 실패했습니다: ${e.message}');
    } catch (e) {
      throw Exception('회원 몸 사진을 불러오는데 실패했습니다: $e');
    }
  }

  // 특정 회원의 체성분 데이터 조회
  Future<MemberBodyCompositionResponse> getMemberBodyCompositions({
    required int memberId,
    required String startDate,
    required String endDate,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = {
        'startDate': startDate,
        'endDate': endDate,
        'page': page,
        'size': size,
      };

      final response = await _apiService.get(
        '/trainers/members/$memberId/body-compositions',
        queryParameters: queryParams,
      );

      return MemberBodyCompositionResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('인증되지 않은 사용자입니다');
      } else if (e.response?.statusCode == 403) {
        throw Exception('회원 정보에 접근할 권한이 없습니다');
      }
      throw Exception('회원 체성분 데이터를 불러오는데 실패했습니다: ${e.message}');
    } catch (e) {
      throw Exception('회원 체성분 데이터를 불러오는데 실패했습니다: $e');
    }
  }
}
