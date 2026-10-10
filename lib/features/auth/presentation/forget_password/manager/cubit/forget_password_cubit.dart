import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../config/base/base_response.dart';
import '../../../../domain/use_case/forget_password_use_case.dart';
import '../../../../domain/use_case/resend_otp_use_case.dart';
import '../../../../domain/use_case/reset_password_use_case.dart';
import '../../../../domain/use_case/verify_otp_use_case.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ResendOtpUseCase _resendOtpUseCase;

  ForgetPasswordCubit(
    this._forgetPasswordUseCase,
    this._verifyOtpUseCase,
    this._resetPasswordUseCase,
    this._resendOtpUseCase,
  ) : super(const ForgetPasswordState());

  Future<void> doAction(ForgetPasswordAction action) async {
    switch (action) {
      case SubmitEmailAction():
        await _submitEmail(action);
      case OtpChangedAction():
        _onOtpChanged(action);
      case VerifyOtpAction():
        await _verifyOtp(action);
      case ResendOtpAction():
        await _resendOtp();
      case ResetPasswordAction():
        await _resetPassword(action);
      case ToggleNewPasswordVisibilityAction():
        _toggleNewPasswordVisibility();
      case ToggleConfirmPasswordVisibilityAction():
        _toggleConfirmPasswordVisibility();
      case ClearErrorAction():
        _clearError();
      case ResetFlowAction():
        _resetFlow();
    }
  }

  Future<void> _submitEmail(SubmitEmailAction action) async {
    emit(
      state.copyWith(
        isLoading: true,
        isEmailSent: false,
        clearError: true,
        email: action.email.trim(),
      ),
    );

    final response = await _forgetPasswordUseCase(action.email.trim());
    switch (response) {
      case SuccessResponce():
        emit(
          state.copyWith(
            isLoading: false,
            isEmailSent: true,
            statusMessage: response.data.message,
          ),
        );
      case ErrorResponce():
        emit(
          state.copyWith(
            isLoading: false,
            isEmailSent: false,
            errorMessage: response.errorMessage,
          ),
        );
    }
  }

  void _onOtpChanged(OtpChangedAction action) {
    if (state.isOtpInvalid) {
      emit(
        state.copyWith(otp: action.otp, isOtpInvalid: false, clearError: true),
      );
    } else {
      emit(state.copyWith(otp: action.otp));
    }
  }

  Future<void> _verifyOtp(VerifyOtpAction action) async {
    final cleanOtp = action.otp.trim();
    emit(
      state.copyWith(
        isLoading: true,
        isOtpVerified: false,
        isOtpInvalid: false,
        clearError: true,
        otp: cleanOtp,
      ),
    );

    final response = await _verifyOtpUseCase(email: state.email, otp: cleanOtp);

    switch (response) {
      case SuccessResponce():
        emit(
          state.copyWith(
            isLoading: false,
            isOtpVerified: true,
            isOtpInvalid: false,
            resetToken: response.data.resetToken,
            statusMessage: response.data.message,
          ),
        );
      case ErrorResponce():
        emit(
          state.copyWith(
            isLoading: false,
            isOtpVerified: false,
            isOtpInvalid: true,
            errorMessage: response.errorMessage,
          ),
        );
    }
  }

  Future<void> _resendOtp() async {
    emit(
      state.copyWith(isLoading: true, isOtpInvalid: false, clearError: true),
    );

    final response = await _resendOtpUseCase(state.email);
    switch (response) {
      case SuccessResponce():
        emit(
          state.copyWith(
            isLoading: false,
            statusMessage: response.data.message,
          ),
        );
      case ErrorResponce():
        emit(
          state.copyWith(isLoading: false, errorMessage: response.errorMessage),
        );
    }
  }

  Future<void> _resetPassword(ResetPasswordAction action) async {
    if (action.newPassword != action.confirmPassword) {
      emit(state.copyWith(errorMessage: 'Passwords do not match'));
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        isPasswordResetSuccess: false,
        clearError: true,
        newPassword: action.newPassword,
        confirmPassword: action.confirmPassword,
      ),
    );

    final response = await _resetPasswordUseCase(
      email: state.email,
      newPassword: action.newPassword,
      otp: state.otp,
    );

    switch (response) {
      case SuccessResponce():
        emit(
          state.copyWith(
            isLoading: false,
            isPasswordResetSuccess: true,
            statusMessage: response.data.message,
          ),
        );
      case ErrorResponce():
        emit(
          state.copyWith(
            isLoading: false,
            isPasswordResetSuccess: false,
            errorMessage: response.errorMessage,
          ),
        );
    }
  }

  void _toggleNewPasswordVisibility() {
    emit(state.copyWith(isNewPasswordObscured: !state.isNewPasswordObscured));
  }

  void _toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(
        isConfirmPasswordObscured: !state.isConfirmPasswordObscured,
      ),
    );
  }

  void _clearError() {
    emit(state.copyWith(clearError: true, isOtpInvalid: false));
  }

  void _resetFlow() {
    emit(const ForgetPasswordState());
  }
}
