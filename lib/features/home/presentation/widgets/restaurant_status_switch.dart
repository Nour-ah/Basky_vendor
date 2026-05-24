import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../cubit/toggle_status_cubit.dart';
import '../cubit/toggle_status_state.dart';

class RestaurantStatusSwitch extends StatelessWidget {
  final bool initialIsOpen;

  const RestaurantStatusSwitch({
    super.key,
    required this.initialIsOpen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToggleStatusCubit, ToggleStatusState>(
      listener: (context, state) {
        if (state is ToggleStatusError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        bool isOpen = initialIsOpen;
        if (state is ToggleStatusSuccess) {
          isOpen = state.isOpen;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isOpen
                      ? LocaleKeys.restaurantOpen.tr()
                      : LocaleKeys.restaurantClosed.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: isOpen,
                activeThumbColor: AppColors.white,
                activeTrackColor: AppColors.success,
                inactiveThumbColor: AppColors.white,
                inactiveTrackColor: AppColors.greyLight,
                onChanged: (value) {
                  context.read<ToggleStatusCubit>().toggleStatus(isOpen);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
