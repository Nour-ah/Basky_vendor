import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../cache_helper/local_storage.dart';
import '../network/api_constants.dart';

/// Sends FCM token to Basky (`/api/update-fcm-token`) after login / token refresh.
class DeviceTokenService {
  DeviceTokenService({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<bool> _isLoggedIn() async {
    final token = await LocalStorage.getAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> registerIfPossible() async {
    try {
      if (!await _isLoggedIn()) {
        if (kDebugMode) {
          debugPrint('DeviceToken: skip — not logged in');
        }
        return;
      }

      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null || fcmToken.trim().isEmpty) {
        if (kDebugMode) {
          debugPrint('DeviceToken: FCM token is empty');
        }
        return;
      }
      await registerWithToken(fcmToken.trim());
    } catch (e, s) {
      if (kDebugMode) {
        debugPrint('DeviceToken register failed: $e\n$s');
      }
    }
  }

  Future<void> registerWithToken(String fcmToken) async {
    final token = fcmToken.trim();
    if (token.isEmpty) return;
    try {
      if (!await _isLoggedIn()) return;
      await _updateToken(token);
    } catch (e, s) {
      if (kDebugMode) {
        debugPrint('DeviceToken register failed: $e\n$s');
      }
    }
  }

  Future<void> _updateToken(String fcmToken) async {
    final response = await _dio.post(
      ApiConstants.updateFcmToken,
      data: {'fcm_token': fcmToken},
    );

    if (kDebugMode) {
      debugPrint(
        'DeviceToken response: ${response.statusCode} ${response.data}',
      );
    }
  }
}
