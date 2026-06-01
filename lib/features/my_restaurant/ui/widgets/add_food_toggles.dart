import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/translations/locale_keys.g.dart';

class AddFoodToggles extends StatelessWidget {
  const AddFoodToggles({
    super.key,
    required this.isFeatured,
    required this.isNew,
    required this.isBookable,
    required this.onFeaturedChanged,
    required this.onNewChanged,
    required this.onBookableChanged,
  });

  final bool isFeatured;
  final bool isNew;
  final bool isBookable;
  final ValueChanged<bool> onFeaturedChanged;
  final ValueChanged<bool> onNewChanged;
  final ValueChanged<bool> onBookableChanged;

  Widget _buildToggleRow(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.white,
            activeTrackColor: AppColors.success,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.greyLight,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToggleRow(LocaleKeys.featuredProduct.tr(), isFeatured, onFeaturedChanged),
        _buildToggleRow(LocaleKeys.newProduct.tr(), isNew, onNewChanged),
        _buildToggleRow(LocaleKeys.bookableProduct.tr(), isBookable, onBookableChanged),
      ],
    );
  }
}
