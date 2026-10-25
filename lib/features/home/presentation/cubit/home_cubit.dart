import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/realtime/realtime_refresh_mixin.dart';
import '../../../../core/utils/vendor_access.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../../my_restaurant/domain/usecases/get_vendor_branch_usecase.dart';
import '../../../orders/domain/usecases/watch_new_vendor_orders_usecase.dart';
import '../../../prescriptions/domain/entities/prescription_request_status.dart';
import '../../../prescriptions/domain/usecases/get_vendor_prescription_requests_usecase.dart';
import '../../domain/usecases/get_home_stats_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> with RealtimeRefreshMixin<HomeState> {
  final GetHomeStatsUseCase getHomeStatsUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetVendorBranchUseCase getVendorBranchUseCase;
  final GetVendorPrescriptionRequestsUseCase
  getVendorPrescriptionRequestsUseCase;
  final WatchNewVendorOrdersUseCase watchNewVendorOrdersUseCase;

  String _selectedStatus = 'ready_for_delivery';

  HomeCubit({
    required this.getHomeStatsUseCase,
    required this.getCurrentUserUseCase,
    required this.getVendorBranchUseCase,
    required this.getVendorPrescriptionRequestsUseCase,
    required this.watchNewVendorOrdersUseCase,
  }) : super(HomeInitial()) {
    listenForRealtimeRefresh(watchNewVendorOrdersUseCase(), refreshStats);
  }

  /// Refetches `/vendor/home` stats without showing a loader; failures are
  /// ignored so the current screen stays as is.
  Future<void> refreshStats() async {
    if (isClosed || state is! HomeLoaded) return;
    try {
      final stats = await getHomeStatsUseCase();
      final current = state;
      if (isClosed || current is! HomeLoaded) return;
      emit(
        HomeLoaded(
          stats: stats,
          user: current.user,
          branch: current.branch,
          selectedStatus: current.selectedStatus,
          pendingPrescriptionCount: current.pendingPrescriptionCount,
        ),
      );
    } catch (_) {}
  }

  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    try {
      final stats = await getHomeStatsUseCase();

      final userResult = await getCurrentUserUseCase();
      final user = userResult.fold(
        (failure) => throw Exception(failure.message),
        (user) => user,
      );

      final branchResult = await getVendorBranchUseCase();
      final branch = branchResult.fold((_) => null, (branch) => branch);

      int? pendingPrescriptionCount;
      if (user.isPharmacyVendor) {
        final pendingResult = await getVendorPrescriptionRequestsUseCase(
          status: PrescriptionRequestStatus.pending,
          page: 1,
          perPage: 1,
        );
        pendingPrescriptionCount = pendingResult.fold(
          (_) => null,
          (page) => page.total,
        );
      }

      emit(
        HomeLoaded(
          stats: stats,
          user: user,
          branch: branch,
          selectedStatus: _selectedStatus,
          pendingPrescriptionCount: pendingPrescriptionCount,
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  void filterByStatus(String status) {
    _selectedStatus = status;
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(
        HomeLoaded(
          stats: currentState.stats,
          user: currentState.user,
          branch: currentState.branch,
          selectedStatus: _selectedStatus,
          pendingPrescriptionCount: currentState.pendingPrescriptionCount,
        ),
      );
    }
  }
}
