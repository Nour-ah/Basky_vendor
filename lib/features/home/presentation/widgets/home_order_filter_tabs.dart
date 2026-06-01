import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../orders/domain/entities/order_status.dart';

class HomeOrderFilterTabs extends StatelessWidget {
  final OrderStatus selected;
  final ValueChanged<OrderStatus> onSelected;

  const HomeOrderFilterTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  // The tab statuses shown in Home screen (as requested by backend)
  static const List<OrderStatus> _statuses = [
    OrderStatus.processing,
    OrderStatus.readyForPickup,
    OrderStatus.shipped,
    OrderStatus.delivered,
    OrderStatus.cancelled,
  ];

  String _label(BuildContext context, OrderStatus status) {
    switch (status) {
      case OrderStatus.unknown:
        return 'all'.tr();
      case OrderStatus.pending:
        return 'pending'.tr();
      case OrderStatus.processing:
        return 'processing'.tr();
      case OrderStatus.readyForPickup:
        return 'ready_for_pickup'.tr();
      case OrderStatus.shipped:
        return 'shipped'.tr();
      case OrderStatus.delivered:
        return 'delivered'.tr();
      case OrderStatus.cancelled:
        return 'cancelled'.tr();
      case OrderStatus.refunded:
        return 'refunded'.tr();
      default:
        return status.toApiString();
    }
  }

  Color _color(OrderStatus status, bool isSelected) {
    if (!isSelected) return AppColors.white;
    switch (status) {
      case OrderStatus.cancelled:
        return AppColors.promoRed;
      case OrderStatus.delivered:
        return AppColors.green;
      case OrderStatus.pending:
        return const Color(0xFFF59E0B);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _statuses.length,
        itemBuilder: (context, index) {
          final status = _statuses[index];
          final isSelected = selected == status;
          final activeColor = _color(status, true);

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () => onSelected(status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : AppColors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected ? activeColor : AppColors.greyLight,
                    width: isSelected ? 0 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.grey,
                  ),
                  child: Text(_label(context, status)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Mini stats row showing today/week/month from the API response
class HomeOrdersStatsRow extends StatelessWidget {
  final int today;
  final int week;
  final int month;

  const HomeOrdersStatsRow({
    super.key,
    required this.today,
    required this.week,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _MiniStatChip(label: 'today'.tr(), count: today, color: AppColors.primary),
          const SizedBox(width: 10),
          _MiniStatChip(label: 'thisWeek'.tr(), count: week, color: const Color(0xFF8B5CF6)),
          const SizedBox(width: 10),
          _MiniStatChip(label: 'thisMonth'.tr(), count: month, color: const Color(0xFFF59E0B)),
        ],
      ),
    );
  }
}

class _MiniStatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _MiniStatChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$count',
              style: AppTextStyle.fontBlack16Bold.copyWith(color: color, fontSize: 18),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyle.fontGrey12Regular.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
