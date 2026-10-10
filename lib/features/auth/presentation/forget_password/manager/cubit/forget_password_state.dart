import 'package:equatable/equatable.dart';

class ForgetPasswordState extends Equatable {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  final String? resetToken;
  final bool isLoading;
  final String? errorMessage;
  final bool isOtpInvalid;
  final bool isEmailSent;
  final bool isOtpVerified;
  final bool isPasswordResetSuccess;
  final bool isNewPasswordObscured;
  final bool isConfirmPasswordObscured;
  final String? statusMessage;

  const ForgetPasswordState({
    this.email = '',
    this.otp = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.resetToken,
    this.isLoading = false,
    this.errorMessage,
    this.isOtpInvalid = false,
    this.isEmailSent = false,
    this.isOtpVerified = false,
    this.isPasswordResetSuccess = false,
    this.isNewPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
    this.statusMessage,
  });

  ForgetPasswordState copyWith({
    String? email,
    String? otp,
    String? newPassword,
    String? confirmPassword,
    String? resetToken,
    bool? isLoading,
    String? errorMessage,
    bool? isOtpInvalid,
    bool? isEmailSent,
    bool? isOtpVerified,
    bool? isPasswordResetSuccess,
    bool? isNewPasswordObscured,
    bool? isConfirmPasswordObscured,
    String? statusMessage,
    bool clearError = false,
    bool clearStatusMessage = false,
  }) {
    return ForgetPasswordState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      resetToken: resetToken ?? this.resetToken,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isOtpInvalid: isOtpInvalid ?? this.isOtpInvalid,
      isEmailSent: isEmailSent ?? this.isEmailSent,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      isPasswordResetSuccess:
          isPasswordResetSuccess ?? this.isPasswordResetSuccess,
      isNewPasswordObscured:
          isNewPasswordObscured ?? this.isNewPasswordObscured,
      isConfirmPasswordObscured:
          isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
      statusMessage: clearStatusMessage
          ? null
          : (statusMessage ?? this.statusMessage),
    );
  }

  @override
  List<Object?> get props => [
    email,
    otp,
    newPassword,
    confirmPassword,
    resetToken,
    isLoading,
    errorMessage,
    isOtpInvalid,
    isEmailSent,
    isOtpVerified,
    isPasswordResetSuccess,
    isNewPasswordObscured,
    isConfirmPasswordObscured,
    statusMessage,
  ];
}
