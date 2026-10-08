import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_response.dart';
import '../../../../../config/base/base_state.dart';
import '../../../domain/entities/register_entity/register_entity.dart';
import '../../../domain/entities/register_entity/register_params.dart';
import '../../../domain/use_case/register_use_case.dart';
import 'register_event.dart';
import 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit(this._registerUseCase) : super(const RegisterState());

  void onEvent(RegisterEvent event) {
    switch (event) {
      case RegisterSubmitEvent(:final params):
        register(params);
      case TogglePasswordVisibilityEvent():
        togglePasswordVisibility();
      case ToggleConfirmPasswordVisibilityEvent():
        toggleConfirmPasswordVisibility();
      case ChangeGenderEvent(:final gender):
        changeGender(gender);
      case ResetRegisterStateEvent():
        resetRegisterState();
    }
  }

  Future<void> register(RegisterParams params) async {
    emit(
      state.copyWith(
        registerState: const BaseState<RegisterEntity>(isLoading: true),
      ),
    );

    final response = await _registerUseCase(params);

    switch (response) {
      case SuccessResponce<RegisterEntity>(:final data):
        emit(
          state.copyWith(
            registerState: BaseState<RegisterEntity>(
              isLoading: false,
              data: data,
              errorMessage: '',
            ),
          ),
        );
      case ErrorResponce<RegisterEntity>(:final errorMessage):
        emit(
          state.copyWith(
            registerState: BaseState<RegisterEntity>(
              isLoading: false,
              errorMessage: errorMessage,
            ),
          ),
        );
    }
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  void changeGender(String gender) {
    emit(state.copyWith(selectedGender: gender));
  }

  void resetRegisterState() {
    emit(state.copyWith(registerState: const BaseState<RegisterEntity>()));
  }
}
