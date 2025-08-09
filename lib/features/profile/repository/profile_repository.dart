import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/profile/model/member_profile_model.dart';

abstract class ProfileRepository {
  Future<MemberProfile> getMemberProfile(String memberId);
  Future<void> updateMemberProfile(MemberProfile profile);
  Future<void> addWeightRecord(String memberId, double weight, DateTime date);
}

class MockProfileRepository implements ProfileRepository {
  final Map<String, MemberProfile> _profiles = {
    '1': MemberProfile(
      id: '1',
      email: 'trainer@test.com',
      name: '김트레이너',
      phoneNumber: '010-1234-5678',
      birthDate: DateTime(1990, 5, 15),
      joinDate: DateTime(2023, 1, 1),
      totalSessions: 0,
      monthSessions: 0,
    ),
    '2': MemberProfile(
      id: '2',
      email: 'member@test.com',
      name: '이회원',
      phoneNumber: '010-2345-6789',
      birthDate: DateTime(1995, 8, 20),
      height: 170.0,
      currentWeight: 72.0,
      targetWeight: 70.0,
      joinDate: DateTime(2023, 6, 1),
      totalSessions: 48,
      monthSessions: 8,
      assignedTrainerId: '1',
      medicalHistory: '무릘 수술 경력',
      notes: '하체 운동 선호',
      weightHistory: [
        WeightRecord(date: DateTime(2023, 8, 1), weight: 75.0),
        WeightRecord(date: DateTime(2023, 9, 1), weight: 74.5),
        WeightRecord(date: DateTime(2023, 10, 1), weight: 73.8),
        WeightRecord(date: DateTime(2023, 11, 1), weight: 73.2),
        WeightRecord(date: DateTime(2023, 12, 1), weight: 72.5),
        WeightRecord(date: DateTime(2024, 1, 1), weight: 72.0),
      ],
    ),
    '3': MemberProfile(
      id: '3',
      email: 'manager@test.com',
      name: '박관장',
      phoneNumber: '010-3456-7890',
      birthDate: DateTime(1980, 3, 25),
      joinDate: DateTime(2020, 1, 1),
      totalSessions: 0,
      monthSessions: 0,
    ),
  };
  
  @override
  Future<MemberProfile> getMemberProfile(String memberId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final profile = _profiles[memberId];
    if (profile == null) {
      throw Exception('회원을 찾을 수 없습니다');
    }
    return profile;
  }
  
  @override
  Future<void> updateMemberProfile(MemberProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _profiles[profile.id] = profile;
  }
  
  @override
  Future<void> addWeightRecord(String memberId, double weight, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final profile = _profiles[memberId];
    if (profile != null) {
      final newRecord = WeightRecord(date: date, weight: weight);
      final updatedHistory = [...profile.weightHistory, newRecord];
      _profiles[memberId] = profile.copyWith(
        currentWeight: weight,
        weightHistory: updatedHistory,
      );
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return MockProfileRepository();
});