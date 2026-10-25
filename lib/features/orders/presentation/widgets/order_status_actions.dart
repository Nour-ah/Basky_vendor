import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_status.dart';

class OrderStatusActions extends StatelessWidget {
  const OrderStatusActions({
    super.key,
    required this.currentStatus,
    required this.onStatusSelected,
  });

  final OrderStatus currentStatus;
  final ValueChanged<OrderStatus> onStatusSelected;

  // Vendor stops at ready_for_pickup; shipped/delivered are delivery-app only.
  static const _allowedTransitions = {
    OrderStatus.pending: [OrderStatus.processing, OrderStatus.cancelled],
    OrderStatus.processing: [OrderStatus.readyForPickup, OrderStatus.cancelled],
  };

  @override
  Widget build(BuildContext context) {
    final nextStatuses = _allowedTransitions[currentStatus] ?? <OrderStatus>[];
    if (nextStatuses.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: nextStatuses
          .map(
            (status) => ActionChip(
              label: Text(status.toApiString().tr()),
              onPressed: () => onStatusSelected(status),
              backgroundColor: AppColors.primary.withValues(alpha: 0.08),
            ),
          )
          .toList(),
    );
  }
}
