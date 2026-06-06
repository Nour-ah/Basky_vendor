// import 'package:flutter/material.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_text_styles.dart';
// import '../models/menu_category_model.dart';
//
// class RestaurantCategoriesTabs extends StatelessWidget {
//   final List<MenuCategoryModel> categories;
//   final String selectedCategory;
//   final ValueChanged<String> onCategorySelected;
//
//   const RestaurantCategoriesTabs({
//     super.key,
//     required this.categories,
//     required this.selectedCategory,
//     required this.onCategorySelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: categories.map((cat) {
//           if (cat.isAddButton) {
//             return GestureDetector(
//               onTap: () => onCategorySelected(cat.name),
//               child: Container(
//                 margin: const EdgeInsets.only(right: 8),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   cat.name,
//                   style: AppTextStyle.fontWhite14Regular.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             );
//           }
//
//           final isSelected = selectedCategory == cat.name;
//           return GestureDetector(
//             onTap: () => onCategorySelected(cat.name),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               margin: const EdgeInsets.only(right: 8),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: isSelected ? AppColors.primary : AppColors.border,
//                 ),
//               ),
//               child: Text(
//                 cat.name,
//                 style: isSelected
//                     ? AppTextStyle.fontPrimary14Regular.copyWith(
//                         fontWeight: FontWeight.w600,
//                       )
//                     : AppTextStyle.fontBlack14Regular,
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
