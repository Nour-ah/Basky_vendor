import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../network/dio_error_mapper.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../translations/locale_keys.g.dart';
import 'shimmer_skeleton.dart';

class StateViewWidget extends StatelessWidget {
  const StateViewWidget({
    super.key,
    required this.message,
    required this.icon,
    this.onRetry,
    this.actionLabel,
  });

  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(icon, size: 64, color: AppColors.primary.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 24),
            Text(
              DioErrorMapper.sanitize(message),
              style: AppTextStyle.fontBlack16Bold,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 20, color: AppColors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.promoRed,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.promoRed.withValues(alpha: 0.4),
                ),
                label: Text(
                  actionLabel ?? LocaleKeys.retry.tr(),
                  style: AppTextStyle.fontWhite14Regular.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingSkeletonList extends StatelessWidget {
  const LoadingSkeletonList({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => const ShimmerSkeleton(
        height: 88,
        shape: BoxShape.rectangle,
      ),
    );
  }
}

