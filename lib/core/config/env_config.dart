import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to values loaded from the `.env` asset.
class EnvConfig {
  EnvConfig._();

  /// Optional so a missing/empty `.env` disables realtime instead of crashing.
  static Future<void> load() => dotenv.load(fileName: '.env', isOptional: true);

  static String get reverbAppKey => _required('REVERB_APP_KEY');

  static String get reverbHost => _required('REVERB_HOST');

  static int get reverbPort =>
      int.tryParse(dotenv.env['REVERB_PORT'] ?? '') ?? 443;

  /// `https` maps to a secure `wss` socket, anything else to `ws`.
  static String get reverbSocketScheme =>
      (dotenv.env['REVERB_SCHEME'] ?? 'https') == 'https' ? 'wss' : 'ws';

  static Uri get broadcastAuthUrl => Uri.parse(_required('BROADCAST_AUTH_URL'));

  static bool get isRealtimeConfigured =>
      dotenv.isInitialized &&
      (dotenv.env['REVERB_APP_KEY'] ?? '').isNotEmpty &&
      (dotenv.env['REVERB_HOST'] ?? '').isNotEmpty &&
      (dotenv.env['BROADCAST_AUTH_URL'] ?? '').isNotEmpty;

  static String _required(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing $key in .env');
    }
    return value;
  }
}
