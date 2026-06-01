import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/variant_entity.dart';
import '../../presentation/cubit/variants_cubit.dart';
import '../../presentation/cubit/variants_state.dart';
import '../widgets/variant_card.dart';
import '../widgets/variant_form_sheet.dart';

class VariantsPage extends StatelessWidget {
  const VariantsPage({super.key});

  void _showForm(BuildContext context, VariantsCubit cubit, [VariantEntity? variant]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => VariantFormSheet(
        variant: variant,
        onSubmit: (name, options) {
          if (variant == null) {
            cubit.addVariant(name, options);
          } else {
            cubit.updateVariant(variant.id, name, options);
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, VariantsCubit cubit, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('deleteVariant'.tr()),
        content: Text('deleteVariantConfirm'.tr()),
        actions: [
          TextButton(
            child: Text('cancel'.tr()),
            onPressed: () => Navigator.pop(dialogContext),
          ),
          TextButton(
            child: Text('delete'.tr(), style: const TextStyle(color: AppColors.promoRed)),
            onPressed: () {
              cubit.deleteVariant(id);
              Navigator.pop(dialogContext);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VariantsCubit>()..fetchVariants(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Text('productVariants'.tr(), style: AppTextStyle.fontBlack16Bold),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<VariantsCubit, VariantsState>(
          listener: (context, state) {
            if (state is VariantsActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('operationCompletedSuccessfully'.tr()),
                  backgroundColor: AppColors.primary,
                ),
              );
            } else if (state is VariantsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.promoRed,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<VariantsCubit>();

            if (state is VariantsLoading || state is VariantsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            final variants = cubit.variants;

            if (variants.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('noVariantsFound'.tr(), style: AppTextStyle.fontGrey16Regular),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showForm(context, cubit),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: Text('addYourFirstVariant'.tr()),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: variants.length,
              itemBuilder: (context, index) {
                final variant = variants[index];
                return VariantCard(
                  variant: variant,
                  onEdit: () => _showForm(context, cubit, variant),
                  onDelete: () => _confirmDelete(context, cubit, variant.id),
                );
              },
            );
          },
        ),
        floatingActionButton: BlocBuilder<VariantsCubit, VariantsState>(
          builder: (context, state) {
            final cubit = context.read<VariantsCubit>();
            return FloatingActionButton(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: AppColors.white),
              onPressed: () => _showForm(context, cubit),
            );
          },
        ),
      ),
    );
  }
}
