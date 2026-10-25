import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../domain/entities/prescription_request_status.dart';
import '../../domain/entities/vendor_prescription_request.dart';
import 'prescription_image_preview.dart';
import 'prescription_status_badge.dart';

class PrescriptionRequestCard extends StatelessWidget {
  const PrescriptionRequestCard({
    super.key,
    required this.request,
    required this.onAction,
  });

  final VendorPrescriptionRequest request;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${LocaleKeys.prescriptionRequestNumber.tr()} #${request.id}',
                  style: AppTextStyle.fontBlack14Bold,
                ),
              ),
              PrescriptionStatusBadge(status: request.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrescriptionThumbnail(imageUrl: request.image),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (request.createdAt != null &&
                        request.createdAt!.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              request.createdAt!,
                              style: AppTextStyle.fontGrey12Regular,
                            ),
                          ),
                        ],
                      ),
                    if (request.address?.address.isNotEmpty == true) ...[
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              request.address!.address,
                              style: AppTextStyle.fontGrey12Regular,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (request.notes != null && request.notes!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        request.notes!,
                        style: AppTextStyle.fontGrey12Regular,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (_shouldShowTotal(request)) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${LocaleKeys.total.tr()}: ${request.quotedTotal} ${LocaleKeys.currency.tr()}',
                        style: AppTextStyle.fontPrimary12Regular.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _actionLabel(request.status),
                style: AppTextStyle.fontWhite14Regular.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowTotal(VendorPrescriptionRequest request) {
    return (request.status == PrescriptionRequestStatus.quoted ||
            request.status == PrescriptionRequestStatus.converted) &&
        request.quotedTotal != null;
  }

  String _actionLabel(PrescriptionRequestStatus status) {
    switch (status) {
      case PrescriptionRequestStatus.pending:
        return LocaleKeys.prescriptionReview.tr();
      case PrescriptionRequestStatus.quoted:
        return LocaleKeys.prescriptionViewSentQuote.tr();
      case PrescriptionRequestStatus.converted:
        return LocaleKeys.prescriptionViewOrder.tr();
      case PrescriptionRequestStatus.userRejected:
      case PrescriptionRequestStatus.cancelled:
      case PrescriptionRequestStatus.all:
        return LocaleKeys.prescriptionViewDetails.tr();
    }
  }
}
