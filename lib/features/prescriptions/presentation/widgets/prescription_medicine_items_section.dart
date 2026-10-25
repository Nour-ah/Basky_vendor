import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../domain/entities/prescription_medicine_item.dart';
import '../../domain/entities/vendor_prescription_request.dart';

class PrescriptionMedicineItemsSection extends StatelessWidget {
  const PrescriptionMedicineItemsSection({
    super.key,
    required this.request,
  });

  final VendorPrescriptionRequest request;

  @override
  Widget build(BuildContext context) {
    if (request.items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (request.availableItems.isNotEmpty) ...[
          Text(
            LocaleKeys.prescriptionAvailableMedicines.tr(),
            style: AppTextStyle.fontBlack16Bold,
          ),
          const SizedBox(height: 8),
          ...request.availableItems.map((item) => _AvailableItemCard(item)),
          const SizedBox(height: 16),
        ],
        if (request.unavailableItems.isNotEmpty) ...[
          Text(
            LocaleKeys.prescriptionUnavailableMedicines.tr(),
            style: AppTextStyle.fontBlack16Bold,
          ),
          const SizedBox(height: 8),
          ...request.unavailableItems.map((item) => _UnavailableItemCard(item)),
        ],
      ],
    );
  }
}

class _AvailableItemCard extends StatelessWidget {
  const _AvailableItemCard(this.item);

  final PrescriptionMedicineItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(item.medicineName, style: AppTextStyle.fontBlack14Bold),
              ),
              _MiniBadge(
                label: LocaleKeys.prescriptionAvailable.tr(),
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${LocaleKeys.quantity.tr()}: ${item.quantity}',
            style: AppTextStyle.fontGrey12Regular,
          ),
          Text(
            '${LocaleKeys.prescriptionUnitPrice.tr()}: ${item.price ?? 0} ${LocaleKeys.currency.tr()}',
            style: AppTextStyle.fontGrey12Regular,
          ),
          Text(
            '${LocaleKeys.prescriptionLineTotal.tr()}: ${item.lineTotal} ${LocaleKeys.currency.tr()}',
            style: AppTextStyle.fontPrimary12Regular.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (item.notes != null && item.notes!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(item.notes!, style: AppTextStyle.fontGrey12Regular),
          ],
        ],
      ),
    );
  }
}

class _UnavailableItemCard extends StatelessWidget {
  const _UnavailableItemCard(this.item);

  final PrescriptionMedicineItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(item.medicineName, style: AppTextStyle.fontBlack14Bold),
              ),
              _MiniBadge(
                label: LocaleKeys.prescriptionUnavailable.tr(),
                color: AppColors.promoRed,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${LocaleKeys.quantity.tr()}: ${item.quantity}',
            style: AppTextStyle.fontGrey12Regular,
          ),
          if (item.notes != null && item.notes!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(item.notes!, style: AppTextStyle.fontGrey12Regular),
          ],
        ],
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyle.fontGrey12Regular.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class PrescriptionTotalsSection extends StatelessWidget {
  const PrescriptionTotalsSection({
    super.key,
    required this.request,
    this.estimatedSubtotal,
  });

  final VendorPrescriptionRequest request;
  final num? estimatedSubtotal;

  @override
  Widget build(BuildContext context) {
    final hasOfficial = request.quotedSubtotal != null ||
        request.quotedShipping != null ||
        request.quotedTotal != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (estimatedSubtotal != null) ...[
            _row(
              LocaleKeys.prescriptionMedicinesSubtotal.tr(),
              '$estimatedSubtotal ${LocaleKeys.currency.tr()}',
            ),
            Text(
              LocaleKeys.prescriptionEstimatedSubtotalHint.tr(),
              style: AppTextStyle.fontGrey12Regular,
            ),
            if (hasOfficial) const Divider(height: 24),
          ],
          if (request.quotedSubtotal != null)
            _row(
              LocaleKeys.prescriptionQuotedSubtotal.tr(),
              '${request.quotedSubtotal} ${LocaleKeys.currency.tr()}',
            ),
          if (request.quotedShipping != null)
            _row(
              LocaleKeys.prescriptionQuotedShipping.tr(),
              '${request.quotedShipping} ${LocaleKeys.currency.tr()}',
            ),
          if (request.quotedTotal != null)
            _row(
              LocaleKeys.prescriptionQuotedTotal.tr(),
              '${request.quotedTotal} ${LocaleKeys.currency.tr()}',
              isBold: true,
            ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? AppTextStyle.fontBlack14Bold
                : AppTextStyle.fontGrey14Regular,
          ),
          Text(
            value,
            style: isBold
                ? AppTextStyle.fontBlack14Bold
                : AppTextStyle.fontBlack14Regular,
          ),
        ],
      ),
    );
  }
}
