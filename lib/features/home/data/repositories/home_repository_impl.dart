import '../../domain/entities/home_stats_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HomeStatsEntity> getHomeStats() async {
    try {
      final remoteStats = await remoteDataSource.getHomeStats();
      return remoteStats;
    } catch (e) {
      rethrow;
    }
  }
}
