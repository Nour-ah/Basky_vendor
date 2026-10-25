import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/app_skeleton_loading.dart';
import '../../domain/entities/order_status.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../pages/order_details_page.dart';
import '../widgets/order_item_card.dart';
import '../widgets/orders_filter_tabs.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  late final OrdersCubit _ordersCubit;
  final ScrollController _scrollController = ScrollController();
  OrderStatus _selectedFilter = OrderStatus.unknown;

  @override
  void initState() {
    super.initState();
    _ordersCubit = sl<OrdersCubit>()..fetchOrders(filter: _selectedFilter);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _ordersCubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _ordersCubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider.value(
      value: _ordersCubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              isAr ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
              color: AppColors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(LocaleKeys.orders.tr(), style: AppTextStyle.fontBlack16Bold),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              OrdersFilterTabs(
                selectedFilter: _selectedFilter.toApiString(),
                filters: [
                  OrderStatus.unknown.toApiString(),
                  OrderStatus.delivered.toApiString(),
                  OrderStatus.refunded.toApiString(),
                ],
                onFilterChanged: (filter) {
                  setState(() => _selectedFilter = OrderStatus.fromString(filter));
                  _ordersCubit.fetchOrders(filter: _selectedFilter, isRefresh: true);
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocConsumer<OrdersCubit, OrdersState>(
                  listener: (context, state) {
                    if (state is OrderStatusUpdateError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: AppColors.promoRed),
                      );
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is OrdersLoaded ||
                      current is OrdersLoading ||
                      current is OrdersEmpty ||
                      current is OrdersNetworkError ||
                      current is OrdersGenericError,
                  builder: (context, state) {
                    if (state is OrdersLoading) {
                      return const OrdersListSkeleton();
                    } else if (state is OrdersNetworkError) {
                      return _buildErrorState(
                        context,
                        LocaleKeys.noInternetConnection.tr(),
                        Icons.wifi_off,
                      );
                    } else if (state is OrdersGenericError) {
                      return _buildErrorState(context, state.message, Icons.error_outline);
                    } else if (state is OrdersEmpty) {
                      return _buildErrorState(
                        context,
                        LocaleKeys.noOrdersFound.tr(),
                        Icons.inbox,
                      );
                    } else if (state is OrdersLoaded) {
                      return RefreshIndicator(
                        onRefresh: () => _ordersCubit.fetchOrders(filter: state.filter, isRefresh: true),
                        child: ListView.separated(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.orders.length + (state.hasReachedMax ? 0 : 1),
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            if (index >= state.orders.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return OrderItemCard(
                              order: state.orders[index],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderDetailsPage(
                                    orderId: state.orders[index].id,
                                  ),
                                ),
                              ).then((_) => _ordersCubit.refreshSilently()),
                              onStatusChange: (newStatus) {
                                _ordersCubit.updateOrderStatus(state.orders[index].id, newStatus);
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.grey),
          const SizedBox(height: 16),
          Text(message, style: AppTextStyle.fontBlack14Regular, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _ordersCubit.fetchOrders(filter: _selectedFilter, isRefresh: true),
            child: Text(LocaleKeys.retry.tr()),
          ),
        ],
      ),
    );
  }
}
