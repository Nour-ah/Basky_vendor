import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/state_view_widget.dart';
import '../cubit/order_details_cubit.dart';
import '../cubit/order_details_state.dart';
import '../widgets/order_status_actions.dart';
import '../widgets/order_status_chip.dart';
import '../widgets/order_summary_row.dart';
import '../widgets/order_items_list.dart';
import 'order_invoice_page.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<OrderDetailsCubit>()..fetchOrderDetails(orderId),
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
          title: Text(LocaleKeys.orderDetails.tr(), style: AppTextStyle.fontBlack16Bold),
          actions: [
            BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
              builder: (context, state) {
                if (state is! OrderDetailsLoaded && state is! OrderDetailsUpdating) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  icon: const Icon(Icons.receipt_long_outlined, color: AppColors.primary),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderInvoicePage(orderId: orderId),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
          listener: (context, state) {
            if (state is OrderDetailsStatusError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppColors.promoRed),
              );
            }
          },
          builder: (context, state) {
            if (state is OrderDetailsLoading) {
              return const LoadingSkeletonList(itemCount: 4);
            }
            if (state is OrderDetailsError) {
              return StateViewWidget(
                message: state.isNetworkError
                    ? LocaleKeys.noInternetConnection.tr()
                    : state.message,
                icon: state.isNetworkError ? Icons.wifi_off : Icons.error_outline,
                onRetry: () => context.read<OrderDetailsCubit>().fetchOrderDetails(orderId),
              );
            }
            if (state is OrderDetailsLoaded || state is OrderDetailsUpdating) {
              final order = state is OrderDetailsLoaded
                  ? state.order
                  : (state as OrderDetailsUpdating).order;
              final isUpdating = state is OrderDetailsUpdating;

              return RefreshIndicator(
                onRefresh: () => context.read<OrderDetailsCubit>().fetchOrderDetails(orderId),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ─── Header: Status & Code ───
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.orderCode.tr(),
                                  style: AppTextStyle.fontGrey12Regular,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '#${order.orderCode}',
                                  style: AppTextStyle.fontBlack16Bold,
                                ),
                              ],
                            ),
                            OrderStatusChip(status: order.status),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ─── Vendor Info Card ───
                      _buildInfoCard(
                        title: LocaleKeys.vendorDetails.tr(),
                        icon: Icons.storefront_outlined,
                        child: Row(
                          children: [
                            if (order.vendorImage.isNotEmpty)
                              ClipOval(
                                child: CustomImageView(
                                  imagePath: order.vendorImage,
                                  height: 48,
                                  width: 48,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.store, color: AppColors.primary),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order.vendorName, style: AppTextStyle.fontBlack14Bold),
                                  if (order.vendorPhone.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(order.vendorPhone, style: AppTextStyle.fontGrey12Regular),
                                  ],
                                  if (order.vendorAddress.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(order.vendorAddress, style: AppTextStyle.fontGrey12Regular, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ─── Branch Info Card ───
                      _buildInfoCard(
                        title: LocaleKeys.branchDetails.tr(),
                        icon: Icons.location_on_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.branchName, style: AppTextStyle.fontBlack14Bold),
                            if (order.branchPhone.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(order.branchPhone, style: AppTextStyle.fontGrey12Regular),
                            ],
                            if (order.branchAddress.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(order.branchAddress, style: AppTextStyle.fontGrey12Regular),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ─── Notes (if any) ───
                      if (order.notes != null && order.notes!.isNotEmpty) ...[
                        _buildInfoCard(
                          title: LocaleKeys.notes.tr(),
                          icon: Icons.note_alt_outlined,
                          child: Text(
                            order.notes!,
                            style: AppTextStyle.fontBlack14Regular,
                          ),
                          borderColor: AppColors.orange.withValues(alpha: 0.3),
                          bgColor: AppColors.orange.withValues(alpha: 0.05),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // ─── Items List ───
                      const SizedBox(height: 8),
                      OrderItemsList(items: order.items),
                      const SizedBox(height: 16),

                      // ─── Financial Breakdown ───
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.greyLight.withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(LocaleKeys.paymentSummary.tr(), style: AppTextStyle.fontBlack14Bold),
                            const SizedBox(height: 16),
                            OrderSummaryRow(
                              label: LocaleKeys.subtotal.tr(),
                              value: '${order.subtotal.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}',
                            ),
                            if (order.shippingCost > 0)
                              OrderSummaryRow(
                                label: LocaleKeys.deliveryFee.tr(),
                                value: '${order.shippingCost.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}',
                              ),
                            if (order.discount > 0)
                              OrderSummaryRow(
                                label: LocaleKeys.discount.tr(),
                                value: '-${order.discount.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}',
                                isDiscount: true,
                              ),
                            if (order.commission > 0)
                              OrderSummaryRow(
                                label: LocaleKeys.commission.tr(),
                                value: '${order.commission.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}',
                              ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(color: AppColors.greyLight),
                            ),
                            OrderSummaryRow(
                              label: LocaleKeys.total.tr(),
                              value: '${order.totalAmount.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}',
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // ─── Status Actions ───
                      if (isUpdating)
                        const Center(child: CircularProgressIndicator())
                      else
                        OrderStatusActions(
                          currentStatus: order.status,
                          onStatusSelected: (status) =>
                              context.read<OrderDetailsCubit>().updateStatus(status),
                        ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
    Color? borderColor,
    Color? bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? AppColors.greyLight.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.grey),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyle.fontGrey12Regular),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

