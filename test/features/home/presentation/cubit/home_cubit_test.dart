import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/features/home/domain/entities/home_stats_entity.dart';
import 'package:spider_restaurant/features/home/domain/repositories/home_repository.dart';
import 'package:spider_restaurant/features/home/domain/usecases/get_home_stats_usecase.dart';
import 'package:spider_restaurant/features/home/presentation/cubit/home_cubit.dart';
import 'package:spider_restaurant/features/home/presentation/cubit/home_state.dart';

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
  late HomeCubit cubit;
  late MockHomeRepository mockRepository;
  late GetHomeStatsUseCase usecase;

  const tHomeStats = HomeStatsEntity(
    totalOrders: 33,
    totalEarnings: 600.0,
    recentOrders: [],
  );

  setUp(() {
    mockRepository = MockHomeRepository(mockStats: tHomeStats);
    usecase = GetHomeStatsUseCase(mockRepository);
    cubit = HomeCubit(getHomeStatsUseCase: usecase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be HomeInitial', () {
    expect(cubit.state, equals(HomeInitial()));
  });

  test('should emit [HomeLoading, HomeLoaded] when data is gotten successfully', () async {
    // Assert later
    final expected = [
      HomeLoading(),
      const HomeLoaded(stats: tHomeStats),
    ];
    
    expectLater(cubit.stream, emitsInOrder(expected));

    // Act
    await cubit.fetchHomeStats();
  });

  test('should emit [HomeLoading, HomeError] when getting data fails', () async {
    // Arrange
    mockRepository = MockHomeRepository(mockStats: tHomeStats, shouldThrow: true);
    usecase = GetHomeStatsUseCase(mockRepository);
    cubit = HomeCubit(getHomeStatsUseCase: usecase);

    // Assert later
    final expected = [
      HomeLoading(),
      const HomeError(message: 'Exception: Server Error'),
    ];
    
    expectLater(cubit.stream, emitsInOrder(expected));

    // Act
    await cubit.fetchHomeStats();
  });
}
