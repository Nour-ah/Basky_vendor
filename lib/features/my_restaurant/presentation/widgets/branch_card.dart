import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/safe_network_image.dart';
import '../../domain/entities/vendor_branch_entity.dart';

class BranchCard extends StatelessWidget {
  final VendorBranchEntity branch;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BranchCard({
    super.key,
    required this.branch,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openMap(String lat, String lng) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  bool get _hasLocation =>
      branch.latitude != null &&
      branch.longitude != null &&
      branch.latitude!.isNotEmpty &&
      branch.longitude!.isNotEmpty;

  bool get _hasPhone => branch.phone != null && branch.phone!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SafeNetworkImage(
                        imageUrl: branch.coverImageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholderIcon: Icons.storefront_outlined,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.05),
                              Colors.black.withValues(alpha: 0.55),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 14,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                branch.name,
                                style: AppTextStyle.fontWhite16Bold.copyWith(
                                  fontSize: 18,
                                  shadows: const [
                                    Shadow(
                                      blurRadius: 8,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (onEdit != null) ...[
                              const SizedBox(width: 8),
                              Material(
                                color: Colors.black45,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: onEdit,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: AppColors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (onDelete != null) ...[
                              const SizedBox(width: 8),
                              Material(
                                color: Colors.black45,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: onDelete,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: AppColors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            branch.address,
                            style: AppTextStyle.fontGrey14Regular,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (_hasPhone || _hasLocation) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          if (_hasPhone)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _makePhoneCall(branch.phone!),
                                icon: const Icon(Icons.phone_outlined, size: 18),
                                label: Text(LocaleKeys.callBranch.tr()),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(color: AppColors.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                          if (_hasPhone && _hasLocation) const SizedBox(width: 10),
                          if (_hasLocation)
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _openMap(
                                  branch.latitude!,
                                  branch.longitude!,
                                ),
                                icon: const Icon(Icons.map_outlined, size: 18),
                                label: Text(LocaleKeys.openMap.tr()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
