import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/variant_entity.dart';

class VariantFormSheet extends StatefulWidget {
  final VariantEntity? variant;
  final Function(String name, List<String> options) onSubmit;

  const VariantFormSheet({super.key, this.variant, required this.onSubmit});

  @override
  State<VariantFormSheet> createState() => _VariantFormSheetState();
}

class _VariantFormSheetState extends State<VariantFormSheet> {
  late final TextEditingController _nameController;
  final List<TextEditingController> _optionControllers = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.variant?.name ?? '');
    if (widget.variant != null) {
      for (final opt in widget.variant!.options) {
        _optionControllers.add(TextEditingController(text: opt.name));
      }
    } else {
      _optionControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final options = _optionControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    if (name.isNotEmpty && options.isNotEmpty) {
      widget.onSubmit(name, options);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.variant == null ? 'addVariant'.tr() : 'editVariant'.tr(),
            style: AppTextStyle.heading20Bold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'variantNameHint'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('options'.tr(), style: AppTextStyle.fontBlack14Bold),
              TextButton.icon(
                icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                label: Text(
                  'addOption'.tr(),
                  style: AppTextStyle.fontPrimary14Regular,
                ),
                onPressed: () => setState(
                  () => _optionControllers.add(TextEditingController()),
                ),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 180),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _optionControllers.length,
              itemBuilder: (context, idx) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _optionControllers[idx],
                        decoration: InputDecoration(
                          hintText: 'optionHint'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.promoRed,
                      ),
                      onPressed: () => setState(() {
                        _optionControllers[idx].dispose();
                        _optionControllers.removeAt(idx);
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.promoRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              widget.variant == null ? 'create'.tr() : 'update'.tr(),
              style: AppTextStyle.fontWhite16Bold,
            ),
          ),
        ],
      ),
    );
  }
}
