import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_notification.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository repository;
  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<AppNotification>>> call() {
    return repository.getNotifications();
  }
}
