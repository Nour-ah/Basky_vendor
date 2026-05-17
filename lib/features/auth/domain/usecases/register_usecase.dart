import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<String> call({
    required String ownerName,
    required String ownerEmail,
    required String ownerPhone,
    required String ownerPassword,
    required String ownerPasswordConfirmation,
    required String restaurantNameEn,
    required String restaurantNameAr,
    required String restaurantPhone,
    required String address,
  }) {
    return repository.register(
      ownerName: ownerName,
      ownerEmail: ownerEmail,
      ownerPhone: ownerPhone,
      ownerPassword: ownerPassword,
      ownerPasswordConfirmation: ownerPasswordConfirmation,
      restaurantNameEn: restaurantNameEn,
      restaurantNameAr: restaurantNameAr,
      restaurantPhone: restaurantPhone,
      address: address,
    );
  }
}
