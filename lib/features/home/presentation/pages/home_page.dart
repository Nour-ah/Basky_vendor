import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_in_slide.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../cubit/toggle_status_cubit.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_drawer.dart';
import '../../../orders/presentation/pages/order_details_page.dart';
import '../widgets/order_card_widget.dart';
import '../widgets/order_status_tabs.dart';
import '../widgets/restaurant_status_switch.dart';
import '../widgets/statistics_cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final orderTabs = [
      LocaleKeys.readyForDelivery.tr(),
      LocaleKeys.confirmedCount.tr(namedArgs: {'count': '1'}),
      LocaleKeys.cookingCount.tr(namedArgs: {'count': '1'}),
      LocaleKeys.onTheWayCount.tr(namedArgs: {'count': '5'}),
    ];

    return BlocProvider(
      create: (_) => sl<HomeCubit>()..fetchHomeData(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.background,
            appBar: _buildAppBar(state),
            drawer: _buildDrawer(state),
            body: _buildBody(context, state, orderTabs),
          );
        },
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(HomeState state) {
    if (state is HomeLoaded) {
      return HomeAppBar(
        scaffoldKey: _scaffoldKey,
        userName: state.user.name,
        userAddress: state.branch?.address ?? '',
        userImageUrl: state.user.image,
      );
    }
    return HomeAppBar(
      scaffoldKey: _scaffoldKey,
      userName: '',
      userAddress: '',
    );
  }

  Widget? _buildDrawer(HomeState state) {
    if (state is! HomeLoaded) return null;

    final rating = state.branch?.rating ?? 0.0;
    final image = state.user.image ?? state.branch?.logoUrl ?? '';

    return HomeDrawer(
      userName: state.user.name,
      userRating: rating,
      userImage: image,
    );
  }

  Widget _buildBody(
    BuildContext context,
    HomeState state,
    List<String> orderTabs,
  ) {
    if (state is HomeLoading || state is HomeInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is HomeError) {
      return Center(
        child: Text(
          '${LocaleKeys.unknown.tr()}: ${state.message}',
          style: AppTextStyle.fontPrimary14Regular,
        ),
      );
    }
    if (state is HomeLoaded) {
      final stats = state.stats;
      final recentOrders = stats.recentOrders;

      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                FadeInSlide(
                  delay: 100,
                  child: BlocProvider(
                    create: (_) => sl<ToggleStatusCubit>(),
                    child: RestaurantStatusSwitch(
                      initialIsOpen: state.branch?.isOpen ?? false,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInSlide(
                  delay: 200,
                  child: StatisticsCards(
                    totalOrders: stats.totalOrders,
                    totalEarnings: stats.totalEarnings,
                  ),
                ),
                const SizedBox(height: 24),
                FadeInSlide(
                  delay: 300,
                  child: OrderStatusTabs(
                    tabs: orderTabs,
                    selectedIndex: selectedTabIndex,
                    onTabSelected: (index) {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          recentOrders.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        LocaleKeys.noRecentOrders.tr(),
                        style: AppTextStyle.fontBlack14Regular,
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final order = recentOrders[index];
                      return FadeInSlide(
                        delay: 400 + (index * 50),
                        child: OrderCardWidget(
                          orderCode: order.orderCode,
                          date: order.dateTime,
                          time: '',
                          deliveryType: order.orderType,
                          itemsCount: order.itemCount,
                          onDetailsPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetailsPage(orderId: order.id),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: recentOrders.length,
                  ),
                ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
