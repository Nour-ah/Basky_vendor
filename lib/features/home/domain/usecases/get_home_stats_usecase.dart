import '../entities/home_stats_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeStatsUseCase {
  final HomeRepository repository;

  GetHomeStatsUseCase(this.repository);

  Future<HomeStatsEntity> call() async {
    return await repository.getHomeStats();
  }
}
