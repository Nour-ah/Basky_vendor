import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/utils/time_slot_time_format.dart';

class TimeSlotFormSheet extends StatefulWidget {
  const TimeSlotFormSheet({
    super.key,
    required this.onSubmit,
    this.initialDay = 0,
    this.initialOpensAt = '09:00',
    this.initialClosesAt = '22:00',
    this.isEdit = false,
  });

  final ValueChanged<AddTimeSlotParams> onSubmit;
  final int initialDay;
  final String initialOpensAt;
  final String initialClosesAt;
  final bool isEdit;

  @override
  State<TimeSlotFormSheet> createState() => _TimeSlotFormSheetState();
}

class _TimeSlotFormSheetState extends State<TimeSlotFormSheet> {
  late int _selectedDay;
  late final TextEditingController _opensController;
  late final TextEditingController _closesController;

  static const _dayKeys = [
    'days.sunday',
    'days.monday',
    'days.tuesday',
    'days.wednesday',
    'days.thursday',
    'days.friday',
    'days.saturday',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDay;
    _opensController =
        TextEditingController(text: toApiTimeHi(widget.initialOpensAt));
    _closesController =
        TextEditingController(text: toApiTimeHi(widget.initialClosesAt));
  }

  @override
  void dispose() {
    _opensController.dispose();
    _closesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.isEdit ? LocaleKeys.editTimeSlot.tr() : LocaleKeys.addTimeSlot.tr(),
            style: AppTextStyle.fontBlack16Bold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<int>(
            initialValue: _selectedDay,
            decoration: InputDecoration(
              labelText: LocaleKeys.dayOfWeek.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: List.generate(
              _dayKeys.length,
              (index) => DropdownMenuItem(
                value: index,
                child: Text(_dayKeys[index].tr()),
              ),
            ),
            onChanged: (value) {
              if (value != null) setState(() => _selectedDay = value);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _opensController,
            decoration: InputDecoration(
              labelText: LocaleKeys.opensAt.tr(),
              hintText: '09:00',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _closesController,
            decoration: InputDecoration(
              labelText: LocaleKeys.closesAt.tr(),
              hintText: '22:00',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: widget.isEdit ? LocaleKeys.save.tr() : LocaleKeys.add.tr(),
            onPressed: () {
              widget.onSubmit(
                AddTimeSlotParams(
                  dayOfWeek: _selectedDay,
                  opensAt: toApiTimeHi(_opensController.text),
                  closesAt: toApiTimeHi(_closesController.text),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
