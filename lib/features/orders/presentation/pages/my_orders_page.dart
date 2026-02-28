import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/order_card_model.dart';
import '../models/order_summary_model.dart';
import '../widgets/order_item_card.dart';
import '../widgets/orders_filter_tabs.dart';
import '../widgets/orders_statistics_card.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  String _selectedFilter = '';

  // Dummy statistics
  final OrderSummaryModel _summary = OrderSummaryModel(
    todayOrders: 30,
    thisWeekOrders: 387,
    thisMonthOrders: 1658,
  );

  @override
  Widget build(BuildContext context) {
    // Only init inside build context
    if (_selectedFilter.isEmpty) {
      _selectedFilter = AppStrings.all.tr();
    }

    final List<String> filters = [
      AppStrings.all.tr(),
      AppStrings.delivered.tr(),
      AppStrings.returned.tr(),
    ];

    // Dummy orders list with translation
    final List<OrderCardModel> dummyOrders = [
      OrderCardModel(
        orderCode: '#545555',
        status: AppStrings.delivered.tr(),
        dateTime: '15/1/2024 12:30 AM',
        orderType: AppStrings.delivery.tr(),
        itemCount: 3,
      ),
      OrderCardModel(
        orderCode: '#545555',
        status: AppStrings.delivered.tr(),
        dateTime: '15/1/2024 12:30 AM',
        orderType: AppStrings.delivery.tr(),
        itemCount: 3,
      ),
      OrderCardModel(
        orderCode: '#545555',
        status: AppStrings.delivered.tr(),
        dateTime: '15/1/2024 12:30 AM',
        orderType: AppStrings.delivery.tr(),
        itemCount: 3,
      ),
      OrderCardModel(
        orderCode: '#545555',
        status: AppStrings.returned.tr(),
        dateTime: '15/1/2024 12:30 AM',
        orderType: AppStrings.delivery.tr(),
        itemCount: 3,
      ),
      OrderCardModel(
        orderCode: '#545555',
        status: AppStrings.delivered.tr(),
        dateTime: '15/1/2024 12:30 AM',
        orderType: AppStrings.delivery.tr(),
        itemCount: 3,
      ),
    ];

    // Basic local filter implementation
    List<OrderCardModel> displayedOrders = dummyOrders;
    if (_selectedFilter != AppStrings.all.tr()) {
      displayedOrders = dummyOrders
          .where((order) => order.status == _selectedFilter)
          .toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.orders.tr(),
          style: AppTextStyle.fontBlack16Bold,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              OrdersStatisticsCard(summary: _summary),
              const SizedBox(height: 16),
              OrdersFilterTabs(
                selectedFilter: _selectedFilter,
                filters: filters,
                onFilterChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Expanded ListView for orders
              Expanded(
                child: ListView.separated(
                  itemCount: displayedOrders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return OrderItemCard(order: displayedOrders[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
