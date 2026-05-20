import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OrdersFilterTabs extends StatelessWidget {
  const OrdersFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.filters,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final List<String> filters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          return Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsetsDirectional.only(
                  end: filter != filters.last ? 8.0 : 0.0,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.red : AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? AppColors.red : AppColors.border,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  filter.tr(),
                  style: isSelected
                      ? AppTextStyle.fontWhite14Regular.copyWith(
                          fontWeight: FontWeight.bold,
                        )
                      : AppTextStyle.fontGrey14Regular.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
