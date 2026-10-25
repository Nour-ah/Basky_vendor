import 'package:equatable/equatable.dart';

class PrescriptionAddress extends Equatable {
  final int id;
  final String address;

  const PrescriptionAddress({
    required this.id,
    required this.address,
  });

  @override
  List<Object?> get props => [id, address];
}
