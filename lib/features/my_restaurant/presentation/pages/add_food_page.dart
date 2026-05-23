import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/category_entity.dart';
import '../widgets/add_food_form_body.dart';
import '../cubit/add_food_cubit.dart';
import '../cubit/add_food_state.dart';

class AddFoodPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<AddFoodCubit>()..loadForm(),
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
          final cubit = context.read<AddFoodCubit>();
          final isSubmitting = state is AddFoodSubmitting;
          final validationErrors = state is AddFoodValidationError
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
                isEditMode ? LocaleKeys.editFood.tr() : LocaleKeys.addFood.tr(),
                style: AppTextStyle.fontBlack16Bold,
              ),
            ),
            body: SafeArea(
              child: _buildBody(
                context,
                state,
                cubit.cachedCategories,
                isSubmitting,
                validationErrors,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AddFoodState state,
    List<CategoryEntity> categories,
    bool isSubmitting,
    Map<String, List<String>> validationErrors,
  ) {
    if (state is AddFoodLoadingForm || state is AddFoodInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AddFoodError && categories.isEmpty) {
      return Center(
        child: Text(state.message, style: AppTextStyle.fontPrimary14Regular),
      );
    }

    final canShowForm = categories.isNotEmpty &&
        (state is AddFoodFormReady ||
            state is AddFoodSubmitting ||
            state is AddFoodValidationError);

    if (canShowForm) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AddFoodFormBody(
          categories: categories,
          isEditMode: isEditMode,
          isLoading: isSubmitting,
          validationErrors: validationErrors,
          initialName: initialName,
          initialDescription: initialDescription,
          initialPrice: initialPrice,
          initialDiscount: initialDiscount,
          productId: productId,
          onSubmit: (params) => context.read<AddFoodCubit>().submitForm(params),
        ),
      );
    }

    if (categories.isEmpty) {
      return Center(child: Text(LocaleKeys.noProductsFound.tr()));
    }

    return const SizedBox.shrink();
  }
}
