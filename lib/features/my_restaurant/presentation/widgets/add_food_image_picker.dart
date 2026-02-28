import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AddFoodImagePicker extends StatelessWidget {
  final String title;

  const AddFoodImagePicker({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1.5),
        borderRadius: BorderRadius.circular(16),
        color: AppColors.white,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            color: AppColors.primary,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyle.fontPrimary12Regular),
        ],
      ),
    );
  }
}
