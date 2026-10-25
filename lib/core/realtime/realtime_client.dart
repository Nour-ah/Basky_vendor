import 'dart:async';
import 'dart:convert';

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/foundation.dart';

import '../cache_helper/local_storage.dart';
import '../config/env_config.dart';

/// Single Reverb (Pusher protocol) connection shared by the whole app.
///
/// Channels are ref-counted: several listeners on the same channel share one
/// subscription, which is dropped when the last listener cancels.
class RealtimeClient {
  PusherChannelsClient? _client;
  String? _token;
  Future<PusherChannelsClient?>? _connecting;
  StreamSubscription<void>? _connectionSub;
  final Map<String, _ChannelEntry> _channels = {};

  /// Emits decoded payloads of [eventName] on the private [channelName]
  /// (without the `private-` prefix, e.g. `vendor.16.orders`).
  ///
  /// Never errors: if realtime is not configured or the user is logged out,
  /// the stream simply stays silent.
  Stream<Map<String, dynamic>> listen({
    required String channelName,
    required String eventName,
  }) {
    final fullName = 'private-$channelName';
    StreamSubscription<ChannelReadEvent>? eventSub;
    var acquired = false;
    var cancelled = false;

    late final StreamController<Map<String, dynamic>> controller;
    controller = StreamController<Map<String, dynamic>>(
      onListen: () async {
        final channel = await _acquire(fullName);
        if (channel == null) return;
        acquired = true;
        if (cancelled) {
          _release(fullName);
          return;
        }
        eventSub = channel.bind(eventName).listen((event) {
          debugPrint('Realtime: event $eventName on $fullName');
          final data = _decode(event.data);
          if (data != null && !controller.isClosed) controller.add(data);
        });
      },
      onCancel: () async {
        cancelled = true;
        await eventSub?.cancel();
        if (acquired) _release(fullName);
      },
    );
    return controller.stream;
  }

  /// Drops every subscription and closes the socket (e.g. on logout).
  Future<void> disconnect() async {
    final pending = _connecting;
    _connecting = null;
    final client = _client ?? await pending;
    _client = null;
    _token = null;

    await _connectionSub?.cancel();
    _connectionSub = null;
    for (final entry in _channels.values) {
      await entry.dispose();
    }
    _channels.clear();

    if (client != null && !client.isDisposed) {
      client.dispose();
    }
  }

  Future<PrivateChannel?> _acquire(String fullName) async {
    final client = await _ensureClient();
    if (client == null || client.isDisposed) return null;

    final entry = _channels.putIfAbsent(
      fullName,
      () => _ChannelEntry(_createChannel(client, fullName)),
    );
    entry.refs++;
    if (entry.refs == 1) entry.channel.subscribe();
    return entry.channel;
  }

  void _release(String fullName) {
    final entry = _channels[fullName];
    if (entry == null) return;
    entry.refs--;
    if (entry.refs > 0) return;
    _channels.remove(fullName);
    unawaited(entry.dispose());
  }

  Future<PusherChannelsClient?> _ensureClient() {
    if (_client != null) return Future.value(_client);
    return _connecting ??= _createClient().whenComplete(() {
      _connecting = null;
    });
  }

  Future<PusherChannelsClient?> _createClient() async {
    if (!EnvConfig.isRealtimeConfigured) {
      debugPrint('Realtime: disabled, .env is missing Reverb values');
      return null;
    }
    final token = await LocalStorage.getAuthToken();
    if (token == null || token.isEmpty) return null;

    final client = PusherChannelsClient.websocket(
      options: PusherChannelsOptions.fromHost(
        scheme: EnvConfig.reverbSocketScheme,
        host: EnvConfig.reverbHost,
        port: EnvConfig.reverbPort,
        key: EnvConfig.reverbAppKey,
      ),
      connectionErrorHandler: (exception, trace, refresh) {
        debugPrint('Realtime: connection error $exception, retrying');
        refresh();
      },
    );

    _connectionSub = client.onConnectionEstablished.listen((_) {
      debugPrint('Realtime: connected (socket ${client.socketId})');
      for (final entry in _channels.values) {
        entry.channel.subscribeIfNotUnsubscribed();
      }
    });

    _client = client;
    _token = token;
    unawaited(client.connect());
    return client;
  }

  PrivateChannel _createChannel(PusherChannelsClient client, String fullName) {
    return client.privateChannel(
      fullName,
      authorizationDelegate:
          EndpointAuthorizableChannelTokenAuthorizationDelegate
              .forPrivateChannel(
        authorizationEndpoint: EnvConfig.broadcastAuthUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        onAuthFailed: (exception, trace) {
          debugPrint('Realtime: auth failed for $fullName: $exception');
        },
      ),
    );
  }

  static Map<String, dynamic>? _decode(dynamic raw) {
    try {
      final value = raw is String ? jsonDecode(raw) : raw;
      if (value is Map) return Map<String, dynamic>.from(value);
    } catch (e) {
      debugPrint('Realtime: failed to decode event payload: $e');
    }
    return null;
  }
}

class _ChannelEntry {
  _ChannelEntry(this.channel) {
    _successSub = channel.whenSubscriptionSucceeded().listen(
          (_) => debugPrint('Realtime: subscribed to ${channel.name}'),
        );
    _errorSub = channel
        .bind(Channel.subscriptionErrorEventName)
        .listen((event) => debugPrint(
              'Realtime: subscription error on ${channel.name}: ${event.data}',
            ));
    if (kDebugMode) {
      _allEventsSub = channel.bindToAll().listen((event) => debugPrint(
            'Realtime: received "${event.name}" on ${channel.name}: '
            '${event.data}',
          ));
    }
  }

  final PrivateChannel channel;
  late final StreamSubscription<ChannelReadEvent> _successSub;
  late final StreamSubscription<ChannelReadEvent> _errorSub;
  StreamSubscription<ChannelReadEvent>? _allEventsSub;
  int refs = 0;

  Future<void> dispose() async {
    await _successSub.cancel();
    await _errorSub.cancel();
    await _allEventsSub?.cancel();
    channel.unsubscribe();
  }
}
