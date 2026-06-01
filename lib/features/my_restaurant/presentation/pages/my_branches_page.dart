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

class MyBranchesPage extends StatefulWidget {
  const MyBranchesPage({super.key});

  @override
  State<MyBranchesPage> createState() => _MyBranchesPageState();
}

class _MyBranchesPageState extends State<MyBranchesPage> {
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
            LocaleKeys.myBranches.tr(),
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
              return _MessageState(
                icon: Icons.error_outline,
                message: state.message,
                onRetry: _branchesCubit.fetchBranches,
              );
            }

            if (state is BranchesEmpty) {
              return _MessageState(
                icon: Icons.store_mall_directory_outlined,
                message: LocaleKeys.noBranchesFound.tr(),
                onRetry: _branchesCubit.fetchBranches,
              );
            }

            if (state is BranchesLoaded) {
              return RefreshIndicator(
                onRefresh: _branchesCubit.fetchBranches,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: state.branches.length + 1,
                  separatorBuilder: (_, index) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          LocaleKeys.myBranchesSubtitle.tr(),
                          style: AppTextStyle.fontGrey14Regular,
                        ),
                      );
                    }
                    final branch = state.branches[index - 1];
                    return BranchCard(
                      branch: branch,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BranchDetailsPage(branchId: branch.id),
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

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: AppColors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.fontGrey14Regular,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(LocaleKeys.retry.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
