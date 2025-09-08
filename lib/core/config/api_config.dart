import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';
  
  static String get imageBaseUrl => dotenv.env['API_BASE_URL']?.replaceFirst('/api', '') ?? 'http://localhost:8080';
  
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}