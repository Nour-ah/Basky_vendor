import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../my_restaurant/domain/usecases/toggle_restaurant_status_usecase.dart';
import 'toggle_status_state.dart';

class ToggleStatusCubit extends Cubit<ToggleStatusState> {
  final ToggleRestaurantStatusUseCase toggleRestaurantStatusUseCase;

  ToggleStatusCubit({
    required this.toggleRestaurantStatusUseCase,
  }) : super(ToggleStatusInitial());

  Future<void> toggleStatus(bool currentIsOpen) async {
    final newIsOpen = !currentIsOpen;
    
    // Optimistically update the UI to the new state
    emit(ToggleStatusSuccess(newIsOpen));

    final result = await toggleRestaurantStatusUseCase();

    result.fold(
      (failure) {
        // Emit error state and revert back to the original state
        emit(ToggleStatusError(failure.message));
        emit(ToggleStatusSuccess(currentIsOpen));
      },
      (updatedIsOpen) {
        // Update the state with the actual value returned from backend
        emit(ToggleStatusSuccess(updatedIsOpen));
      },
    );
  }
}
