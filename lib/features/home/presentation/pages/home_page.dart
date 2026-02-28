import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/fade_in_slide.dart';
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

  // Dummy State for Tabs
  int selectedTabIndex = 0;
  final List<String> orderTabs = [
    'Ready For Delivery',
    'Confirmed (1)',
    'Cooking (1)',
    'On The Way (5)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(scaffoldKey: _scaffoldKey),
      drawer: const HomeDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const FadeInSlide(delay: 100, child: RestaurantStatusSwitch()),
                const SizedBox(height: 16),
                const FadeInSlide(
                  delay: 200,
                  child: StatisticsCards(totalOrders: 33, totalEarnings: 600.0),
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Apply a staggered delay based on the index
                return FadeInSlide(
                  delay: 400 + (index * 100), // Staggering effect
                  child: OrderCardWidget(
                    orderCode: '545555',
                    date: '15/1/2024',
                    time: '12:30 AM',
                    deliveryType: 'Delivery',
                    itemsCount: 3,
                    onDetailsPressed: () {
                      // Navigate to details
                    },
                  ),
                );
              },
              childCount: 10, // Simulated list count
            ),
          ),
        ],
      ),
    );
  }
}
