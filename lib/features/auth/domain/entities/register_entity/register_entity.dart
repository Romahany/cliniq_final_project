import 'package:equatable/equatable.dart';

import '../login_entity/user_entity.dart';

class RegisterEntity extends Equatable {
  final String? message;
  final UserEntity? user;
  final String? token;

  const RegisterEntity({this.message, this.user, this.token});

  @override
  List<Object?> get props => [message, user, token];
}
