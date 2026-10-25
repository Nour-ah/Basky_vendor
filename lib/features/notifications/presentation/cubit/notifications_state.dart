import 'package:equatable/equatable.dart';

import '../../domain/entities/app_notification.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<AppNotification> notifications;
  final bool isUpdating;

  const NotificationsLoaded({
    required this.notifications,
    this.isUpdating = false,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationsLoaded copyWith({
    List<AppNotification>? notifications,
    bool? isUpdating,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [notifications, isUpdating];
}

class NotificationsEmpty extends NotificationsState {}

class NotificationsError extends NotificationsState {
  final String message;
  final bool isNetworkError;

  const NotificationsError(this.message, {this.isNetworkError = false});

  @override
  List<Object?> get props => [message, isNetworkError];
}
