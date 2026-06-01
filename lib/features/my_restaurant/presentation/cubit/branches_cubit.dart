import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_vendor_branches_usecase.dart';
import 'branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  final GetVendorBranchesUseCase getVendorBranchesUseCase;

  BranchesCubit({required this.getVendorBranchesUseCase})
      : super(BranchesInitial());

  Future<void> fetchBranches() async {
    emit(BranchesLoading());
    final result = await getVendorBranchesUseCase();
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
}
