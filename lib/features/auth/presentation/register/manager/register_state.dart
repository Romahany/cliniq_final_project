import 'package:equatable/equatable.dart';

import '../../../../../config/base/base_state.dart';
import '../../../domain/entities/register_entity/register_entity.dart';

class RegisterState extends Equatable {
  final BaseState<RegisterEntity> registerState;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String selectedGender;
  final bool isAgreedToTerms;

  const RegisterState({
    this.registerState = const BaseState<RegisterEntity>(),
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.selectedGender = 'Female',
    this.isAgreedToTerms = true,
  });

  RegisterState copyWith({
    BaseState<RegisterEntity>? registerState,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    String? selectedGender,
    bool? isAgreedToTerms,
  }) {
    return RegisterState(
      registerState: registerState ?? this.registerState,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      selectedGender: selectedGender ?? this.selectedGender,
      isAgreedToTerms: isAgreedToTerms ?? this.isAgreedToTerms,
    );
  }

  @override
  List<Object?> get props => [
    registerState,
    isPasswordVisible,
    isConfirmPasswordVisible,
    selectedGender,
    isAgreedToTerms,
  ];
}
