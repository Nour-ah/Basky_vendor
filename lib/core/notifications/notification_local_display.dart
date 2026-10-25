import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'push_notification_payload.dart';

class NotificationLocalDisplay {
  NotificationLocalDisplay._();

  static const _androidChannelId = 'basky_vendor_high_importance';
  static const _androidChannelName = 'High Importance Notifications';

  static FlutterLocalNotificationsPlugin? _plugin;
  static bool _initialized = false;

  static Future<FlutterLocalNotificationsPlugin> ensureInitialized({
    void Function(String? payload)? onTap,
  }) async {
    if (_plugin != null && _initialized) {
      return _plugin!;
    }

    _plugin = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin!.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: onTap == null
          ? null
          : (response) => onTap(response.payload),
    );

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        description: 'Used for important notifications.',
        importance: Importance.high,
      );

      final androidPlugin = _plugin!.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(channel);
      await androidPlugin?.requestNotificationsPermission();
    }

    _initialized = true;
    return _plugin!;
  }

  static Future<void> show({
    required PushNotificationPayload payload,
    required int id,
    void Function(String? payload)? onTap,
  }) async {
    if (!payload.hasVisibleContent) return;

    final plugin = await ensureInitialized(onTap: onTap);

    const androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: 'Used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await plugin.show(
      id,
      payload.displayTitle,
      payload.displayBody,
      const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: jsonEncode(payload.toNavigationMap()),
    );
  }
}
