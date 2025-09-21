import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../model/body_composition_model.dart';
import '../model/body_image_model.dart';

class BodyCompositionRepository {
  final Dio _dio;

  BodyCompositionRepository(this._dio);

  Future<List<BodyComposition>> getBodyCompositionInfo({
    required String startDate,
    required String endDate,
    int page = 0,
    int size = 20,
    List<String> sort = const ['measurementDate,desc'],
  }) async {
    try {
      print('=== Body Composition API Call ===');
      print('URL: /body/info');
      print('Parameters: startDate=$startDate, endDate=$endDate, page=$page, size=$size, sort=$sort');

      final response = await _dio.get(
        '/body/info',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
          'page': page,
          'size': size,
          'sort': sort,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response data type: ${response.data.runtimeType}');
      print('Response data: ${response.data}');

      // Response format: {"data": [...], "pageInfo": {...}}
      if (response.data == null) {
        return [];
      }

      // Handle Map response with 'data' key (paginated response)
      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> responseMap =
            response.data as Map<String, dynamic>;

        // Check if 'data' key exists and is a List
        if (responseMap['data'] != null && responseMap['data'] is List) {
          final List<dynamic> dataList = responseMap['data'] as List<dynamic>;

          // Log pagination info for debugging
          if (responseMap['pageInfo'] != null) {
            final pageInfo = responseMap['pageInfo'];
            print('Page info: ${pageInfo}');
          }

          // Safely map each item to BodyComposition
          final List<BodyComposition> compositions = [];
          for (final item in dataList) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                // Transform the data to match the model
                String measurementDate;
                if (item['measurementDate'] is List) {
                  // Convert [2025, 9, 21] to "2025-09-21"
                  final dateList = item['measurementDate'] as List;
                  if (dateList.length >= 3) {
                    final year = dateList[0];
                    final month = dateList[1].toString().padLeft(2, '0');
                    final day = dateList[2].toString().padLeft(2, '0');
                    measurementDate = '$year-$month-$day';
                  } else {
                    measurementDate = DateTime.now().toIso8601String().split('T')[0];
                  }
                } else {
                  measurementDate = item['measurementDate']?.toString() ?? DateTime.now().toIso8601String().split('T')[0];
                }

                final Map<String, dynamic> transformedItem = {
                  'id': item['id'],
                  'member': {
                    'id': item['memberId']
                  }, // Transform memberId to member object
                  'measurementDate': measurementDate,
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
                String measurementDate;
                if (item['measurementDate'] is List) {
                  // Convert [2025, 9, 21] to "2025-09-21"
                  final dateList = item['measurementDate'] as List;
                  if (dateList.length >= 3) {
                    final year = dateList[0];
                    final month = dateList[1].toString().padLeft(2, '0');
                    final day = dateList[2].toString().padLeft(2, '0');
                    measurementDate = '$year-$month-$day';
                  } else {
                    measurementDate = DateTime.now().toIso8601String().split('T')[0];
                  }
                } else {
                  measurementDate = item['measurementDate']?.toString() ?? DateTime.now().toIso8601String().split('T')[0];
                }

                final Map<String, dynamic> transformedItem = {
                  'id': item['id'],
                  'member': {'id': item['memberId']},
                  'measurementDate': measurementDate,
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
          
          // Handle response format like {"data": 7}
          if (responseData.containsKey('data') && responseData['data'] is int) {
            final Map<String, dynamic> transformedData = {
              'id': responseData['data'],
              'member': {'id': 0}, // Default member ID
              'measurementDate': measurementDate,
              'weightKg': weightKg,
              'fatKg': fatKg,
              'muscleMassKg': muscleMassKg,
            };
            return BodyComposition.fromJson(transformedData);
          }
          
          // Handle other Map formats
          final Map<String, dynamic> transformedData = {
            'id': responseData['id'] ?? responseData['data'] ?? 0,
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

  /// 몸사진 업로드
  Future<List<BodyImageResponse>> uploadBodyImages({
    required List<XFile> images,
    required String date,
  }) async {
    try {
      print('=== Body Images Upload Debug ===');
      print('Uploading ${images.length} images for date: $date');

      final formData = FormData();
      
      // 날짜 추가
      formData.fields.add(MapEntry('date', date));
      
      // 이미지 파일들 추가 (프로필 이미지 업로드 방식과 동일하게)
      for (final imageFile in images) {
        // 파일 확장자와 MIME 타입 확인
        final String fileName = imageFile.name.toLowerCase();
        String mimeType;
        
        if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
          mimeType = 'image/jpeg';
        } else if (fileName.endsWith('.png')) {
          mimeType = 'image/png';
        } else if (fileName.endsWith('.webp')) {
          mimeType = 'image/webp';
        } else {
          throw Exception('지원하지 않는 이미지 형식입니다. JPG, PNG, WebP만 가능합니다.');
        }

        formData.files.add(MapEntry(
          'images',
          MultipartFile.fromFileSync(
            imageFile.path,
            filename: imageFile.name,
            contentType: DioMediaType.parse(mimeType),
          ),
        ));
        print('Added image: ${imageFile.name} with MIME type: $mimeType');
      }

      final response = await _dio.post(
        '/common/members/me/body-images',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('Body images upload success: ${response.statusCode} - ${response.data}');

      if (response.data is List) {
        return (response.data as List)
            .map((item) => BodyImageResponse.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('=== Body Images Upload Error ===');
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      print('Upload error: $e');
      throw Exception('몸사진 업로드 실패: $e');
    }
  }

  /// 기간별 몸사진 조회
  Future<List<BodyImageResponse>> getBodyImages({
    required String startDate,
    required String endDate,
  }) async {
    try {
      print('=== Body Images Get Debug ===');
      print('Getting body images from $startDate to $endDate');

      final response = await _dio.get(
        '/common/members/me/body-images',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
      );

      print('Body images get success: ${response.statusCode} - ${response.data}');

      // API 응답이 {"data": [...]} 형태로 온다
      if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        if (responseMap['data'] is List) {
          final imageList = responseMap['data'] as List;
          return imageList.map((item) {
            final imageItem = item as Map<String, dynamic>;

            // recordDate가 배열 형태로 오는 경우 변환
            String recordDate;
            if (imageItem['recordDate'] is List) {
              final dateList = imageItem['recordDate'] as List;
              if (dateList.length >= 3) {
                final year = dateList[0];
                final month = dateList[1].toString().padLeft(2, '0');
                final day = dateList[2].toString().padLeft(2, '0');
                recordDate = '$year-$month-$day';
              } else {
                recordDate = DateTime.now().toIso8601String().split('T')[0];
              }
            } else {
              recordDate = imageItem['recordDate']?.toString() ?? DateTime.now().toIso8601String().split('T')[0];
            }

            final transformedItem = Map<String, dynamic>.from(imageItem);
            transformedItem['recordDate'] = recordDate;

            return BodyImageResponse.fromJson(transformedItem);
          }).toList();
        }
      }

      // 직접 List로 오는 경우 (fallback)
      if (response.data is List) {
        return (response.data as List).map((item) {
          final imageItem = item as Map<String, dynamic>;

          // recordDate가 배열 형태로 오는 경우 변환
          String recordDate;
          if (imageItem['recordDate'] is List) {
            final dateList = imageItem['recordDate'] as List;
            if (dateList.length >= 3) {
              final year = dateList[0];
              final month = dateList[1].toString().padLeft(2, '0');
              final day = dateList[2].toString().padLeft(2, '0');
              recordDate = '$year-$month-$day';
            } else {
              recordDate = DateTime.now().toIso8601String().split('T')[0];
            }
          } else {
            recordDate = imageItem['recordDate']?.toString() ?? DateTime.now().toIso8601String().split('T')[0];
          }

          final transformedItem = Map<String, dynamic>.from(imageItem);
          transformedItem['recordDate'] = recordDate;

          return BodyImageResponse.fromJson(transformedItem);
        }).toList();
      }

      return [];
    } catch (e) {
      print('=== Body Images Get Error ===');
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        
        if (e.response?.statusCode == 404) {
          print('No body images found for the specified period');
          return []; // 404는 이미지가 없다는 의미이므로 빈 리스트 반환
        }
      }
      print('Get body images error: $e');
      throw Exception('몸사진 조회 실패: $e');
    }
  }

  /// 몸사진 삭제
  Future<void> deleteBodyImage(int fileId) async {
    try {
      print('=== Body Image Delete Debug ===');
      print('Deleting body image with ID: $fileId');

      final response = await _dio.delete('/common/file/$fileId');

      print('Body image delete success: ${response.statusCode}');
    } catch (e) {
      print('=== Body Image Delete Error ===');
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        
        if (e.response?.statusCode == 401) {
          throw Exception('인증되지 않은 사용자입니다.');
        } else if (e.response?.statusCode == 403) {
          throw Exception('해당 파일을 삭제할 권한이 없습니다.');
        } else if (e.response?.statusCode == 404) {
          throw Exception('존재하지 않는 파일입니다.');
        }
      }
      print('Delete body image error: $e');
      throw Exception('몸사진 삭제 실패: $e');
    }
  }
}
