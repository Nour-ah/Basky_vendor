import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'device_token_service.dart';
import 'notification_inbox_store.dart';
import 'notification_local_display.dart';
import 'notification_navigation.dart';
import 'notification_push_refresh_bridge.dart';
import 'push_notification_payload.dart';

class NotificationsServices {
  NotificationsServices({required DeviceTokenService deviceTokenService})
      : _deviceTokenService = deviceTokenService;

  final DeviceTokenService _deviceTokenService;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  bool _fcmInitialized = false;
  bool _permissionRequested = false;

  Future<void> initFcm({bool handleInitialMessage = false}) async {
    if (_fcmInitialized) return;
    _fcmInitialized = true;

    try {
      await _requestNotificationPermissionOnce();

      if (Platform.isIOS) {
        await _messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      final token = await _messaging.getToken();
      if (kDebugMode) {
        debugPrint('FCM TOKEN: $token');
      }

      if (token != null && token.isNotEmpty) {
        unawaited(_deviceTokenService.registerWithToken(token));
      }

      if (handleInitialMessage) {
        final initialMessage = await _messaging.getInitialMessage();
        if (initialMessage != null) {
          final payload =
              PushNotificationPayload.fromRemoteMessage(initialMessage);
          await _persistIncomingNotification(payload);
          NotificationNavigation.setPending(payload.toNavigationMap());
        }
      }
    } catch (e, s) {
      if (kDebugMode) {
        debugPrint('FCM ERROR: $e\n$s');
      }
    }

    _messaging.onTokenRefresh.listen((newToken) {
      if (kDebugMode) {
        debugPrint('NEW FCM TOKEN :: $newToken');
      }
      unawaited(_deviceTokenService.registerWithToken(newToken));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final payload = PushNotificationPayload.fromRemoteMessage(message);
      unawaited(_handleNotificationOpened(payload));
    });

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  Future<void> _requestNotificationPermissionOnce() async {
    if (_permissionRequested) return;
    _permissionRequested = true;

    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (kDebugMode) {
        debugPrint('FCM permission: ${settings.authorizationStatus}');
      }
    } catch (e, s) {
      if (kDebugMode) {
        debugPrint('Notification permission error: $e\n$s');
      }
    }
  }

  Future<void> initLocalNotification() async {
    await NotificationLocalDisplay.ensureInitialized(
      onTap: _handleLocalNotificationTap,
    );
  }

  Future<void> processPendingNavigation() async {
    NotificationNavigation.processPendingIfAny();
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (title.isEmpty && body.isEmpty) return;

    final data = <String, dynamic>{
      'title': title,
      'body': body,
      if (payload != null) ..._decodePayload(payload),
    };

    await NotificationLocalDisplay.show(
      id: id,
      payload: PushNotificationPayload.fromMap(data),
      onTap: _handleLocalNotificationTap,
    );
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final payload = PushNotificationPayload.fromRemoteMessage(message);

    if (kDebugMode) {
      debugPrint('onMessage ${payload.displayTitle}');
      debugPrint('onMessage ${payload.displayBody}');
      debugPrint('onMessage data: ${payload.data}');
    }

    await _persistIncomingNotification(payload);

    if (payload.hasVisibleContent) {
      await NotificationLocalDisplay.show(
        id: message.hashCode,
        payload: payload,
        onTap: _handleLocalNotificationTap,
      );
    }
  }

  Future<void> _handleNotificationOpened(
    PushNotificationPayload payload,
  ) async {
    await _persistIncomingNotification(payload);
    _notifyPushRefresh(payload);
    await NotificationNavigation.handlePushTap(payload.toNavigationMap());
  }

  Future<void> _persistIncomingNotification(
    PushNotificationPayload payload,
  ) async {
    await NotificationInboxStore.save(payload);
    _notifyPushRefresh(payload);
  }

  void _notifyPushRefresh(PushNotificationPayload payload) {
    NotificationPushRefreshBridge.notify(payload: payload);
    if (kDebugMode) {
      debugPrint('Push data: ${payload.toNavigationMap()}');
    }
  }

  void _handleLocalNotificationTap(String? payload) {
    if (payload == null || payload.isEmpty) return;

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map) return;

      final data = Map<String, dynamic>.from(decoded);
      if (kDebugMode) {
        debugPrint('Notification tap payload: $data');
      }
      unawaited(NotificationNavigation.handlePushTap(data));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Notification payload parse error: $e');
      }
    }
  }

  Map<String, dynamic> _decodePayload(String payload) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
    return {};
  }
}
