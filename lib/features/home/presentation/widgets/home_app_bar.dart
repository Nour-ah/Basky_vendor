import 'package:flutter/material.dart';
import 'package:spider_restaurant/core/theme/app_images.dart';
import 'package:spider_restaurant/core/widgets/custom_image_view.dart';
import '../../../../core/theme/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
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
          const CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/profile.png',
            ), // Replace as needed
            radius: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Heba Yasser',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.red, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Kattamya, Stone Residence',
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
