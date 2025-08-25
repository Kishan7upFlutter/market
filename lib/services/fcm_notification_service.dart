import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// Background & Kill state handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("📩 Background/Kill Notification: ${message.notification?.title}");
}

class PushNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Initialize FCM
  static Future<void> initNotifications(BuildContext context) async {
    // Request Permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("📌 Permission Status: ${settings.authorizationStatus}");

    // Token Print (Device Token)
    String? token = await _fcm.getToken();
    debugPrint("📌 FCM Token: $token");

    // Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground Notification: ${message.notification?.title}");
      _showDialog(context, "Foreground", message.notification?.title ?? "");
    });

    // Background tap se app open
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📩 App opened by notification: ${message.notification?.title}");
      _showDialog(context, "Background", message.notification?.title ?? "");
    });

    // Kill state (App band thi, notification se open hui)
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("📩 Kill State Notification: ${initialMessage.notification?.title}");
      _showDialog(context, "Kill State", initialMessage.notification?.title ?? "");
    }
  }

  /// Get current FCM Token (anywhere in app)
  static Future<String?> getToken() async {
    return await _fcm.getToken();
  }

  /// Helper - show dialog for demo
  static void _showDialog(BuildContext context, String state, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Notification from $state"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }
}
