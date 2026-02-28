import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/add_food_dropdown.dart';
import '../widgets/add_food_image_picker.dart';
import '../widgets/add_food_text_field.dart';
import '../widgets/confirm_order_dialog.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  // Dummy values for dropdowns
  String _selectedPercentageType = AppStrings.percentage.tr();
  String _selectedCategory = AppStrings.productCategory.tr();
  String _selectedSubcategory = AppStrings.subcategory.tr();

  final List<String> _percentageTypes = [AppStrings.percentage.tr()];
  final List<String> _categories = [AppStrings.productCategory.tr()];
  final List<String> _subcategories = [AppStrings.subcategory.tr()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.addFood.tr(),
          style: AppTextStyle.fontBlack16Bold,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Meal Image Box
              AddFoodImagePicker(title: AppStrings.mealImage.tr()),
              const SizedBox(height: 16),

              // Meal Name
              AddFoodTextField(hintText: AppStrings.mealName.tr()),
              const SizedBox(height: 16),

              // Meal Description
              AddFoodTextField(
                hintText: AppStrings.mealDescription.tr(),
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              // Price
              AddFoodTextField(hintText: AppStrings.price.tr()),
              const SizedBox(height: 16),

              // Percentage Row
              Row(
                children: [
                  Expanded(
                    child: AddFoodDropdown(
                      value: _selectedPercentageType,
                      items: _percentageTypes,
                      onChanged: (val) {
                        if (val != null)
                          setState(() => _selectedPercentageType = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AddFoodTextField(
                      hintText: AppStrings.discountPercentage.tr(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Category Row
              Row(
                children: [
                  Expanded(
                    child: AddFoodDropdown(
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (val) {
                        if (val != null)
                          setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AddFoodDropdown(
                      value: _selectedSubcategory,
                      items: _subcategories,
                      onChanged: (val) {
                        if (val != null)
                          setState(() => _selectedSubcategory = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Max Order Quantity
              AddFoodTextField(hintText: AppStrings.maximumOrderQuantity.tr()),
              const SizedBox(height: 16),

              // Add-Ons
              AddFoodTextField(hintText: AppStrings.addOns.tr()),

              const SizedBox(height: 32),

              // Add Button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.promoRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.add.tr(),
                    style: AppTextStyle.fontWhite16Bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return const ConfirmOrderDialog();
      },
    );

    if (result == true) {
      // Go back from Add Food page
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
