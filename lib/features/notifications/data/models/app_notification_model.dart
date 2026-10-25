import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    required super.id,
    super.type,
    required super.title,
    required super.body,
    super.data,
    super.createdAt,
    super.readAt,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    final nested = json['data'];
    final Map<String, dynamic> payload = nested is Map
        ? Map<String, dynamic>.from(nested)
        : <String, dynamic>{};

    // Backend may put navigation ids on the root instead of nested data.
    _copyIfAbsent(payload, json, const [
      'order_id',
      'orderId',
      'vendor_order_id',
      'vendor_orderId',
      'vendorOrderId',
      'reference_id',
      'referenceId',
      'prescription_request_id',
      'prescription_id',
      'notification_type',
      'type',
      'action',
      'event',
    ]);

    final title = JsonParsers.asString(json['title']) ??
        JsonParsers.asString(payload['title']) ??
        JsonParsers.asString(payload['title_ar']) ??
        JsonParsers.asString(payload['title_en']) ??
        '';

    final body = JsonParsers.asString(json['body']) ??
        JsonParsers.asString(json['message']) ??
        JsonParsers.asString(payload['body']) ??
        JsonParsers.asString(payload['message']) ??
        JsonParsers.asString(payload['body_ar']) ??
        '';

    final type = JsonParsers.asString(json['type']) ??
        JsonParsers.asString(payload['type']) ??
        JsonParsers.asString(payload['notification_type']);

    return AppNotificationModel(
      id: JsonParsers.asString(json['id']) ?? '',
      type: type,
      title: title,
      body: body,
      data: payload,
      createdAt: DateTime.tryParse(
        JsonParsers.asString(json['created_at']) ?? '',
      ),
      readAt: DateTime.tryParse(
        JsonParsers.asString(json['read_at']) ?? '',
      ),
    );
  }

  static void _copyIfAbsent(
    Map<String, dynamic> target,
    Map<String, dynamic> source,
    List<String> keys,
  ) {
    for (final key in keys) {
      if (target.containsKey(key) && target[key] != null) continue;
      final value = source[key];
      if (value != null) target[key] = value;
    }
  }
}
