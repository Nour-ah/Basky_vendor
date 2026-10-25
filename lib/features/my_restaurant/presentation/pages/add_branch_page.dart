import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/safe_network_image.dart';
import '../../domain/entities/add_branch_params.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/entities/product_image_entity.dart';
import '../../domain/entities/vendor_branch_entity.dart';
import '../cubit/add_branch_cubit.dart';
import '../cubit/add_branch_state.dart';
import '../models/branch_location_result.dart';
import '../widgets/add_food_text_field.dart';
import '../widgets/branch_location_preview.dart';
import 'branch_location_picker_page.dart';

class AddBranchPage extends StatefulWidget {
  const AddBranchPage({super.key, this.branch});

  final VendorBranchEntity? branch;

  bool get isEditMode => branch != null;

  @override
  State<AddBranchPage> createState() => _AddBranchPageState();
}

class _AddBranchPageState extends State<AddBranchPage> {
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;

  String? _imagePath;
  String? _latitude;
  String? _longitude;
  int? _countryId;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final b = widget.branch;
    _nameEnController = TextEditingController(text: b?.nameEn ?? b?.name ?? '');
    _nameArController = TextEditingController(text: b?.nameAr ?? '');
    _addressController = TextEditingController(text: b?.address ?? '');
    _phoneController = TextEditingController(text: b?.phone ?? '');
    _latitude = b?.latitude;
    _longitude = b?.longitude;
    _countryId = b?.countryId;
    _isActive = b?.isOpen ?? true;
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;
    setState(() => _imagePath = file.path);
  }

  Future<void> _pickLocation() async {
    final initialLat = double.tryParse(_latitude ?? '');
    final initialLng = double.tryParse(_longitude ?? '');
    final result = await Navigator.push<BranchLocationResult>(
      context,
      MaterialPageRoute(
        builder: (_) => BranchLocationPickerPage(
          initialAddress: _addressController.text.trim(),
          initialLatitude: initialLat,
          initialLongitude: initialLng,
        ),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _addressController.text = result.address;
      _latitude = result.latitude.toString();
      _longitude = result.longitude.toString();
    });
  }

  void _submit(AddBranchCubit cubit) {
    final nameEn = _nameEnController.text.trim();
    final nameAr = _nameArController.text.trim();
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();

    if (nameEn.isEmpty || nameAr.isEmpty) {
      _showError(LocaleKeys.nameEnglish.tr());
      return;
    }
    if (phone.isEmpty) {
      _showError(LocaleKeys.phoneRequired.tr());
      return;
    }
    if (_countryId == null) {
      _showError(LocaleKeys.countryRequired.tr());
      return;
    }
    if (address.isEmpty || _latitude == null || _longitude == null) {
      _showError(LocaleKeys.locationRequired.tr());
      return;
    }

    cubit.submit(
      AddBranchParams(
        nameEn: nameEn,
        nameAr: nameAr,
        address: address,
        phone: phone,
        latitude: _latitude,
        longitude: _longitude,
        countryId: _countryId!,
        isActive: _isActive,
        image: _imagePath != null
            ? ProductImageEntity(path: _imagePath!)
            : null,
        isEditMode: widget.isEditMode,
        branchId: widget.branch?.id,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.promoRed),
    );
  }

  List<CountryEntity> _countriesOf(AddBranchState state) {
    if (state is AddBranchFormReady) return state.countries;
    if (state is AddBranchSubmitting) return state.countries;
    if (state is AddBranchValidationError) return state.countries;
    if (state is AddBranchError) return state.countries;
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<AddBranchCubit>()..loadForm(),
      child: BlocConsumer<AddBranchCubit, AddBranchState>(
        listener: (context, state) {
          if (state is AddBranchFormReady &&
              _countryId == null &&
              state.countries.length == 1) {
            setState(() => _countryId = state.countries.first.id);
          }
          if (state is AddBranchSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(LocaleKeys.savedSuccessfully.tr()),
                backgroundColor: AppColors.primary,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is AddBranchError && state.countries.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.promoRed,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AddBranchCubit>();
          final isSubmitting = state is AddBranchSubmitting;
          final countries = _countriesOf(state);
          final lat = double.tryParse(_latitude ?? '');
          final lng = double.tryParse(_longitude ?? '');
          final hasLocation = lat != null &&
              lng != null &&
              _addressController.text.trim().isNotEmpty;

          return Scaffold(
            backgroundColor: AppColors.background,
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
                widget.isEditMode
                    ? LocaleKeys.editBranch.tr()
                    : LocaleKeys.addBranch.tr(),
                style: AppTextStyle.fontBlack16Bold,
              ),
            ),
            body: SafeArea(
              child: state is AddBranchLoadingForm || state is AddBranchInitial
                  ? const Center(child: CircularProgressIndicator())
                  : (state is AddBranchError && countries.isEmpty)
                      ? Center(
                          child: FilledButton(
                            onPressed: cubit.loadForm,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: Text(LocaleKeys.retry.tr()),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            _BranchImageBox(
                              localPath: _imagePath,
                              networkUrl: widget.branch?.coverImageUrl ??
                                  widget.branch?.logoUrl,
                              onTap: isSubmitting ? null : _pickImage,
                            ),
                            const SizedBox(height: 16),
                            AddFoodTextField(
                              hintText: LocaleKeys.nameEnglish.tr(),
                              controller: _nameEnController,
                            ),
                            const SizedBox(height: 12),
                            AddFoodTextField(
                              hintText: LocaleKeys.nameArabic.tr(),
                              controller: _nameArController,
                            ),
                            const SizedBox(height: 12),
                            AddFoodTextField(
                              hintText: LocaleKeys.phoneNumber.tr(),
                              controller: _phoneController,
                            ),
                            const SizedBox(height: 12),
                            _CountryDropdown(
                              countries: countries,
                              selectedId: _countryId,
                              onChanged: isSubmitting
                                  ? null
                                  : (id) => setState(() => _countryId = id),
                            ),
                            const SizedBox(height: 12),
                            if (hasLocation)
                              BranchLocationPreview(
                                address: _addressController.text.trim(),
                                latitude: lat,
                                longitude: lng,
                                onTap: isSubmitting ? null : _pickLocation,
                              )
                            else
                              InkWell(
                                onTap: isSubmitting ? null : _pickLocation,
                                borderRadius: BorderRadius.circular(12),
                                child: Ink(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          LocaleKeys.selectLocationOnMap.tr(),
                                          style:
                                              AppTextStyle.fontGrey14Regular,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.map_outlined,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                LocaleKeys.active.tr(),
                                style: AppTextStyle.fontBlack14Bold,
                              ),
                              value: _isActive,
                              activeThumbColor: AppColors.primary,
                              onChanged: isSubmitting
                                  ? null
                                  : (v) => setState(() => _isActive = v),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed: isSubmitting
                                    ? null
                                    : () => _submit(cubit),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: isSubmitting
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        LocaleKeys.save.tr(),
                                        style: AppTextStyle.fontWhite16Bold,
                                      ),
                              ),
                            ),
                          ],
                        ),
            ),
          );
        },
      ),
    );
  }
}

class _CountryDropdown extends StatelessWidget {
  const _CountryDropdown({
    required this.countries,
    required this.selectedId,
    required this.onChanged,
  });

  final List<CountryEntity> countries;
  final int? selectedId;
  final ValueChanged<int?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final value = countries.any((c) => c.id == selectedId) ? selectedId : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          hint: Text(
            LocaleKeys.country.tr(),
            style: AppTextStyle.fontGrey14Regular,
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
          items: countries
              .map(
                (c) => DropdownMenuItem<int>(
                  value: c.id,
                  child: Text(c.name, style: AppTextStyle.fontBlack14Bold),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _BranchImageBox extends StatelessWidget {
  const _BranchImageBox({
    required this.localPath,
    required this.networkUrl,
    required this.onTap,
  });

  final String? localPath;
  final String? networkUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
        ),
        clipBehavior: Clip.antiAlias,
        child: localPath != null
            ? Image.file(File(localPath!), fit: BoxFit.cover)
            : (networkUrl != null && networkUrl!.isNotEmpty)
                ? SafeNetworkImage(
                    imageUrl: networkUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholderIcon: Icons.add_a_photo_outlined,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_a_photo_outlined,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        LocaleKeys.branchImage.tr(),
                        style: AppTextStyle.fontPrimary14Regular,
                      ),
                    ],
                  ),
      ),
    );
  }
}
