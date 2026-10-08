import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? gender;

  const UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, email, phone, gender];
}
