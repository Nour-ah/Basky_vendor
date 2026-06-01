import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/variant_entity.dart';
import '../../domain/usecases/add_variant_usecase.dart';
import '../../domain/usecases/delete_variant_usecase.dart';
import '../../domain/usecases/get_variants_usecase.dart';
import '../../domain/usecases/update_variant_usecase.dart';
import 'variants_state.dart';

class VariantsCubit extends Cubit<VariantsState> {
  final GetVariantsUseCase getVariantsUseCase;
  final AddVariantUseCase addVariantUseCase;
  final UpdateVariantUseCase updateVariantUseCase;
  final DeleteVariantUseCase deleteVariantUseCase;

  List<VariantEntity> _variants = [];
  List<VariantEntity> get variants => _variants;

  VariantsCubit({
    required this.getVariantsUseCase,
    required this.addVariantUseCase,
    required this.updateVariantUseCase,
    required this.deleteVariantUseCase,
  }) : super(VariantsInitial());

  Future<void> fetchVariants() async {
    emit(VariantsLoading());
    final result = await getVariantsUseCase(NoParams());
    result.fold(
      (failure) => emit(VariantsError(failure.message)),
      (variants) {
        _variants = variants;
        if (variants.isEmpty) {
          emit(VariantsEmpty());
        } else {
          emit(VariantsLoaded(variants));
        }
      },
    );
  }

  Future<void> addVariant(String name, List<String> options) async {
    emit(VariantsSubmitting());
    final result = await addVariantUseCase(AddVariantParams(name: name, options: options));
    result.fold(
      (failure) => emit(VariantsError(failure.message)),
      (_) {
        emit(VariantsActionSuccess());
        fetchVariants();
      },
    );
  }

  Future<void> updateVariant(int id, String name, List<String> options) async {
    emit(VariantsSubmitting());
    final result = await updateVariantUseCase(UpdateVariantParams(id: id, name: name, options: options));
    result.fold(
      (failure) => emit(VariantsError(failure.message)),
      (_) {
        emit(VariantsActionSuccess());
        fetchVariants();
      },
    );
  }

  Future<void> deleteVariant(int id) async {
    emit(VariantsSubmitting());
    final result = await deleteVariantUseCase(id);
    result.fold(
      (failure) => emit(VariantsError(failure.message)),
      (_) {
        emit(VariantsActionSuccess());
        fetchVariants();
      },
    );
  }
}
