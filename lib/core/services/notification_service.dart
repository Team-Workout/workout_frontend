import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  static GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  
  static void setScaffoldMessengerKey(GlobalKey<ScaffoldMessengerState> key) {
    scaffoldMessengerKey = key;
  }

  void showForegroundNotification({
    required String title,
    required String body,
  }) {
    if (scaffoldMessengerKey?.currentState != null) {
      scaffoldMessengerKey!.currentState!.showSnackBar(
        SnackBar(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (body.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ],
          ),
          backgroundColor: Colors.blue[800],
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          action: SnackBarAction(
            label: '닫기',
            textColor: Colors.white,
            onPressed: () {
              scaffoldMessengerKey!.currentState!.hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }
}