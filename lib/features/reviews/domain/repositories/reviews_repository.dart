import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/review_entity.dart';

abstract class ReviewsRepository {
  Future<Either<Failure, ReviewsSummaryEntity>> getRatings();
}
