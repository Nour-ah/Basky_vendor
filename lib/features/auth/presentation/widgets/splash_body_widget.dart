import 'package:flutter/material.dart';
import 'package:basky_vendor/core/theme/app_images.dart';
import 'package:basky_vendor/core/widgets/custom_image_view.dart';
import '../../../../core/theme/app_colors.dart';

class SplashBodyWidget extends StatelessWidget {
  const SplashBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                // color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: CustomImageView(
                imagePath: AppImages.logo,
                fit: BoxFit.scaleDown,
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Basky Vendor',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            // const SizedBox(height: 8),
            // Text(
            //   'Vendor Dashboard',
            //   style: TextStyle(
            //     color: AppColors.white.withValues(alpha: 0.7),
            //     fontSize: 14,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
