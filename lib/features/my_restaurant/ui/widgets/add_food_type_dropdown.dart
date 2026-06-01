import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../domain/entities/product_type.dart';

class AddFoodTypeDropdown extends StatelessWidget {
  const AddFoodTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final ProductType selectedType;
  final ValueChanged<ProductType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.productType.tr(),
          style: AppTextStyle.fontBlack14Bold,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _TypeCard(
                title: LocaleKeys.productTypeSimple.tr(),
                icon: Icons.fastfood_outlined,
                isSelected: selectedType == ProductType.simple,
                onTap: () => onChanged(ProductType.simple),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _TypeCard(
                title: LocaleKeys.productTypeVariable.tr(),
                icon: Icons.dashboard_customize_outlined,
                isSelected: selectedType == ProductType.variable,
                onTap: () => onChanged(ProductType.variable),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.greyLight.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.grey,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: isSelected
                  ? AppTextStyle.fontPrimary14Regular.copyWith(fontWeight: FontWeight.bold)
                  : AppTextStyle.fontGrey14Medium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

