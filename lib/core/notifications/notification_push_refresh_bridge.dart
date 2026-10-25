import 'dart:async';

import 'push_notification_payload.dart';

typedef PushRefreshListener = void Function(PushNotificationPayload payload);

class NotificationPushRefreshBridge {
  NotificationPushRefreshBridge._();

  static final StreamController<PushNotificationPayload> _controller =
      StreamController<PushNotificationPayload>.broadcast();

  static Stream<PushNotificationPayload> get stream => _controller.stream;

  static void notify({required PushNotificationPayload payload}) {
    if (_controller.isClosed) return;
    _controller.add(payload);
  }

  static StreamSubscription<PushNotificationPayload> listen(
    PushRefreshListener listener,
  ) {
    return stream.listen(listener);
  }
}
