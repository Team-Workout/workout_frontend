import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../model/trainer_model.dart';

final trainerRepositoryProvider = Provider<TrainerRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TrainerRepository(dio);
});

class TrainerRepository {
  final Dio _dio;

  TrainerRepository(this._dio);

  Future<List<TrainerProfile>> getTrainersByGymId(int gymId) async {
    try {
      final response = await _dio.get('/gyms/$gymId/trainers');

      print('Trainer API Response: ${response.data}');
      print('Response type: ${response.data.runtimeType}');

      if (response.data == null) {
        return [];
      }

      // Handle Map response with 'data' key (similar to body composition)
      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> responseMap = response.data as Map<String, dynamic>;
        
        // Check if 'data' key exists and is a List
        if (responseMap['data'] != null && responseMap['data'] is List) {
          final List<dynamic> dataList = responseMap['data'] as List<dynamic>;
          
          final List<TrainerProfile> trainers = [];
          for (final item in dataList) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                trainers.add(TrainerProfile.fromJson(item));
              } catch (e) {
                print('Error parsing trainer item: $e');
                print('Item data: $item');
                continue;
              }
            }
          }
          return trainers;
        }
      }
      
      // Handle direct List response (fallback)
      if (response.data is List) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) {
              if (json is Map<String, dynamic>) {
                try {
                  return TrainerProfile.fromJson(json);
                } catch (e) {
                  print('Error parsing trainer: $e');
                  return null;
                }
              }
              return null;
            })
            .where((trainer) => trainer != null)
            .cast<TrainerProfile>()
            .toList();
      }

      return [];
    } catch (e) {
      print('Trainer repository error: $e');
      throw Exception('Failed to load trainers: $e');
    }
  }

  Future<TrainerProfile> getTrainerProfileById(int trainerId) async {
    try {
      final response = await _dio.get('/trainers/$trainerId/profile');

      if (response.data == null) {
        throw Exception('No trainer data received');
      }

      final dynamic responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw Exception('Invalid trainer data format');
      }

      return TrainerProfile.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to load trainer profile: $e');
    }
  }

  Future<List<Trainer>> getTrainers() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      const Trainer(
        id: '1',
        name: 'Sarah Johnson',
        specialization: 'Weight Loss Specialist',
        rating: 4.9,
        reviewCount: 126,
        profileImageUrl: '',
        pricePerSession: 65,
        description:
            'Certified personal trainer with 8+ years of experience specializing in weight loss and body transformation.',
        tags: ['Weight Loss', 'Nutrition', 'HIIT'],
        yearsOfExperience: 8,
        isFeatured: true,
        certifications: ['NASM-CPT', 'Nutrition Specialist'],
      ),
      const Trainer(
        id: '2',
        name: 'Michael Chen',
        specialization: 'Strength & Conditioning',
        rating: 4.8,
        reviewCount: 98,
        profileImageUrl: '',
        pricePerSession: 55,
        description:
            'Former athlete specializing in strength training and muscle building.',
        tags: ['Bodybuilding', 'Strength'],
        yearsOfExperience: 6,
        isFeatured: false,
        certifications: ['ACE-CPT', 'CSCS'],
      ),
      const Trainer(
        id: '3',
        name: 'Jessica Williams',
        specialization: 'Yoga & Flexibility',
        rating: 4.7,
        reviewCount: 87,
        profileImageUrl: '',
        pricePerSession: 50,
        description:
            'Certified yoga instructor focusing on flexibility and mindfulness.',
        tags: ['Yoga', 'Pilates'],
        yearsOfExperience: 5,
        isFeatured: false,
        certifications: ['RYT-500', 'Pilates Instructor'],
      ),
      const Trainer(
        id: '4',
        name: 'David Rodriguez',
        specialization: 'Sports Rehabilitation',
        rating: 4.9,
        reviewCount: 112,
        profileImageUrl: '',
        pricePerSession: 70,
        description:
            'Physical therapist specializing in sports injury recovery and prevention.',
        tags: ['Rehab', 'Mobility'],
        yearsOfExperience: 10,
        isFeatured: false,
        certifications: ['DPT', 'CSCS', 'Sports Therapist'],
      ),
      const Trainer(
        id: '5',
        name: 'Emma Thompson',
        specialization: 'Nutrition & Weight Loss',
        rating: 4.6,
        reviewCount: 75,
        profileImageUrl: '',
        pricePerSession: 60,
        description:
            'Combines fitness training with nutritional guidance for optimal results.',
        tags: ['Nutrition', 'HIIT'],
        yearsOfExperience: 4,
        isFeatured: false,
        certifications: ['NASM-CPT', 'Certified Nutritionist'],
      ),
    ];
  }

  Future<void> bookTrainer(String trainerId) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<Trainer?> getTrainerById(String id) async {
    final trainers = await getTrainers();
    try {
      return trainers.firstWhere((trainer) => trainer.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Trainer>> getFeaturedTrainers() async {
    final trainers = await getTrainers();
    return trainers.where((trainer) => trainer.isFeatured).toList();
  }

  Future<List<Trainer>> searchTrainers(String query) async {
    final trainers = await getTrainers();
    if (query.isEmpty) return trainers;

    return trainers.where((trainer) {
      return trainer.name.toLowerCase().contains(query.toLowerCase()) ||
          trainer.specialization.toLowerCase().contains(query.toLowerCase()) ||
          trainer.tags
              .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }
}
