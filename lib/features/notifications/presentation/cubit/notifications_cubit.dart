import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/notifications/notification_push_refresh_bridge.dart';
import '../../../../core/notifications/push_notification_payload.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase;

  StreamSubscription<PushNotificationPayload>? _pushSub;

  NotificationsCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
    required this.markAllNotificationsReadUseCase,
  }) : super(NotificationsInitial()) {
    _pushSub = NotificationPushRefreshBridge.listen((_) {
      loadNotifications(silent: true);
    });
  }

  Future<void> loadNotifications({bool silent = false}) async {
    if (isClosed) return;
    if (!silent || state is! NotificationsLoaded) {
      emit(NotificationsLoading());
    }

    final result = await getNotificationsUseCase();
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        NotificationsError(
          failure.message,
          isNetworkError: failure is NetworkFailure,
        ),
      ),
      (items) {
        if (items.isEmpty) {
          emit(NotificationsEmpty());
        } else {
          emit(NotificationsLoaded(notifications: items));
        }
      },
    );
  }

  Future<void> markAsRead(String id) async {
    if (isClosed) return;
    if (state is! NotificationsLoaded) return;
    final current = state as NotificationsLoaded;

    emit(current.copyWith(
      notifications: current.notifications.map((n) {
        if (n.id != id || n.isRead) return n;
        return AppNotification(
          id: n.id,
          type: n.type,
          title: n.title,
          body: n.body,
          data: n.data,
          createdAt: n.createdAt,
          readAt: DateTime.now(),
        );
      }).toList(),
      isUpdating: true,
    ));

    final result = await markNotificationReadUseCase(id);
    if (isClosed) return;

    result.fold(
      (_) => loadNotifications(silent: true),
      (_) {
        if (state is NotificationsLoaded) {
          emit((state as NotificationsLoaded).copyWith(isUpdating: false));
        }
      },
    );
  }

  Future<void> markAllAsRead() async {
    if (isClosed) return;
    if (state is! NotificationsLoaded) return;
    final current = state as NotificationsLoaded;

    emit(current.copyWith(
      notifications: current.notifications
          .map(
            (n) => AppNotification(
              id: n.id,
              type: n.type,
              title: n.title,
              body: n.body,
              data: n.data,
              createdAt: n.createdAt,
              readAt: n.readAt ?? DateTime.now(),
            ),
          )
          .toList(),
      isUpdating: true,
    ));

    final result = await markAllNotificationsReadUseCase();
    if (isClosed) return;

    result.fold(
      (_) => loadNotifications(silent: true),
      (_) {
        if (state is NotificationsLoaded) {
          emit((state as NotificationsLoaded).copyWith(isUpdating: false));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _pushSub?.cancel();
    return super.close();
  }
}
