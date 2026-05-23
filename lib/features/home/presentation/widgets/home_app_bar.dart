import 'package:flutter/material.dart';
import 'package:spider_restaurant/core/theme/app_images.dart';
import 'package:spider_restaurant/core/widgets/custom_image_view.dart';
import '../../../../core/theme/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.scaffoldKey,
    required this.userName,
    required this.userAddress,
    this.userImageUrl,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String userName;
  final String userAddress;
  final String? userImageUrl;

  @override
  Widget build(BuildContext context) {
    final hasNetworkImage =
        userImageUrl != null && userImageUrl!.trim().isNotEmpty;

    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.black),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.greyLight,
            backgroundImage: hasNetworkImage
                ? null
                : const AssetImage(AppImages.imageProfile),
            child: hasNetworkImage
                ? ClipOval(
                    child: CustomImageView(
                      imagePath: userImageUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (userAddress.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.red, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          userAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.grey.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        CustomImageView(
          imagePath: AppImages.notification,
          width: 24,
          fit: BoxFit.scaleDown,
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
