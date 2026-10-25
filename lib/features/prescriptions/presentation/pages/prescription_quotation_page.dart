import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/utils/app_snackbar_helper.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/prescription_quote_item_input.dart';
import '../../domain/entities/vendor_prescription_request.dart';
import '../cubit/prescription_quotation_cubit.dart';
import '../cubit/prescription_quotation_state.dart';
import '../widgets/pharmacy_access_guard.dart';
import '../widgets/prescription_image_preview.dart';
import '../widgets/prescription_medicine_items_section.dart';

class PrescriptionQuotationPage extends StatefulWidget {
  const PrescriptionQuotationPage({
    super.key,
    required this.request,
  });

  final VendorPrescriptionRequest request;

  @override
  State<PrescriptionQuotationPage> createState() =>
      _PrescriptionQuotationPageState();
}

class _MedicineDraft {
  _MedicineDraft()
      : nameController = TextEditingController(),
        quantityController = TextEditingController(text: '1'),
        priceController = TextEditingController(),
        notesController = TextEditingController(),
        isAvailable = true;

  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController notesController;
  bool isAvailable;

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    notesController.dispose();
  }
}

class _PrescriptionQuotationPageState extends State<PrescriptionQuotationPage> {
  late final PrescriptionQuotationCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  final List<_MedicineDraft> _drafts = [];

  @override
  void initState() {
    super.initState();
    _cubit = sl<PrescriptionQuotationCubit>();
    _addMedicine();
  }

  @override
  void dispose() {
    for (final draft in _drafts) {
      draft.dispose();
    }
    _cubit.close();
    super.dispose();
  }

  void _addMedicine() {
    setState(() => _drafts.add(_MedicineDraft()));
  }

  void _removeMedicine(int index) {
    if (_drafts.length <= 1) return;
    setState(() {
      _drafts[index].dispose();
      _drafts.removeAt(index);
    });
  }

  num get _estimatedSubtotal {
    num total = 0;
    for (final draft in _drafts) {
      if (!draft.isAvailable) continue;
      final qty = int.tryParse(draft.quantityController.text.trim()) ?? 0;
      final price = num.tryParse(draft.priceController.text.trim()) ?? 0;
      if (qty > 0) total += price * qty;
    }
    return total;
  }

  List<PrescriptionQuoteItemInput> _buildItems() {
    return _drafts.map((draft) {
      final qty = int.tryParse(draft.quantityController.text.trim()) ?? 0;
      final priceText = draft.priceController.text.trim();
      final price = priceText.isEmpty ? null : num.tryParse(priceText);
      final notes = draft.notesController.text.trim();
      return PrescriptionQuoteItemInput(
        medicineName: draft.nameController.text.trim(),
        isAvailable: draft.isAvailable,
        price: draft.isAvailable ? price : (price ?? 0),
        quantity: qty,
        notes: notes.isEmpty ? null : notes,
      );
    }).toList();
  }

  Future<void> _confirmAndSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.prescriptionSendQuoteTitle.tr()),
        content: Text(LocaleKeys.prescriptionSendQuoteDescription.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(LocaleKeys.prescriptionReviewDraft.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              LocaleKeys.prescriptionSendQuote.tr(),
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await _cubit.submit(
      requestId: widget.request.id,
      items: _buildItems(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return PharmacyAccessGuard(
      child: BlocProvider.value(
        value: _cubit,
        child: BlocConsumer<PrescriptionQuotationCubit, PrescriptionQuotationState>(
          listener: (context, state) {
            if (state is PrescriptionQuotationSuccess) {
              AppSnackBarHelper.showSuccessSnackBar(
                message: LocaleKeys.prescriptionQuoteSentSuccess.tr(),
                context: context,
              );
              Navigator.pop(context, true);
            } else if (state is PrescriptionQuotationFailure) {
              AppSnackBarHelper.showErrorSnackBar(
                message: state.message,
                context: context,
              );
            } else if (state is PrescriptionQuotationValidationError) {
              AppSnackBarHelper.showErrorSnackBar(
                message: state.message.tr(),
                context: context,
              );
            }
          },
          builder: (context, state) {
            final isSubmitting = state is PrescriptionQuotationSubmitting;

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(
                    isAr ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
                    color: AppColors.black,
                    size: 20,
                  ),
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                ),
                title: Text(
                  LocaleKeys.prescriptionPrepareQuote.tr(),
                  style: AppTextStyle.fontBlack16Bold,
                ),
              ),
              body: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    PrescriptionImagePreview(
                      imageUrl: widget.request.image,
                      height: 200,
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(_drafts.length, (index) {
                      return _MedicineFormCard(
                        key: ValueKey(index),
                        draft: _drafts[index],
                        index: index,
                        canDelete: _drafts.length > 1,
                        onChanged: () => setState(() {}),
                        onDelete: () => _removeMedicine(index),
                      );
                    }),
                    TextButton.icon(
                      onPressed: isSubmitting ? null : _addMedicine,
                      icon: const Icon(Icons.add),
                      label: Text(LocaleKeys.prescriptionAddMedicine.tr()),
                    ),
                    const SizedBox(height: 8),
                    PrescriptionTotalsSection(
                      request: widget.request,
                      estimatedSubtotal: _estimatedSubtotal,
                    ),
                    const SizedBox(height: 20),
                    if (isSubmitting)
                      const Center(child: CircularProgressIndicator())
                    else
                      PrimaryButton(
                        text: LocaleKeys.prescriptionSendQuote.tr(),
                        onPressed: _confirmAndSubmit,
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MedicineFormCard extends StatelessWidget {
  const _MedicineFormCard({
    super.key,
    required this.draft,
    required this.index,
    required this.canDelete,
    required this.onChanged,
    required this.onDelete,
  });

  final _MedicineDraft draft;
  final int index;
  final bool canDelete;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${LocaleKeys.prescriptionMedicine.tr()} ${index + 1}',
                  style: AppTextStyle.fontBlack14Bold,
                ),
              ),
              if (canDelete)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: AppColors.promoRed),
                ),
            ],
          ),
          TextFormField(
            controller: draft.nameController,
            decoration: _decoration(LocaleKeys.prescriptionMedicineName.tr()),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return LocaleKeys.prescriptionMedicineNameRequired.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.prescriptionAvailability.tr(),
                  style: AppTextStyle.fontGrey14Regular,
                ),
              ),
              Text(
                draft.isAvailable
                    ? LocaleKeys.prescriptionAvailable.tr()
                    : LocaleKeys.prescriptionUnavailable.tr(),
                style: AppTextStyle.fontBlack14Regular,
              ),
              Switch(
                value: draft.isAvailable,
                activeThumbColor: AppColors.primary,
                onChanged: (value) {
                  draft.isAvailable = value;
                  onChanged();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: draft.quantityController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _decoration(LocaleKeys.quantity.tr()),
            onChanged: (_) => onChanged(),
            validator: (value) {
              final qty = int.tryParse(value?.trim() ?? '');
              if (qty == null || qty <= 0) {
                return LocaleKeys.prescriptionQuantityInvalid.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: draft.priceController,
            enabled: draft.isAvailable,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: _decoration(LocaleKeys.prescriptionUnitPrice.tr()),
            onChanged: (_) => onChanged(),
            validator: (value) {
              if (!draft.isAvailable) return null;
              if (value == null || value.trim().isEmpty) {
                return LocaleKeys.prescriptionPriceRequired.tr();
              }
              final price = num.tryParse(value.trim());
              if (price == null || price < 0) {
                return LocaleKeys.prescriptionPriceInvalid.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: draft.notesController,
            maxLines: 2,
            decoration: _decoration(
              draft.isAvailable
                  ? LocaleKeys.notes.tr()
                  : LocaleKeys.prescriptionUnavailableNoteHint.tr(),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyle.fontGrey12Regular,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}
