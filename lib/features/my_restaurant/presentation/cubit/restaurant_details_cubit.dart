import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_branch_details_usecase.dart';
import 'restaurant_details_state.dart';

class RestaurantDetailsCubit extends Cubit<RestaurantDetailsState> {
  final GetBranchDetailsUseCase getBranchDetailsUseCase;

  RestaurantDetailsCubit({required this.getBranchDetailsUseCase})
      : super(RestaurantDetailsInitial());

  Future<void> fetchDetails(int branchId, {int page = 1}) async {
    emit(RestaurantDetailsLoading());
    final result = await getBranchDetailsUseCase(branchId, page: page);
    result.fold(
      (failure) => emit(RestaurantDetailsError(message: failure.message)),
      (details) {
        emit(RestaurantDetailsLoaded(
          branch: details.branch,
          products: details.products,
        ));
      },
    );
  }
}
