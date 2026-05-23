import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../../my_restaurant/domain/usecases/get_vendor_branch_usecase.dart';
import '../../domain/usecases/get_home_stats_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeStatsUseCase getHomeStatsUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetVendorBranchUseCase getVendorBranchUseCase;

  HomeCubit({
    required this.getHomeStatsUseCase,
    required this.getCurrentUserUseCase,
    required this.getVendorBranchUseCase,
  }) : super(HomeInitial());

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

      emit(HomeLoaded(stats: stats, user: user, branch: branch));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
