import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/review_entity.dart';
import '../repositories/reviews_repository.dart';

class GetRatingsUseCase implements UseCase<ReviewsSummaryEntity, NoParams> {
  final ReviewsRepository repository;

  GetRatingsUseCase(this.repository);

  @override
  Future<Either<Failure, ReviewsSummaryEntity>> call(NoParams params) {
    return repository.getRatings();
  }
}
