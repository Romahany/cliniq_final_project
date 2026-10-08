import 'package:equatable/equatable.dart';

import '../../../domain/entities/register_entity/register_params.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitEvent extends RegisterEvent {
  final RegisterParams params;

  const RegisterSubmitEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class TogglePasswordVisibilityEvent extends RegisterEvent {
  const TogglePasswordVisibilityEvent();
}

class ToggleConfirmPasswordVisibilityEvent extends RegisterEvent {
  const ToggleConfirmPasswordVisibilityEvent();
}

class ChangeGenderEvent extends RegisterEvent {
  final String gender;

  const ChangeGenderEvent(this.gender);

  @override
  List<Object?> get props => [gender];
}

class ResetRegisterStateEvent extends RegisterEvent {
  const ResetRegisterStateEvent();
}
