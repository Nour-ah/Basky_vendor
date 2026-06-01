import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../domain/entities/add_product_params.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_image_entity.dart';
import '../../domain/entities/product_status.dart';
import '../../domain/entities/product_type.dart';
import '../../domain/entities/product_variant_entity.dart';
import '../../domain/utils/product_variations_builder.dart';
import '../../ui/widgets/add_food_multi_image_picker.dart';
import '../../ui/widgets/add_food_toggles.dart';
import '../../ui/widgets/add_food_type_dropdown.dart';
import '../../../variants/ui/widgets/variants_selector_widget.dart';
import '../../../variants/ui/screens/variants_page.dart';
import '../cubit/add_food_cubit.dart';
import 'add_food_image_picker.dart';
import 'add_food_text_field.dart';

class AddFoodFormBody extends StatefulWidget {
  const AddFoodFormBody({
    super.key,
    required this.categories,
    required this.variants,
    required this.isEditMode,
    required this.isLoading,
    required this.validationErrors,
    required this.onSubmit,
    this.initialName,
    this.initialDescription,
    this.initialPrice,
    this.initialDiscount,
    this.productId,
  });

  final List<CategoryEntity> categories;
  final List<ProductVariantEntity> variants;
  final bool isEditMode;
  final bool isLoading;
  final Map<String, List<String>> validationErrors;
  final void Function(AddProductParams params) onSubmit;
  final String? initialName;
  final String? initialDescription;
  final double? initialPrice;
  final double? initialDiscount;
  final int? productId;

  @override
  State<AddFoodFormBody> createState() => _AddFoodFormBodyState();
}

class _AddFoodFormBodyState extends State<AddFoodFormBody> {
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  late final TextEditingController _descEnController;
  late final TextEditingController _descArController;
  late final TextEditingController _priceController;
  late final TextEditingController _discountController;
  late final TextEditingController _skuController;
  late final TextEditingController _slugController;

  String? _imagePath;
  List<String> _additionalImagePaths = [];
  int? _selectedCategoryId;
  ProductType _selectedProductType = ProductType.simple;
  Map<int, List<int>> _selectedOptionsByVariant = {};

  bool _isFeatured = false;
  bool _isNew = false;
  bool _isBookable = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialName ?? '';
    _nameEnController = TextEditingController(text: initial);
    _nameArController = TextEditingController(text: initial);
    _descEnController = TextEditingController(text: widget.initialDescription ?? '');
    _descArController = TextEditingController(text: widget.initialDescription ?? '');
    _priceController = TextEditingController(text: widget.initialPrice?.toString() ?? '');
    _discountController = TextEditingController(text: widget.initialDiscount?.toString() ?? '');
    _skuController = TextEditingController();
    _slugController = TextEditingController();

    _nameEnController.addListener(_onNameEnChanged);

    if (widget.categories.isNotEmpty) {
      _selectedCategoryId = widget.categories.first.id;
    }
  }

  void _onNameEnChanged() {
    final text = _nameEnController.text.trim();
    _slugController.text = text.toLowerCase().replaceAll(' ', '-');
  }

  @override
  void dispose() {
    _nameEnController.removeListener(_onNameEnChanged);
    _nameEnController.dispose();
    _nameArController.dispose();
    _descEnController.dispose();
    _descArController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _skuController.dispose();
    _slugController.dispose();
    super.dispose();
  }

  String? _errorFor(List<String> keys) {
    for (final key in keys) {
      final messages = widget.validationErrors[key];
      if (messages != null && messages.isNotEmpty) return messages.first;
    }
    return null;
  }

  void _submit() {
    final categoryId = _selectedCategoryId;
    if (categoryId == null) return;

    if (_selectedProductType == ProductType.variable) {
      if (_selectedOptionsByVariant.isEmpty) {
        _showMessage(LocaleKeys.selectAtLeastOneVariant.tr());
        return;
      }
      for (final entry in _selectedOptionsByVariant.entries) {
        if (entry.value.isEmpty) {
          _showMessage(LocaleKeys.selectAtLeastOneVariantOption.tr());
          return;
        }
      }
    }

    final basePrice = double.tryParse(_priceController.text) ?? 0.0;
    final variations = _selectedProductType == ProductType.variable
        ? buildProductVariations(
            variants: widget.variants,
            selectedOptionsByVariant: _selectedOptionsByVariant,
            nameEn: _nameEnController.text.trim(),
            nameAr: _nameArController.text.trim(),
            basePrice: basePrice,
            baseSku: _skuController.text.trim().isEmpty
                ? null
                : _skuController.text.trim(),
          )
        : null;

    widget.onSubmit(
      AddProductParams(
        nameEn: _nameEnController.text.trim(),
        nameAr: _nameArController.text.trim(),
        descriptionEn: _descEnController.text.trim(),
        descriptionAr: _descArController.text.trim(),
        productType: _selectedProductType,
        price: basePrice,
        discountPercentage: double.tryParse(_discountController.text) ?? 0.0,
        discountType: 'percentage',
        categoryId: categoryId,
        status: ProductStatus.active,
        sku: _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
        slug: _slugController.text.trim().isEmpty ? null : _slugController.text.trim(),
        isFeatured: _isFeatured,
        isNew: _isNew,
        isBookable: _isBookable,
        image: _imagePath != null ? ProductImageEntity(path: _imagePath!) : null,
        images: _additionalImagePaths.map((path) => ProductImageEntity(path: path)).toList(),
        variations: variations,
        isEditMode: widget.isEditMode,
        productId: widget.productId,
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.promoRed,
      ),
    );
  }

  Widget _errorText(String? message) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.promoRed, fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AddFoodTypeDropdown(
          selectedType: _selectedProductType,
          onChanged: (type) => setState(() {
            _selectedProductType = type;
            if (type != ProductType.variable) {
              _selectedOptionsByVariant = {};
            }
          }),
        ),
        _errorText(_errorFor(['type'])),
        if (_selectedProductType == ProductType.variable) ...[
          const SizedBox(height: 16),
          VariantsSelectorWidget(
            variants: widget.variants,
            selectedOptionsByVariant: _selectedOptionsByVariant,
            onSelectionChanged: (selection) =>
                setState(() => _selectedOptionsByVariant = selection),
            onManageVariants: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VariantsPage()),
              );
              if (!context.mounted) return;
              context.read<AddFoodCubit>().loadForm();
            },
          ),
          if (countVariationCombinations(_selectedOptionsByVariant) > 0) ...[
            const SizedBox(height: 8),
            Text(
              LocaleKeys.variationsWillBeCreated.tr(
                namedArgs: {
                  'count': countVariationCombinations(_selectedOptionsByVariant)
                      .toString(),
                },
              ),
              style: AppTextStyle.fontPrimary12Regular,
            ),
          ],
        ],
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          initialValue: _selectedCategoryId,
          decoration: InputDecoration(
            labelText: LocaleKeys.selectCategory.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: widget.categories.map((c) => DropdownMenuItem<int>(value: c.id, child: Text(c.name))).toList(),
          onChanged: (value) => setState(() => _selectedCategoryId = value),
        ),
        _errorText(_errorFor(['category_id', 'categories', 'categories.0'])),
        const SizedBox(height: 16),
        AddFoodTextField(hintText: LocaleKeys.nameEnglish.tr(), controller: _nameEnController),
        _errorText(_errorFor(['name.en', 'name[en]', 'name'])),
        const SizedBox(height: 16),
        AddFoodTextField(hintText: LocaleKeys.nameArabic.tr(), controller: _nameArController),
        _errorText(_errorFor(['name.ar', 'name[ar]'])),
        const SizedBox(height: 16),
        AddFoodTextField(hintText: LocaleKeys.descriptionEnglish.tr(), maxLines: 3, controller: _descEnController),
        _errorText(_errorFor(['description.en', 'description[en]', 'description'])),
        const SizedBox(height: 16),
        AddFoodTextField(hintText: LocaleKeys.descriptionArabic.tr(), maxLines: 3, controller: _descArController),
        _errorText(_errorFor(['description.ar', 'description[ar]'])),
        const SizedBox(height: 16),
        AddFoodTextField(hintText: LocaleKeys.price.tr(), controller: _priceController),
        _errorText(_errorFor(['price'])),
        const SizedBox(height: 16),
        AddFoodTextField(hintText: LocaleKeys.discountPercentage.tr(), controller: _discountController),
        _errorText(_errorFor(['discount', 'discount_type'])),
        const SizedBox(height: 16),
        AddFoodTextField(hintText: LocaleKeys.skuOptional.tr(), controller: _skuController),
        _errorText(_errorFor(['sku'])),
        const SizedBox(height: 16),
        AddFoodTextField(hintText: LocaleKeys.slugOptional.tr(), controller: _slugController),
        _errorText(_errorFor(['slug'])),
        const SizedBox(height: 16),
        AddFoodToggles(
          isFeatured: _isFeatured,
          isNew: _isNew,
          isBookable: _isBookable,
          onFeaturedChanged: (v) => setState(() => _isFeatured = v),
          onNewChanged: (v) => setState(() => _isNew = v),
          onBookableChanged: (v) => setState(() => _isBookable = v),
        ),
        const SizedBox(height: 16),
        AddFoodImagePicker(
          title: LocaleKeys.mealImage.tr(),
          pickHint: LocaleKeys.pickMealImage.tr(),
          onImagePicked: (path) => _imagePath = path,
        ),
        const SizedBox(height: 16),
        AddFoodMultiImagePicker(
          title: LocaleKeys.additionalImages.tr(),
          pickHint: LocaleKeys.pickMultipleGalleryImages.tr(),
          onImagesPicked: (paths) => _additionalImagePaths = paths,
        ),
        const SizedBox(height: 32),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: widget.isLoading
                ? LinearGradient(colors: [AppColors.grey, AppColors.grey])
                : LinearGradient(
                    colors: [AppColors.promoRed, AppColors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            boxShadow: widget.isLoading
                ? null
                : [
                    BoxShadow(
                      color: AppColors.promoRed.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : _submit,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.isEditMode ? Icons.save_outlined : Icons.add_circle_outline,
                            color: AppColors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.isEditMode ? LocaleKeys.save.tr() : LocaleKeys.add.tr(),
                            style: AppTextStyle.fontWhite16Bold,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

