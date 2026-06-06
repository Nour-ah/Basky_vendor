import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../orders/domain/entities/order_status.dart';

class OrderCardWidget extends StatelessWidget {
  const OrderCardWidget({
    super.key,
    required this.orderCode,
    required this.date,
    required this.time,
    required this.deliveryType,
    required this.itemsCount,
    this.totalAmount,
    this.subtotal,
    this.discount,
    this.shippingCost,
    this.branchName,
    this.vendorName,
    this.vendorImage,
    this.status,
    required this.onDetailsPressed,
  });

  final String orderCode;
  final String date;
  final String time;
  final String deliveryType;
  final int itemsCount;
  final double? totalAmount;
  final double? subtotal;
  final double? discount;
  final double? shippingCost;
  final String? branchName;
  final String? vendorName;
  final String? vendorImage;
  final OrderStatus? status;
  final VoidCallback onDetailsPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyLight.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onDetailsPressed,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Header: Branch / Vendor & Status ───
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: ClipOval(
                        child: (vendorImage != null && vendorImage!.isNotEmpty)
                            ? CustomImageView(
                                imagePath: vendorImage!,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.storefront,
                                size: 22,
                                color: AppColors.primary,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (vendorName?.isNotEmpty == true)
                                ? vendorName!
                                : ((branchName?.isNotEmpty == true)
                                      ? branchName!
                                      : 'orderCode'.tr(args: [orderCode])),
                            style: AppTextStyle.fontBlack16Bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (branchName?.isNotEmpty == true &&
                                    vendorName?.isNotEmpty == true)
                                ? '$branchName  •  #$orderCode'
                                : '#$orderCode',
                            style: AppTextStyle.fontGrey12Regular,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (status != null) _buildStatusBadge(status!),
                  ],
                ),
                const SizedBox(height: 16),
                const _DashedDivider(),
                const SizedBox(height: 16),

                // ─── Row 2: Date/Time + Items Count + Delivery Type ───
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppColors.grey,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              date.isNotEmpty ? '$date $time'.trim() : '',
                              style: AppTextStyle.fontGrey12Regular,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (itemsCount > 0) ...[
                      Container(
                        width: 1,
                        height: 12,
                        color: AppColors.greyLight,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            LocaleKeys.itemsCount.tr(
                              namedArgs: {'count': itemsCount.toString()},
                            ),
                            style: AppTextStyle.fontPrimary16Regular.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // ─── Financial Breakdown ───
                if (totalAmount != null && totalAmount! > 0) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        if (subtotal != null && subtotal! > 0)
                          _buildPriceRow(LocaleKeys.subtotal.tr(), subtotal!),
                        if (shippingCost != null && shippingCost! > 0) ...[
                          const SizedBox(height: 6),
                          _buildPriceRow(
                            LocaleKeys.deliveryFee.tr(),
                            shippingCost!,
                          ),
                        ],
                        if (discount != null && discount! > 0) ...[
                          const SizedBox(height: 6),
                          _buildPriceRow(
                            LocaleKeys.discount.tr(),
                            -discount!,
                            isDiscount: true,
                          ),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(height: 1, color: AppColors.greyLight),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.total.tr(),
                              style: AppTextStyle.fontBlack14Bold,
                            ),
                            Text(
                              '${totalAmount!.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}',
                              style: AppTextStyle.fontPrimary16Bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.fontGrey12Regular),
        Text(
          '${amount > 0 ? '' : ''}${amount.toStringAsFixed(2)} ${LocaleKeys.currency.tr()}',
          style: AppTextStyle.fontBlack12Bold.copyWith(
            color: isDiscount ? AppColors.promoRed : AppColors.black,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    final (Color bgColor, Color textColor) = _statusColors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toApiString().tr(),
        style: AppTextStyle.fontRed14Bold.copyWith(
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }

  (Color, Color) _statusColors(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return (AppColors.orange.withValues(alpha: 0.15), AppColors.orange);
      case OrderStatus.processing:
      case OrderStatus.readyForPickup:
      case OrderStatus.readyForDelivery:
        return (AppColors.blue.withValues(alpha: 0.15), AppColors.blue);
      case OrderStatus.shipped:
      case OrderStatus.outForDelivery:
        return (AppColors.purple.withValues(alpha: 0.15), AppColors.purple);
      case OrderStatus.delivered:
        return (AppColors.green.withValues(alpha: 0.15), AppColors.green);
      case OrderStatus.cancelled:
      case OrderStatus.returned:
      case OrderStatus.refunded:
        return (AppColors.red.withValues(alpha: 0.15), AppColors.red);
      case OrderStatus.unknown:
        return (AppColors.grey.withValues(alpha: 0.15), AppColors.grey);
    }
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: AppColors.greyLight),
              ),
            );
          }),
        );
      },
    );
  }
}
