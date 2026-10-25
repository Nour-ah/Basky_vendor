import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../models/prescription_list_filter.dart';

class PrescriptionFilterTabs extends StatelessWidget {
  const PrescriptionFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final PrescriptionListFilter selected;
  final ValueChanged<PrescriptionListFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final filters = PrescriptionListFilter.values;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selected;
          return GestureDetector(
            onTap: () => onChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.red : AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? AppColors.red : AppColors.border,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _label(filter),
                style: isSelected
                    ? AppTextStyle.fontWhite14Regular.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                    : AppTextStyle.fontGrey14Regular.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _label(PrescriptionListFilter filter) {
    switch (filter) {
      case PrescriptionListFilter.all:
        return LocaleKeys.prescriptionTabAll.tr();
      case PrescriptionListFilter.pending:
        return LocaleKeys.prescriptionTabNew.tr();
      case PrescriptionListFilter.quoted:
        return LocaleKeys.prescriptionTabWaiting.tr();
      case PrescriptionListFilter.converted:
        return LocaleKeys.prescriptionTabAccepted.tr();
      case PrescriptionListFilter.closed:
        return LocaleKeys.prescriptionTabClosed.tr();
    }
  }
}
