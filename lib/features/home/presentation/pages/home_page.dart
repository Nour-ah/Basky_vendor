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
import '../widgets/home_app_bar.dart';
import '../widgets/home_drawer.dart';
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
  late HomeCubit _homeCubit;

  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _homeCubit = sl<HomeCubit>()..fetchHomeStats();
  }

  @override
  void dispose() {
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderTabs = [
      LocaleKeys.readyForDelivery.tr(),
      LocaleKeys.confirmedCount.tr(namedArgs: {'count': '1'}),
      LocaleKeys.cookingCount.tr(namedArgs: {'count': '1'}),
      LocaleKeys.onTheWayCount.tr(namedArgs: {'count': '5'}),
    ];

    return BlocProvider.value(
      value: _homeCubit,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        appBar: HomeAppBar(scaffoldKey: _scaffoldKey),
        drawer: const HomeDrawer(),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return Center(
                child: Text(
                  '${LocaleKeys.unknown.tr()}: ${state.message}',
                  style: AppTextStyle.fontPrimary14Regular,
                ),
              );
            } else if (state is HomeLoaded) {
              final stats = state.stats;
              final recentOrders = stats.recentOrders;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const FadeInSlide(
                          delay: 100,
                          child: RestaurantStatusSwitch(),
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
                                  time: '', // Parse time from dateTime if needed
                                  deliveryType: order.orderType,
                                  itemsCount: order.itemCount,
                                  onDetailsPressed: () {
                                    // Navigate to details
                                  },
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
          },
        ),
      ),
    );
  }
}
