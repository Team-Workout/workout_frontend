import 'package:dio/dio.dart';
import '../model/body_composition_model.dart';

class BodyCompositionRepository {
  final Dio _dio;

  BodyCompositionRepository(this._dio);

  Future<List<BodyComposition>> getBodyCompositionInfo({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _dio.get(
        '/body/info',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
      );

      // Response format: {"data": [...], "pageInfo": {...}}
      if (response.data == null) {
        return [];
      }

      // Handle Map response with 'data' key
      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> responseMap =
            response.data as Map<String, dynamic>;

        // Check if 'data' key exists and is a List
        if (responseMap['data'] != null && responseMap['data'] is List) {
          final List<dynamic> dataList = responseMap['data'] as List<dynamic>;

          // Safely map each item to BodyComposition
          final List<BodyComposition> compositions = [];
          for (final item in dataList) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                // Transform the data to match the model
                final Map<String, dynamic> transformedItem = {
                  'id': item['id'],
                  'member': {
                    'id': item['memberId']
                  }, // Transform memberId to member object
                  'measurementDate': item['measurementDate'],
                  'weightKg': item['weightKg']?.toDouble() ?? 0.0,
                  'fatKg': item['fatKg']?.toDouble() ?? 0.0,
                  'muscleMassKg': item['muscleMassKg']?.toDouble() ?? 0.0,
                };
                compositions.add(BodyComposition.fromJson(transformedItem));
              } catch (e) {
                print('Error parsing body composition item: $e');
                print('Item data: $item');
                // Skip this item if parsing fails
                continue;
              }
            }
          }
          return compositions;
        }
      }

      // Handle direct List response (fallback for backward compatibility)
      if (response.data is List) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final List<BodyComposition> compositions = [];
        for (final item in dataList) {
          if (item != null && item is Map<String, dynamic>) {
            try {
              // Check if item needs transformation
              if (item.containsKey('memberId')) {
                // Transform the data to match the model
                final Map<String, dynamic> transformedItem = {
                  'id': item['id'],
                  'member': {'id': item['memberId']},
                  'measurementDate': item['measurementDate'],
                  'weightKg': item['weightKg']?.toDouble() ?? 0.0,
                  'fatKg': item['fatKg']?.toDouble() ?? 0.0,
                  'muscleMassKg': item['muscleMassKg']?.toDouble() ?? 0.0,
                };
                compositions.add(BodyComposition.fromJson(transformedItem));
              } else {
                // Use as is if already in correct format
                compositions.add(BodyComposition.fromJson(item));
              }
            } catch (e) {
              print('Error parsing body composition item: $e');
              print('Item data: $item');
              continue;
            }
          }
        }
        return compositions;
      }

      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        print('Server error: Backend serialization issue');
        print('Error details: ${e.response?.data}');
        // Return empty list for now until backend is fixed
        return [];
      }
      throw Exception('Failed to fetch body composition data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch body composition data: $e');
    }
  }

  Future<BodyComposition> addBodyComposition({
    required double weightKg,
    required double fatKg,
    required double muscleMassKg,
    required String measurementDate,
  }) async {
    try {
      final response = await _dio.post(
        '/body/info',
        data: {
          'weightKg': weightKg,
          'fatKg': fatKg,
          'muscleMassKg': muscleMassKg,
          'measurementDate': measurementDate,
        },
      );

      if (response.data != null) {
        // Check if response is just an int (possibly the ID of created record)
        if (response.data is int) {
          // If API returns just an ID, we need to fetch the created record
          // or create a temporary object
          final Map<String, dynamic> transformedData = {
            'id': response.data,
            'member': {'id': 0}, // Default member ID
            'measurementDate': measurementDate,
            'weightKg': weightKg,
            'fatKg': fatKg,
            'muscleMassKg': muscleMassKg,
          };
          return BodyComposition.fromJson(transformedData);
        }
        // Check if response is a Map
        else if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final Map<String, dynamic> transformedData = {
            'id': responseData['id'] ?? response.data,
            'member': {'id': responseData['memberId'] ?? 0},
            'measurementDate':
                responseData['measurementDate'] ?? measurementDate,
            'weightKg': (responseData['weightKg'] ?? weightKg).toDouble(),
            'fatKg': (responseData['fatKg'] ?? fatKg).toDouble(),
            'muscleMassKg':
                (responseData['muscleMassKg'] ?? muscleMassKg).toDouble(),
          };
          return BodyComposition.fromJson(transformedData);
        }
        // Handle unexpected response type
        else {
          print('Unexpected response type: ${response.data.runtimeType}');
          // Return with the data we sent
          final Map<String, dynamic> transformedData = {
            'id': 0, // Default ID
            'member': {'id': 0},
            'measurementDate': measurementDate,
            'weightKg': weightKg,
            'fatKg': fatKg,
            'muscleMassKg': muscleMassKg,
          };
          return BodyComposition.fromJson(transformedData);
        }
      }
      throw Exception('Failed to add body composition: response.data is null');
    } catch (e) {
      throw Exception('Failed to add body composition: $e');
    }
  }

  Future<void> deleteBodyComposition(int id) async {
    try {
      await _dio.delete('/body/info/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please log in');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Body composition not found or access denied');
      }
      throw Exception('Failed to delete body composition: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete body composition: $e');
    }
  }
}
