import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../domain/entities/variant_entity.dart';

class VariantsSelectorWidget extends StatelessWidget {
  const VariantsSelectorWidget({
    super.key,
    required this.variants,
    required this.selectedOptionsByVariant,
    required this.onSelectionChanged,
    required this.onManageVariants,
  });

  final List<VariantEntity> variants;
  final Map<int, List<int>> selectedOptionsByVariant;
  final ValueChanged<Map<int, List<int>>> onSelectionChanged;
  final VoidCallback onManageVariants;

  void _toggleVariant(int variantId, bool? checked) {
    final next = Map<int, List<int>>.from(selectedOptionsByVariant);
    if (checked == true) {
      next.putIfAbsent(variantId, () => []);
    } else {
      next.remove(variantId);
    }
    onSelectionChanged(next);
  }

  void _toggleOption(int variantId, int optionId) {
    final next = Map<int, List<int>>.from(selectedOptionsByVariant);
    final options = List<int>.from(next[variantId] ?? []);
    if (options.contains(optionId)) {
      options.remove(optionId);
    } else {
      options.add(optionId);
    }
    next[variantId] = options;
    onSelectionChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LocaleKeys.attachVariants.tr(), style: AppTextStyle.fontBlack14Bold),
            TextButton.icon(
              icon: const Icon(
                Icons.settings,
                size: 16,
                color: AppColors.primary,
              ),
              label: Text(
                LocaleKeys.manageVariants.tr(),
                style: AppTextStyle.fontPrimary12Regular,
              ),
              onPressed: onManageVariants,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (variants.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              LocaleKeys.noVariantsAvailable.tr(),
              style: AppTextStyle.fontGrey14Regular,
            ),
          ),
        ...variants.map((variant) {
          final isSelected = selectedOptionsByVariant.containsKey(variant.id);
          final selectedOptionIds = selectedOptionsByVariant[variant.id] ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  variant.name,
                  style: AppTextStyle.fontBlack14Regular,
                ),
                value: isSelected,
                activeColor: AppColors.primary,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (checked) => _toggleVariant(variant.id, checked),
              ),
              if (isSelected) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 6),
                  child: Text(
                    LocaleKeys.selectVariantOptions.tr(),
                    style: AppTextStyle.fontGrey12Regular,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: variant.options.map((opt) {
                      final selected = selectedOptionIds.contains(opt.id);
                      return FilterChip(
                        label: Text(
                          opt.name,
                          style: TextStyle(
                            fontSize: 13,
                            color: selected ? AppColors.white : AppColors.black,
                          ),
                        ),
                        selected: selected,
                        showCheckmark: true,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.lightGrey,
                        side: BorderSide(
                          color: selected ? AppColors.primary : AppColors.border,
                        ),
                        onSelected: (_) => _toggleOption(variant.id, opt.id),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          );
        }),
      ],
    );
  }
}
