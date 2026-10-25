import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Runs refresh callbacks when realtime events arrive, debounced so a burst
/// of events causes a single refetch. Cleaned up automatically on [close].
///
/// Each [key] holds one subscription; listening again with the same key
/// replaces the previous one.
mixin RealtimeRefreshMixin<S> on BlocBase<S> {
  static const Duration realtimeDebounce = Duration(milliseconds: 500);

  final Map<Object, StreamSubscription<Object?>> _realtimeSubs = {};
  Timer? _realtimeTimer;

  void listenForRealtimeRefresh(
    Stream<Object?> events,
    Future<void> Function() onRefresh, {
    Object key = RealtimeRefreshMixin,
  }) {
    unawaited(_realtimeSubs.remove(key)?.cancel());
    _realtimeSubs[key] = events.listen((_) {
      _realtimeTimer?.cancel();
      _realtimeTimer = Timer(realtimeDebounce, () {
        if (!isClosed) unawaited(onRefresh());
      });
    });
  }

  @override
  Future<void> close() async {
    _realtimeTimer?.cancel();
    await Future.wait(_realtimeSubs.values.map((sub) => sub.cancel()));
    _realtimeSubs.clear();
    return super.close();
  }
}
