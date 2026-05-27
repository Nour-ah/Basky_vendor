import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../cubit/branches_cubit.dart';
import '../cubit/branches_state.dart';
import '../widgets/branch_card.dart';
import 'branch_details_page.dart';

class MyRestaurantPage extends StatefulWidget {
  const MyRestaurantPage({super.key});

  @override
  State<MyRestaurantPage> createState() => _MyRestaurantPageState();
}

class _MyRestaurantPageState extends State<MyRestaurantPage> {
  late final BranchesCubit _branchesCubit;

  @override
  void initState() {
    super.initState();
    _branchesCubit = sl<BranchesCubit>()..fetchBranches();
  }

  @override
  void dispose() {
    _branchesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _branchesCubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            LocaleKeys.myRestaurant.tr(),
            style: AppTextStyle.heading18Bold,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<BranchesCubit, BranchesState>(
          builder: (context, state) {
            if (state is BranchesLoading || state is BranchesInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BranchesError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTextStyle.fontRed14Bold,
                ),
              );
            }

            if (state is BranchesEmpty) {
              return Center(
                child: Text(
                  LocaleKeys.notAvailable.tr(),
                  style: AppTextStyle.fontGrey14Regular,
                ),
              );
            }

            if (state is BranchesLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  await _branchesCubit.fetchBranches();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.branches.length,
                  itemBuilder: (context, index) {
                    final branch = state.branches[index];
                    return BranchCard(
                      branch: branch,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BranchDetailsPage(branchId: branch.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
