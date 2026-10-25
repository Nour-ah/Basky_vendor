import 'package:firebase_messaging/firebase_messaging.dart';

import '../cache_helper/local_storage.dart';

class PushNotificationPayload {
  PushNotificationPayload({
    required this.data,
    this.title,
    this.body,
    this.titleAr,
    this.bodyAr,
    this.type,
    this.referenceId,
    DateTime? receivedAt,
  }) : receivedAt = receivedAt ?? DateTime.now();

  factory PushNotificationPayload.fromRemoteMessage(RemoteMessage message) {
    return PushNotificationPayload.fromMap(
      _enrich(Map<String, dynamic>.from(message.data), message.notification),
    );
  }

  factory PushNotificationPayload.fromMap(Map<String, dynamic> raw) {
    final data = Map<String, dynamic>.from(raw);
    return PushNotificationPayload(
      data: data,
      title: _string(data['title']) ?? _string(data['title_en']),
      body: _string(data['body']) ??
          _string(data['body_en']) ??
          _string(data['message']),
      titleAr: _string(data['title_ar']) ?? _string(data['titleAr']),
      bodyAr: _string(data['body_ar']) ??
          _string(data['bodyAr']) ??
          _string(data['message_ar']),
      type: _resolveType(data),
      referenceId: _resolveReferenceId(data),
      receivedAt: DateTime.now(),
    );
  }

  factory PushNotificationPayload.fromInboxJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : <String, dynamic>{};

    return PushNotificationPayload(
      data: data,
      title: _string(json['title']),
      body: _string(json['body']),
      titleAr: _string(json['titleAr']),
      bodyAr: _string(json['bodyAr']),
      type: _string(json['type']),
      referenceId: _string(json['referenceId']),
      receivedAt: DateTime.tryParse(_string(json['receivedAt']) ?? '') ??
          DateTime.now(),
    );
  }

  final Map<String, dynamic> data;
  final String? title;
  final String? body;
  final String? titleAr;
  final String? bodyAr;
  final String? type;
  final String? referenceId;
  final DateTime receivedAt;

  Future<bool> get isArabic async {
    final lang = await LocalStorage.getLanguage();
    return (lang ?? 'ar') == 'ar';
  }

  bool get isArabicSync {
    // Prefer Arabic as app default when locale is unknown.
    return true;
  }

  String get displayTitle {
    if (isArabicSync) {
      return titleAr ?? title ?? _fallbackTitle(true);
    }
    return title ?? titleAr ?? _fallbackTitle(false);
  }

  String get displayBody {
    if (isArabicSync) {
      return bodyAr ?? body ?? _fallbackBody(true);
    }
    return body ?? bodyAr ?? _fallbackBody(false);
  }

  bool get hasVisibleContent =>
      displayTitle.isNotEmpty || displayBody.isNotEmpty;

  bool get hasExplicitOrderId =>
      vendorOrderId != null ||
      _positiveInt(data['order_id']) != null ||
      _positiveInt(data['orderId']) != null;

  /// Vendor-orders row id when backend sends it explicitly.
  int? get vendorOrderId =>
      _positiveInt(data['vendor_order_id']) ??
      _positiveInt(data['vendor_orderId']) ??
      _positiveInt(data['vendorOrderId']);

  /// Platform order id from notification (`order_id`), NOT the vendor row id.
  int? get orderId {
    final fromOrder =
        _positiveInt(data['order_id']) ?? _positiveInt(data['orderId']);
    if (fromOrder != null) return fromOrder;

    final normalizedType = (type ?? '').toLowerCase();
    // Prescription reference ids must not be treated as order ids.
    if (normalizedType.contains('prescription') &&
        !normalizedType.contains('order')) {
      return null;
    }

    return _positiveInt(referenceId);
  }

  int? get prescriptionRequestId {
    final fromData = _positiveInt(data['prescription_request_id']) ??
        _positiveInt(data['prescription_id']);
    if (fromData != null) return fromData;

    final normalizedType = (type ?? '').toLowerCase();
    if (normalizedType.contains('prescription')) {
      return _positiveInt(referenceId);
    }
    return null;
  }

  Map<String, dynamic> toInboxJson() => {
        'title': title ?? displayTitle,
        'body': body ?? displayBody,
        'titleAr': titleAr,
        'bodyAr': bodyAr,
        'type': type,
        'referenceId': referenceId,
        'receivedAt': receivedAt.toIso8601String(),
        'data': data,
      };

  Map<String, dynamic> toNavigationMap() => {
        ...data,
        if (title != null) 'title': title,
        if (body != null) 'body': body,
        if (titleAr != null) 'titleAr': titleAr,
        if (bodyAr != null) 'bodyAr': bodyAr,
        if (type != null) 'type': type,
        if (referenceId != null) 'referenceId': referenceId,
      };

  static Map<String, dynamic> _enrich(
    Map<String, dynamic> data,
    RemoteNotification? notification,
  ) {
    data.putIfAbsent('title', () => notification?.title);
    data.putIfAbsent('body', () => notification?.body);
    data.putIfAbsent('title_ar', () => data['titleAr']);
    data.putIfAbsent('body_ar', () => data['bodyAr'] ?? data['messageAr']);
    return data;
  }

  static String? _string(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String? _resolveType(Map<String, dynamic> data) {
    return _string(data['type']) ??
        _string(data['notification_type']) ??
        _string(data['action']) ??
        _string(data['event']);
  }

  static String? _resolveReferenceId(Map<String, dynamic> data) {
    // Never fall back to notification row `id` — that is not an order id.
    return _string(data['reference_id']) ??
        _string(data['referenceId']) ??
        _string(data['order_id']) ??
        _string(data['orderId']) ??
        _string(data['prescription_request_id']) ??
        _string(data['prescription_id']);
  }

  static int? _positiveInt(dynamic value) {
    if (value == null) return null;
    final parsed = value is int
        ? value
        : value is num
            ? value.toInt()
            : int.tryParse(value.toString().trim());
    if (parsed == null || parsed <= 0) return null;
    return parsed;
  }

  String _fallbackTitle(bool arabic) {
    final normalized = type?.toLowerCase() ?? '';
    if (normalized.contains('prescription')) {
      return arabic ? 'طلب روشتة' : 'Prescription request';
    }
    if (normalized.contains('order')) {
      return arabic ? 'تحديث الطلب' : 'Order update';
    }
    if (normalized.contains('wallet')) {
      return arabic ? 'إشعار المحفظة' : 'Wallet notification';
    }
    return arabic ? 'إشعار جديد' : 'New notification';
  }

  String _fallbackBody(bool arabic) {
    return arabic ? 'لديك إشعار جديد' : 'You have a new notification';
  }
}
