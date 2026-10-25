import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/app_skeleton_loading.dart';
import '../../domain/entities/vendor_branch_entity.dart';
import '../cubit/branches_cubit.dart';
import '../cubit/branches_state.dart';
import '../widgets/branch_card.dart';
import 'add_branch_page.dart';
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

  Future<void> _openAddBranch([VendorBranchEntity? branch]) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddBranchPage(branch: branch),
      ),
    );
    if (saved == true && mounted) {
      await _branchesCubit.fetchBranches();
    }
  }

  Future<void> _confirmDelete(VendorBranchEntity branch) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.deleteBranch.tr()),
        content: Text(LocaleKeys.deleteBranchConfirm.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.promoRed),
            child: Text(LocaleKeys.delete.tr()),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final error = await _branchesCubit.deleteBranch(branch.id);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.promoRed),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.deletedSuccessfully.tr()),
          backgroundColor: AppColors.primary,
        ),
      );
    }
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openAddBranch(),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            LocaleKeys.addBranch.tr(),
            style: AppTextStyle.fontWhite14Regular.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<BranchesCubit, BranchesState>(
          builder: (context, state) {
            if (state is BranchesLoading || state is BranchesInitial) {
              return const BranchesListSkeleton();
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
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
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
                      onEdit: () => _openAddBranch(branch),
                      onDelete: () => _confirmDelete(branch),
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
