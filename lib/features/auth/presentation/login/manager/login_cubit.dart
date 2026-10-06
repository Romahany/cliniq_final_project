import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_response.dart';
import '../../../domain/entities/login_entity/login_credentials.dart';
import '../../../domain/entities/login_entity/login_entity.dart';
import '../../../domain/use_case/login_use_case.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleRememberMe(bool? value) {
    emit(state.copyWith(rememberMe: value ?? false));
  }

  Future<void> login({required String email, required String password}) async {
    emit(
      state.copyWith(
        loginState: state.loginState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final credentials = LoginCredentials(
      email: email.trim(),
      password: password,
      rememberMe: state.rememberMe,
    );

    final result = await _loginUseCase(credentials);

    switch (result) {
      case SuccessResponce<LoginEntity>(data: final data):
        emit(
          state.copyWith(
            loginState: state.loginState.copyWith(
              isLoading: false,
              data: data,
              errorMessage: '',
            ),
          ),
        );
      case ErrorResponce<LoginEntity>(errorMessage: final errorMsg):
        emit(
          state.copyWith(
            loginState: state.loginState.copyWith(
              isLoading: false,
              errorMessage: errorMsg,
            ),
          ),
        );
    }
  }

  void resetState() {
    emit(const LoginState());
  }
}
