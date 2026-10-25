import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../cache_helper/local_storage.dart';
import '../di/injection_container.dart';
import '../navigation/app_navigator.dart';
import '../../features/auth/presentation/pages/auth_options_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/orders/domain/usecases/resolve_vendor_order_id_usecase.dart';
import '../../features/orders/presentation/pages/order_details_page.dart';
import '../../features/prescriptions/presentation/pages/vendor_prescription_request_details_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import 'push_notification_payload.dart';

class NotificationNavigation {
  NotificationNavigation._();

  static Map<String, dynamic>? _pendingTapData;

  static void setPending(Map<String, dynamic> data) {
    _pendingTapData = Map<String, dynamic>.from(data);
  }

  static void processPendingIfAny() {
    final data = _pendingTapData;
    if (data == null) return;
    _pendingTapData = null;
    unawaited(handlePushTap(data));
  }

  static Future<void> handlePushTap(Map<String, dynamic> data) async {
    final payload = PushNotificationPayload.fromMap(data);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      unawaited(_navigate(payload));
    });
  }

  static Future<void> _navigate(PushNotificationPayload payload) async {
    try {
      final token = await LocalStorage.getAuthToken();
      final isLoggedIn = token != null && token.isNotEmpty;
      final type = (payload.type ?? '').toLowerCase();
      final orderId = payload.orderId;
      final prescriptionId = payload.prescriptionRequestId;
      final navigator = AppNavigator.key.currentState;

      if (navigator == null) {
        setPending(payload.toNavigationMap());
        return;
      }

      if (!isLoggedIn) {
        navigator.push(
          MaterialPageRoute(builder: (_) => const AuthOptionsPage()),
        );
        return;
      }

      // Prefer an explicit order_id (e.g. prescription confirmed → order created).
      if (payload.hasExplicitOrderId && orderId != null && orderId > 0) {
        await _openOrderDetails(navigator, payload);
        return;
      }

      if (_matches(type, const ['prescription', 'prescription_request']) &&
          prescriptionId != null &&
          prescriptionId > 0) {
        navigator.push(
          MaterialPageRoute(
            builder: (_) => VendorPrescriptionRequestDetailsPage(
              requestId: prescriptionId,
            ),
          ),
        );
        return;
      }

      if (_matches(type, const ['order', 'order_status', 'delivery']) &&
          orderId != null &&
          orderId > 0) {
        await _openOrderDetails(navigator, payload);
        return;
      }

      if (orderId != null && orderId > 0) {
        await _openOrderDetails(navigator, payload);
        return;
      }

      if (_matches(type, const [
        'wallet',
        'transaction',
        'payment',
        'withdrawal',
      ])) {
        navigator.push(
          MaterialPageRoute(builder: (_) => const WalletPage()),
        );
        return;
      }

      if (_matches(type, const ['profile', 'account'])) {
        navigator.push(
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
        return;
      }

      navigator.push(
        MaterialPageRoute(builder: (_) => const NotificationsPage()),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Notification navigation error: $e');
      }
    }
  }

  /// Resolves platform `order_id` → vendor order row `id` before opening details.
  static Future<void> _openOrderDetails(
    NavigatorState navigator,
    PushNotificationPayload payload,
  ) async {
    final explicitVendorId = payload.vendorOrderId;
    if (explicitVendorId != null && explicitVendorId > 0) {
      navigator.push(
        MaterialPageRoute(
          builder: (_) => OrderDetailsPage(orderId: explicitVendorId),
        ),
      );
      return;
    }

    final platformOrderId = payload.orderId;
    if (platformOrderId == null || platformOrderId <= 0) return;

    final resolved = await sl<ResolveVendorOrderIdUseCase>()(platformOrderId);
    resolved.fold(
      (failure) {
        if (kDebugMode) {
          debugPrint(
            'NotificationNavigation: failed to resolve order '
            '#$platformOrderId → ${failure.message}',
          );
        }
        navigator.push(
          MaterialPageRoute(builder: (_) => const NotificationsPage()),
        );
      },
      (vendorOrderId) {
        if (kDebugMode) {
          debugPrint(
            'NotificationNavigation: resolved order_id=$platformOrderId '
            '→ vendorOrderId=$vendorOrderId',
          );
        }
        navigator.push(
          MaterialPageRoute(
            builder: (_) => OrderDetailsPage(orderId: vendorOrderId),
          ),
        );
      },
    );
  }

  static bool _matches(String type, List<String> keys) {
    for (final key in keys) {
      if (type.contains(key)) return true;
    }
    return false;
  }
}
