import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/delete_branch_usecase.dart';
import '../../domain/usecases/get_vendor_branches_usecase.dart';
import 'branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  BranchesCubit({
    required this.getVendorBranchesUseCase,
    required this.deleteBranchUseCase,
  }) : super(BranchesInitial());

  final GetVendorBranchesUseCase getVendorBranchesUseCase;
  final DeleteBranchUseCase deleteBranchUseCase;

  Future<void> fetchBranches() async {
    if (isClosed) return;
    emit(BranchesLoading());
    final result = await getVendorBranchesUseCase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(BranchesError(message: failure.message)),
      (branches) {
        if (branches.isEmpty) {
          emit(BranchesEmpty());
        } else {
          emit(BranchesLoaded(branches: branches));
        }
      },
    );
  }

  Future<String?> deleteBranch(int branchId) async {
    final current = state;
    final result = await deleteBranchUseCase(branchId);
    if (isClosed) return null;

    return result.fold(
      (failure) => failure.message,
      (_) {
        if (current is BranchesLoaded) {
          final remaining =
              current.branches.where((b) => b.id != branchId).toList();
          if (remaining.isEmpty) {
            emit(BranchesEmpty());
          } else {
            emit(BranchesLoaded(branches: remaining));
          }
        } else {
          fetchBranches();
        }
        return null;
      },
    );
  }
}
