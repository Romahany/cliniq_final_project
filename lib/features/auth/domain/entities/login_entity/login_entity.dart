import 'package:equatable/equatable.dart';

import 'user_entity.dart';

class LoginEntity extends Equatable {
  final UserEntity user;
  final String token;
  final String? refreshToken;

  const LoginEntity({
    required this.user,
    required this.token,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [user, token, refreshToken];
}
