import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/add_branch_params.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/usecases/add_branch_usecase.dart';
import '../../domain/usecases/get_countries_usecase.dart';
import '../../domain/usecases/update_branch_usecase.dart';
import 'add_branch_state.dart';

class AddBranchCubit extends Cubit<AddBranchState> {
  AddBranchCubit({
    required this.getCountriesUseCase,
    required this.addBranchUseCase,
    required this.updateBranchUseCase,
  }) : super(AddBranchInitial());

  final GetCountriesUseCase getCountriesUseCase;
  final AddBranchUseCase addBranchUseCase;
  final UpdateBranchUseCase updateBranchUseCase;

  List<CountryEntity> _countries = const [];

  Future<void> loadForm() async {
    if (isClosed) return;
    emit(AddBranchLoadingForm());

    final result = await getCountriesUseCase();
    if (isClosed) return;

    result.fold(
      (failure) => emit(AddBranchError(failure.message)),
      (countries) {
        _countries = countries;
        emit(AddBranchFormReady(countries));
      },
    );
  }

  Future<void> submit(AddBranchParams params) async {
    if (isClosed) return;
    emit(AddBranchSubmitting(_countries));

    final result = params.isEditMode && params.branchId != null
        ? await updateBranchUseCase(
            branchId: params.branchId!,
            params: params,
          )
        : await addBranchUseCase(params);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(AddBranchValidationError(failure.errors, _countries));
        } else {
          emit(AddBranchError(failure.message, countries: _countries));
        }
      },
      (_) => emit(AddBranchSuccess()),
    );
  }
}
