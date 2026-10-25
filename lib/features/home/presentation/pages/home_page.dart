import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/utils/vendor_access.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_drawer.dart';
import '../widgets/home_body_view.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..fetchHomeData(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final orderTabs = state is HomeLoaded
              ? [
                  '${LocaleKeys.readyForDelivery.tr()} (${state.stats.readyOrders})',
                  LocaleKeys.confirmedCount.tr(
                    namedArgs: {'count': '${state.stats.pendingOrders}'},
                  ),
                  LocaleKeys.cookingCount.tr(
                    namedArgs: {'count': '${state.stats.preparingOrders}'},
                  ),
                  LocaleKeys.onTheWayCount.tr(
                    namedArgs: {'count': '${state.stats.deliveredOrders}'},
                  ),
                ]
              : [
                  LocaleKeys.readyForDelivery.tr(),
                  LocaleKeys.confirmedCount.tr(namedArgs: {'count': '0'}),
                  LocaleKeys.cookingCount.tr(namedArgs: {'count': '0'}),
                  LocaleKeys.onTheWayCount.tr(namedArgs: {'count': '0'}),
                ];

          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.background,
            appBar: _buildAppBar(state),
            drawer: _buildDrawer(state),
            body: HomeBodyView(state: state, orderTabs: orderTabs),
          );
        },
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(HomeState state) {
    if (state is HomeLoaded) {
      return HomeAppBar(
        scaffoldKey: _scaffoldKey,
        userName: state.user.name,
        userAddress: state.branch?.address ?? '',
        userImageUrl: state.user.image,
      );
    }
    return HomeAppBar(scaffoldKey: _scaffoldKey, userName: '', userAddress: '');
  }

  Widget? _buildDrawer(HomeState state) {
    if (state is! HomeLoaded) return null;

    final rating = state.branch?.rating ?? 0.0;
    final image = state.user.image ?? state.branch?.logoUrl ?? '';

    return HomeDrawer(
      userName: state.user.name,
      userRating: rating,
      userImage: image,
      isPharmacyVendor: state.user.isPharmacyVendor,
      pendingPrescriptionCount: state.pendingPrescriptionCount,
    );
  }
}
