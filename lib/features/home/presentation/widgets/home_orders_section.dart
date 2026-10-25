import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_skeleton_loading.dart';
import '../../../orders/domain/entities/order_status.dart';
import '../../../orders/presentation/pages/order_details_page.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_orders_cubit.dart';
import '../cubit/home_orders_state.dart';
import 'home_order_filter_tabs.dart';
import 'order_card_widget.dart';

/// The full Orders section in the Home screen:
/// Filter tabs + Stats row + Orders list + Pull-to-refresh
class HomeOrdersSection extends StatefulWidget {
  const HomeOrdersSection({super.key});

  @override
  State<HomeOrdersSection> createState() => _HomeOrdersSectionState();
}

class _HomeOrdersSectionState extends State<HomeOrdersSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    if (current >= maxScroll - 200) {
      context.read<HomeOrdersCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeOrdersCubit, HomeOrdersState>(
      builder: (context, state) {
        final cubit = context.read<HomeOrdersCubit>();
        final selectedStatus = state is HomeOrdersLoaded
            ? state.selectedStatus
            : OrderStatus.unknown;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Filter Tabs ──────────────────────────────────────────
            HomeOrderFilterTabs(
              selected: selectedStatus,
              onSelected: (status) => cubit.changeFilter(status),
            ),
            const SizedBox(height: 12),

            // ─── Stats Row ────────────────────────────────────────────
            if (state is HomeOrdersLoaded) ...[
              HomeOrdersStatsRow(
                today: state.result.stats.todayOrdersCount,
                week: state.result.stats.thisWeekOrdersCount,
                month: state.result.stats.thisMonthOrdersCount,
              ),
              const SizedBox(height: 16),
            ] else if (state is HomeOrdersLoading) ...[
              const _HomeOrdersStatsSkeleton(),
              const SizedBox(height: 16),
            ],

            // ─── Orders List ──────────────────────────────────────────
            _buildOrdersList(context, state, cubit),
          ],
        );
      },
    );
  }

  Widget _buildOrdersList(
    BuildContext context,
    HomeOrdersState state,
    HomeOrdersCubit cubit,
  ) {
    if (state is HomeOrdersLoading) {
      return OrdersListSkeleton(count: state.isTabSwitch ? 3 : 4);
    }

    if (state is HomeOrdersError) {
      return _ErrorView(
        message: state.message,
        onRetry: () => cubit.fetchOrders(),
      );
    }

    if (state is HomeOrdersLoaded) {
      final orders = state.orders;

      if (orders.isEmpty) {
        return _EmptyView(onRefresh: () => cubit.fetchOrders(isRefresh: true));
      }

      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => cubit.fetchOrders(isRefresh: true),
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == orders.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final order = orders[index];
            return OrderCardWidget(
              orderCode: order.orderCode.isNotEmpty
                  ? order.orderCode
                  : '#${order.id}',
              date: order.dateTime,
              time: '',
              deliveryType: order.orderType,
              itemsCount: order.itemCount,
              totalAmount: order.totalAmount,
              subtotal: order.subtotal,
              discount: order.discount,
              shippingCost: order.shippingCost,
              branchName: order.branchName,
              vendorName: order.vendorName,
              vendorImage: order.vendorImage,
              status: order.status,
              onDetailsPressed: () => _openDetails(context, order.id),
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Status may change inside details, so the list and stats resync on return.
  Future<void> _openDetails(BuildContext context, int orderId) async {
    final ordersCubit = context.read<HomeOrdersCubit>();
    final homeCubit = context.read<HomeCubit>();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderDetailsPage(orderId: orderId)),
    );
    await Future.wait([
      ordersCubit.fetchOrders(silent: true),
      homeCubit.refreshStats(),
    ]);
  }
}

class _EmptyView extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyView({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.grey.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text('noRecentOrders'.tr(), style: AppTextStyle.fontBlack14Regular),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh, color: AppColors.primary),
              label: Text(
                'retry'.tr(),
                style: AppTextStyle.fontPrimary14Regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.promoRed.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyle.fontGrey14Regular,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text('retry'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeOrdersStatsSkeleton extends StatelessWidget {
  const _HomeOrdersStatsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: const [
            Expanded(child: Bone.button(height: 32)),
            SizedBox(width: 12),
            Expanded(child: Bone.button(height: 32)),
            SizedBox(width: 12),
            Expanded(child: Bone.button(height: 32)),
          ],
        ),
      ),
    );
  }
}

/// Wrapper that provides HomeOrdersCubit to HomeOrdersSection
class HomeOrdersSectionProvider extends StatelessWidget {
  const HomeOrdersSectionProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeOrdersCubit>()..fetchOrders(),
      child: const _HomeOrdersSectionWithRefresh(),
    );
  }
}

class _HomeOrdersSectionWithRefresh extends StatelessWidget {
  const _HomeOrdersSectionWithRefresh();

  @override
  Widget build(BuildContext context) {
    return const HomeOrdersSection();
  }
}
