import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/vendor_type.dart';
import '../repositories/auth_repository.dart';

class GetVendorTypesUseCase {
  final AuthRepository repository;

  GetVendorTypesUseCase(this.repository);

  Future<Either<Failure, List<VendorType>>> call() {
    return repository.getVendorTypes();
  }
}
