import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/country_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetCountriesUseCase {
  GetCountriesUseCase(this.repository);

  final RestaurantRepository repository;

  Future<Either<Failure, List<CountryEntity>>> call() {
    return repository.getCountries();
  }
}
