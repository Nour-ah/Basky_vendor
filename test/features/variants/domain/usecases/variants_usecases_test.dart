import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/core/error/failures.dart';
import 'package:spider_restaurant/core/usecases/usecase.dart';
import 'package:spider_restaurant/features/variants/domain/entities/variant_entity.dart';
import 'package:spider_restaurant/features/variants/domain/repositories/variant_repository.dart';
import 'package:spider_restaurant/features/variants/domain/usecases/add_variant_usecase.dart';
import 'package:spider_restaurant/features/variants/domain/usecases/delete_variant_usecase.dart';
import 'package:spider_restaurant/features/variants/domain/usecases/get_variants_usecase.dart';
import 'package:spider_restaurant/features/variants/domain/usecases/update_variant_usecase.dart';

class FakeVariantRepository implements VariantRepository {
  List<VariantEntity> variants = [];
  bool shouldFail = false;

  @override
  Future<Either<Failure, List<VariantEntity>>> getVariants() async {
    if (shouldFail) return const Left(ServerFailure('Server Error'));
    return Right(variants);
  }

  @override
  Future<Either<Failure, void>> addVariant(String name, List<String> options) async {
    if (shouldFail) return const Left(ServerFailure('Server Error'));
    variants.add(VariantEntity(
      id: variants.length + 1,
      name: name,
      options: options.map((o) => VariantOptionEntity(id: 1, name: o)).toList(),
    ));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateVariant(int id, String name, List<String> options) async {
    if (shouldFail) return const Left(ServerFailure('Server Error'));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteVariant(int id) async {
    if (shouldFail) return const Left(ServerFailure('Server Error'));
    return const Right(null);
  }
}

void main() {
  late FakeVariantRepository repository;
  late GetVariantsUseCase getVariantsUseCase;
  late AddVariantUseCase addVariantUseCase;
  late UpdateVariantUseCase updateVariantUseCase;
  late DeleteVariantUseCase deleteVariantUseCase;

  setUp(() {
    repository = FakeVariantRepository();
    getVariantsUseCase = GetVariantsUseCase(repository);
    addVariantUseCase = AddVariantUseCase(repository);
    updateVariantUseCase = UpdateVariantUseCase(repository);
    deleteVariantUseCase = DeleteVariantUseCase(repository);
  });

  group('Variants UseCases Tests', () {
    test('GetVariantsUseCase should return list of variants from repository', () async {
      final result = await getVariantsUseCase(NoParams());
      expect(result, isA<Right<Failure, List<VariantEntity>>>());
    });

    test('AddVariantUseCase should successfully add a variant to repository', () async {
      final result = await addVariantUseCase(const AddVariantParams(name: 'Roast', options: ['Light', 'Dark']));
      expect(result, const Right(null));
      expect(repository.variants.length, 1);
      expect(repository.variants.first.name, 'Roast');
    });

    test('UpdateVariantUseCase should call repository update', () async {
      final result = await updateVariantUseCase(const UpdateVariantParams(id: 1, name: 'Roast', options: ['Light']));
      expect(result, const Right(null));
    });

    test('DeleteVariantUseCase should call repository delete', () async {
      final result = await deleteVariantUseCase(1);
      expect(result, const Right(null));
    });
  });
}
