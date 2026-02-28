import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:spider_restaurant/core/theme/app_images.dart';
import 'package:spider_restaurant/core/widgets/custom_image_view.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dummy_data.dart';
 import 'category_item.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.imageProfile,
    required this.userName,
  });

  final String imageProfile;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: Stack(
        children: [
          // Blue Background Curve
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              height: 280,
              width: double.infinity,
              color: AppColors.primary,
            ),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  // User Info Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(imageProfile),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              userName,
                              style: AppTextStyle.fontWhite16Bold.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const CustomImageView(
                                  fit: BoxFit.scaleDown,
                                  imagePath: 'assets/images/location.png',
                                  color: AppColors.promoRed,
                                  width: 16,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    DummyData.userLocation,
                                    style: AppTextStyle.fontWhite12Regular,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      CustomImageView(
                        fit: BoxFit.scaleDown,
                        imagePath: AppImages.bag,
                        width: 24,
                      ),
                      CustomImageView(
                        imagePath: AppImages.notification,
                        width: 24,
                        fit: BoxFit.scaleDown,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const CustomImageView(
                          fit: BoxFit.scaleDown,
                          imagePath: AppImages.search,
                          width: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.searchPlaceholder,
                          style: AppTextStyle.fontWhite14Regular,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Categories Overlapping
          Positioned(
            bottom: 4,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: DummyData.categories.length,
                itemBuilder: (context, index) {
                  final cat = DummyData.categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CategoryItem(
                      title: cat['title'],
                      imageUrl: cat['image'],
                      index: index,
                      onTap: () {
                        // For now we just navigate to RestaurantsPage for any top category

                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    // Control point and end point
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height + 20,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
