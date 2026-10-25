import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'push_notification_payload.dart';

class NotificationInboxStore {
  NotificationInboxStore._();

  static const _storageKey = 'notification_inbox';
  static const _maxItems = 50;

  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  static Future<void> save(PushNotificationPayload payload) async {
    final prefs = await _prefs();
    final items = await loadRaw();
    items.insert(0, payload.toInboxJson());

    if (items.length > _maxItems) {
      items.removeRange(_maxItems, items.length);
    }

    await prefs.setString(_storageKey, jsonEncode(items));
  }

  static Future<List<PushNotificationPayload>> load() async {
    final items = await loadRaw();
    return items
        .map(
          (item) => PushNotificationPayload.fromInboxJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  static Future<List<Map<String, dynamic>>> loadRaw() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];

      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> clear() async {
    final prefs = await _prefs();
    await prefs.remove(_storageKey);
  }
}
