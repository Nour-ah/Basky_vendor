import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home_stats_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeStatsUseCase getHomeStatsUseCase;

  HomeCubit({required this.getHomeStatsUseCase}) : super(HomeInitial());

  Future<void> fetchHomeStats() async {
    emit(HomeLoading());
    try {
      final stats = await getHomeStatsUseCase();
      emit(HomeLoaded(stats: stats));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
