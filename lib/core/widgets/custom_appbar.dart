import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_images.dart';
import '../widgets/custom_image_view.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomImageView(imagePath: AppImages.logo,width: 50,height: 50,),
            CustomImageView(imagePath: AppImages.logo,width: 24,height: 24,),
          ]
      ),
    );
  }
}
