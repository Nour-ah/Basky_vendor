import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/di/injection_container.dart';
import '../widgets/add_food_image_picker.dart';
import '../widgets/add_food_text_field.dart';
import '../cubit/add_food_cubit.dart';
import '../cubit/add_food_state.dart';
import '../../domain/entities/add_product_params.dart';
import '../../domain/entities/product_status.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({
    super.key,
    this.productId,
    this.initialName,
    this.initialDescription,
    this.initialPrice,
    this.initialDiscount,
  });

  final int? productId;
  final String? initialName;
  final String? initialDescription;
  final double? initialPrice;
  final double? initialDiscount;

  bool get isEditMode => productId != null;

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _priceController;
  late final TextEditingController _discountController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descController = TextEditingController(text: widget.initialDescription ?? '');
    _priceController = TextEditingController(
      text: widget.initialPrice?.toString() ?? '',
    );
    _discountController = TextEditingController(
      text: widget.initialDiscount?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    final params = AddProductParams(
      name: _nameController.text,
      description: _descController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      discountPercentage: double.tryParse(_discountController.text) ?? 0.0,
      categoryId: 1,
      maxOrderQuantity: 10,
      status: ProductStatus.active,
      isEditMode: widget.isEditMode,
      productId: widget.productId,
    );
    context.read<AddFoodCubit>().submitForm(params);
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<AddFoodCubit>(),
      child: BlocConsumer<AddFoodCubit, AddFoodState>(
        listener: (context, state) {
          if (state is AddFoodSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(LocaleKeys.savedSuccessfully.tr()),
                backgroundColor: AppColors.primary,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is AddFoodError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.promoRed,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AddFoodSubmitting;
          final validationErrors = (state is AddFoodValidationError)
              ? state.validationErrors
              : <String, List<String>>{};

          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  isAr ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
                  color: AppColors.black,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                widget.isEditMode ? LocaleKeys.editFood.tr() : LocaleKeys.addFood.tr(),
                style: AppTextStyle.fontBlack16Bold,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AddFoodImagePicker(title: LocaleKeys.mealImage.tr()),
                    const SizedBox(height: 16),
                    AddFoodTextField(
                      hintText: LocaleKeys.mealName.tr(),
                      controller: _nameController,
                    ),
                    if (validationErrors.containsKey('name'))
                      Text(
                        validationErrors['name']!.first,
                        style: const TextStyle(color: AppColors.promoRed, fontSize: 12),
                      ),
                    const SizedBox(height: 16),
                    AddFoodTextField(
                      hintText: LocaleKeys.mealDescription.tr(),
                      maxLines: 5,
                      controller: _descController,
                    ),
                    const SizedBox(height: 16),
                    AddFoodTextField(
                      hintText: LocaleKeys.price.tr(),
                      controller: _priceController,
                    ),
                    const SizedBox(height: 16),
                    AddFoodTextField(
                      hintText: LocaleKeys.discountPercentage.tr(),
                      controller: _discountController,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.promoRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: AppColors.white),
                              )
                            : Text(
                                widget.isEditMode ? LocaleKeys.save.tr() : LocaleKeys.add.tr(),
                                style: AppTextStyle.fontWhite16Bold,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
