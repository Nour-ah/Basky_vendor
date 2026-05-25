// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_text_styles.dart';
// import '../../../../core/translations/locale_keys.g.dart';
// import '../cubit/toggle_status_cubit.dart';
// import '../cubit/toggle_status_state.dart';
//
// class RestaurantStatusSwitch extends StatefulWidget {
//   final bool initialIsOpen;
//
//   const RestaurantStatusSwitch({
//     super.key,
//     required this.initialIsOpen,
//   });
//
//   @override
//   State<RestaurantStatusSwitch> createState() => _RestaurantStatusSwitchState();
// }
//
// class _RestaurantStatusSwitchState extends State<RestaurantStatusSwitch>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..repeat(reverse: true);
//
//     _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _pulseController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ToggleStatusCubit, ToggleStatusState>(
//       listener: (context, state) {
//         if (state is ToggleStatusError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.message),
//               backgroundColor: AppColors.error,
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         bool isOpen = widget.initialIsOpen;
//         if (state is ToggleStatusSuccess) {
//           isOpen = state.isOpen;
//         }
//
//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.primary.withValues(alpha: 0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     if (isOpen)
//                       ScaleTransition(
//                         scale: _pulseAnimation,
//                         child: Container(
//                           width: 10,
//                           height: 10,
//                           decoration: const BoxDecoration(
//                             color: AppColors.success,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColors.success,
//                                 blurRadius: 8,
//                                 spreadRadius: 2,
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     else
//                       Container(
//                         width: 10,
//                         height: 10,
//                         decoration: const BoxDecoration(
//                           color: AppColors.grey,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         isOpen
//                             ? LocaleKeys.restaurantOpen.tr()
//                             : LocaleKeys.restaurantClosed.tr(),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: AppTextStyle.fontBlack16Bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               GestureDetector(
//                 onTap: () {
//                   context.read<ToggleStatusCubit>().toggleStatus(isOpen);
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   width: 56,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     color: isOpen ? AppColors.success : AppColors.greyLight,
//                     boxShadow: isOpen
//                         ? [
//                             BoxShadow(
//                               color: AppColors.success.withValues(alpha: 0.4),
//                               blurRadius: 8,
//                               offset: const Offset(0, 2),
//                             )
//                           ]
//                         : null,
//                   ),
//                   child: Stack(
//                     children: [
//                       AnimatedPositioned(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                         top: 2,
//                         bottom: 2,
//                         left: isOpen ? 26 : 2,
//                         right: isOpen ? 2 : 26,
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: AppColors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
