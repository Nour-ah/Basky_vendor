import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/utils/static_map_helper.dart';

class BranchLocationPreview extends StatelessWidget {
  const BranchLocationPreview({
    super.key,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.onTap,
  });

  final String address;
  final double latitude;
  final double longitude;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final mapUrl = StaticMapHelper.previewUrl(
      latitude: latitude,
      longitude: longitude,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 140,
                child: CachedNetworkImage(
                  imageUrl: mapUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (_, _, _) => Container(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    child: const Icon(
                      Icons.map_outlined,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address,
                      style: AppTextStyle.fontBlack14Bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    LocaleKeys.change.tr(),
                    style: AppTextStyle.fontPrimary14Regular,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
