import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final int id;
  final String name;
  final String? code;

  const CountryEntity({
    required this.id,
    required this.name,
    this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}
