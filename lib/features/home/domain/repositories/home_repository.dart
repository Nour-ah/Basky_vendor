import '../entities/home_stats_entity.dart';

abstract class HomeRepository {
  Future<HomeStatsEntity> getHomeStats();
}
