import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageCacheManager {
  static const String _profileImagePrefix = 'profile_image_';
  static const String _bodyImagePrefix = 'body_image_';
  static const String _imageTimestampPrefix = 'image_timestamp_';
  
  static final ImageCacheManager _instance = ImageCacheManager._internal();
  factory ImageCacheManager() => _instance;
  ImageCacheManager._internal();

  Future<String?> getCachedImage({
    required String imageUrl,
    required String cacheKey,
    required ImageType type,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefix = type == ImageType.profile ? _profileImagePrefix : _bodyImagePrefix;
      final cachedImagePath = prefs.getString('$prefix$cacheKey');
      
      if (cachedImagePath != null) {
        final file = File(cachedImagePath);
        if (await file.exists()) {
          return cachedImagePath;
        }
      }
      
      final downloadedPath = await _downloadAndCacheImage(imageUrl, cacheKey, type);
      return downloadedPath;
    } catch (e) {
      print('Error getting cached image: $e');
      return null;
    }
  }

  Future<String?> _downloadAndCacheImage(
    String imageUrl,
    String cacheKey,
    ImageType type,
  ) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final prefix = type == ImageType.profile ? 'profile' : 'body';
        final filePath = '${directory.path}/${prefix}_$cacheKey.jpg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        final prefs = await SharedPreferences.getInstance();
        final prefixKey = type == ImageType.profile ? _profileImagePrefix : _bodyImagePrefix;
        await prefs.setString('$prefixKey$cacheKey', filePath);
        await prefs.setInt('$_imageTimestampPrefix$cacheKey', DateTime.now().millisecondsSinceEpoch);
        
        return filePath;
      }
      return null;
    } catch (e) {
      print('Error downloading image: $e');
      return null;
    }
  }

  Future<void> clearCachedImage({
    required String cacheKey,
    required ImageType type,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefix = type == ImageType.profile ? _profileImagePrefix : _bodyImagePrefix;
      final cachedImagePath = prefs.getString('$prefix$cacheKey');
      
      if (cachedImagePath != null) {
        final file = File(cachedImagePath);
        if (await file.exists()) {
          await file.delete();
        }
        await prefs.remove('$prefix$cacheKey');
        await prefs.remove('$_imageTimestampPrefix$cacheKey');
      }
    } catch (e) {
      print('Error clearing cached image: $e');
    }
  }

  Future<void> updateCachedImage({
    required String imageUrl,
    required String cacheKey,
    required ImageType type,
  }) async {
    await clearCachedImage(cacheKey: cacheKey, type: type);
    await _downloadAndCacheImage(imageUrl, cacheKey, type);
  }

  Future<bool> hasValidCache({
    required String cacheKey,
    required ImageType type,
    Duration? maxAge,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefix = type == ImageType.profile ? _profileImagePrefix : _bodyImagePrefix;
      final cachedImagePath = prefs.getString('$prefix$cacheKey');
      
      if (cachedImagePath == null) return false;
      
      final file = File(cachedImagePath);
      if (!await file.exists()) return false;
      
      if (maxAge != null) {
        final timestamp = prefs.getInt('$_imageTimestampPrefix$cacheKey');
        if (timestamp != null) {
          final age = DateTime.now().millisecondsSinceEpoch - timestamp;
          if (age > maxAge.inMilliseconds) return false;
        }
      }
      
      return true;
    } catch (e) {
      print('Error checking cache validity: $e');
      return false;
    }
  }

  Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final directory = await getApplicationDocumentsDirectory();
      
      for (final key in keys) {
        if (key.startsWith(_profileImagePrefix) || key.startsWith(_bodyImagePrefix)) {
          final path = prefs.getString(key);
          if (path != null) {
            final file = File(path);
            if (await file.exists()) {
              await file.delete();
            }
          }
          await prefs.remove(key);
        }
        if (key.startsWith(_imageTimestampPrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing all cache: $e');
    }
  }
}

enum ImageType {
  profile,
  body,
}