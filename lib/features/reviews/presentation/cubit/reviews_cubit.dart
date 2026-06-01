import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_ratings_usecase.dart';
import 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final GetRatingsUseCase getRatingsUseCase;

  ReviewsCubit({required this.getRatingsUseCase}) : super(ReviewsInitial());

  Future<void> fetchReviews() async {
    if (isClosed) return;
    emit(ReviewsLoading());

    final result = await getRatingsUseCase(NoParams());
    if (isClosed) return;

    result.fold(
      (failure) => emit(ReviewsError(
        failure.message,
        isNetworkError: failure is NetworkFailure,
      )),
      (summary) {
        if (summary.reviews.isEmpty) {
          emit(ReviewsEmpty());
        } else {
          emit(ReviewsLoaded(summary));
        }
      },
    );
  }
}
