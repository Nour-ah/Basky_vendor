import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../my_restaurant/domain/entities/vendor_branch_entity.dart';
import '../../domain/entities/home_stats_entity.dart';
import '../../domain/entities/recent_order_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeStatsEntity stats;
  final User user;
  final VendorBranchEntity? branch;
  final String selectedStatus;

  const HomeLoaded({
    required this.stats,
    required this.user,
    this.branch,
    required this.selectedStatus,
  });

  List<RecentOrderEntity> get filteredOrders {
    final ss = selectedStatus.toLowerCase();
    return stats.recentOrders.where((order) {
      final os = order.status.toLowerCase();
      if (ss == 'ready_for_delivery') {
        return os == 'ready_for_delivery' || os == 'ready' || os == 'ready_for_pickup';
      }
      if (ss == 'pending') {
        return os == 'pending' || os == 'confirmed';
      }
      if (ss == 'cooking') {
        return os == 'cooking' || os == 'processing' || os == 'preparing';
      }
      if (ss == 'on_the_way') {
        return os == 'on_the_way' || os == 'out_for_delivery' || os == 'shipped' || os == 'delivered';
      }
      return false;
    }).toList();
  }

  @override
  List<Object?> get props => [stats, user, branch, selectedStatus];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
