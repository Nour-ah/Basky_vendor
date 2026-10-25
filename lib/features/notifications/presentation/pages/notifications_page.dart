import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/notifications/notification_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/state_view_widget.dart';
import '../../domain/entities/app_notification.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final NotificationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<NotificationsCubit>()..loadNotifications();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              isAr ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
              color: AppColors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            LocaleKeys.notifications.tr(),
            style: AppTextStyle.fontBlack16Bold,
          ),
          actions: [
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state is! NotificationsLoaded || state.unreadCount == 0) {
                  return const SizedBox.shrink();
                }
                return TextButton(
                  onPressed: () => _cubit.markAllAsRead(),
                  child: Text(
                    LocaleKeys.notificationsMarkAllRead.tr(),
                    style: AppTextStyle.fontPrimary12Regular.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const LoadingSkeletonList(itemCount: 6);
            }
            if (state is NotificationsError) {
              return StateViewWidget(
                message: state.isNetworkError
                    ? LocaleKeys.noInternetConnection.tr()
                    : state.message,
                icon: state.isNetworkError
                    ? Icons.wifi_off
                    : Icons.error_outline,
                onRetry: () => _cubit.loadNotifications(),
              );
            }
            if (state is NotificationsEmpty) {
              return StateViewWidget(
                message: LocaleKeys.notificationsEmpty.tr(),
                icon: Icons.notifications_none,
                onRetry: () => _cubit.loadNotifications(),
              );
            }
            if (state is NotificationsLoaded) {
              return RefreshIndicator(
                onRefresh: () => _cubit.loadNotifications(),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = state.notifications[index];
                    return _NotificationTile(
                      notification: item,
                      onTap: () async {
                        if (!item.isRead) {
                          await _cubit.markAsRead(item.id);
                        }
                        await NotificationNavigation.handlePushTap({
                          ...item.data,
                          if (item.type != null) 'type': item.type,
                          'title': item.title,
                          'body': item.body,
                        });
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: notification.isRead
          ? AppColors.white
          : AppColors.primary.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title.isEmpty
                          ? LocaleKeys.notifications.tr()
                          : notification.title,
                      style: AppTextStyle.fontBlack14Bold,
                    ),
                    if (notification.body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: AppTextStyle.fontGrey12Regular,
                      ),
                    ],
                    if (notification.createdAt != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        notification.createdAt.toString(),
                        style: AppTextStyle.fontGrey12Regular.copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: AppColors.promoRed,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
