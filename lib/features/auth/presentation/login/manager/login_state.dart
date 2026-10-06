import 'package:equatable/equatable.dart';

import '../../../../../config/base/base_state.dart';
import '../../../domain/entities/login_entity/login_entity.dart';

class LoginState extends Equatable {
  final BaseState<LoginEntity> loginState;
  final bool isPasswordVisible;
  final bool rememberMe;

  const LoginState({
    this.loginState = const BaseState<LoginEntity>(),
    this.isPasswordVisible = false,
    this.rememberMe = false,
  });

  LoginState copyWith({
    BaseState<LoginEntity>? loginState,
    bool? isPasswordVisible,
    bool? rememberMe,
  }) {
    return LoginState(
      loginState: loginState ?? this.loginState,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props => [loginState, isPasswordVisible, rememberMe];
}
