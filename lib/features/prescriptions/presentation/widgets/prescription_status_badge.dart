import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/prescription_request_status.dart';
import '../utils/prescription_status_labels.dart';

class PrescriptionStatusBadge extends StatelessWidget {
  const PrescriptionStatusBadge({super.key, required this.status});

  final PrescriptionRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.label,
        style: AppTextStyle.fontBlack14Regular.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color _colorFor(PrescriptionRequestStatus status) {
    switch (status) {
      case PrescriptionRequestStatus.pending:
        return AppColors.primary;
      case PrescriptionRequestStatus.quoted:
        return AppColors.textSecondary;
      case PrescriptionRequestStatus.converted:
        return AppColors.success;
      case PrescriptionRequestStatus.userRejected:
      case PrescriptionRequestStatus.cancelled:
        return AppColors.promoRed;
      case PrescriptionRequestStatus.all:
        return AppColors.grey;
    }
  }
}
