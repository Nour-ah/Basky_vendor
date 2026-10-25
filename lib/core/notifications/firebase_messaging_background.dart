import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../firebase_options.dart';
import 'notification_inbox_store.dart';
import 'notification_local_display.dart';
import 'push_notification_payload.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  final payload = PushNotificationPayload.fromRemoteMessage(message);

  if (kDebugMode) {
    debugPrint('======================= onBackground =======================');
    debugPrint(payload.displayTitle);
    debugPrint(payload.displayBody);
    debugPrint('${payload.data}');
    debugPrint('==========================================================');
  }

  await NotificationInboxStore.save(payload);

  if (message.notification == null && payload.hasVisibleContent) {
    await NotificationLocalDisplay.show(
      payload: payload,
      id: message.hashCode,
    );
  }
}
