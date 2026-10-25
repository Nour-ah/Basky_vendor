import 'package:flutter_test/flutter_test.dart';
import 'package:basky_vendor/features/home/domain/entities/home_stats_entity.dart';
import 'package:basky_vendor/features/home/domain/repositories/home_repository.dart';
import 'package:basky_vendor/features/home/domain/usecases/get_home_stats_usecase.dart';

class MockHomeRepository implements HomeRepository {
  final HomeStatsEntity mockStats;
  final bool shouldThrow;

  MockHomeRepository({required this.mockStats, this.shouldThrow = false});

  @override
  Future<HomeStatsEntity> getHomeStats() async {
    if (shouldThrow) {
      throw Exception('Server Error');
    }
    return mockStats;
  }
}

void main() {
  late GetHomeStatsUseCase usecase;
  late MockHomeRepository mockRepository;

  const tHomeStats = HomeStatsEntity(
    todayOrders: 33,
    todayEarnings: 600.0,
    recentOrders: [],
    pendingOrders: 1,
    preparingOrders: 2,
    readyOrders: 3,
    deliveredOrders: 4,
  );

  setUp(() {
    mockRepository = MockHomeRepository(mockStats: tHomeStats);
    usecase = GetHomeStatsUseCase(mockRepository);
  });

  test('should get home stats from the repository', () async {
    // Act
    final result = await usecase();

    // Assert
    expect(result, tHomeStats);
  });

  test('should throw exception when repository fails', () async {
    // Arrange
    mockRepository = MockHomeRepository(
      mockStats: tHomeStats,
      shouldThrow: true,
    );
    usecase = GetHomeStatsUseCase(mockRepository);

    // Act
    final call = usecase();

    // Assert
    expect(() => call, throwsException);
  });
}
