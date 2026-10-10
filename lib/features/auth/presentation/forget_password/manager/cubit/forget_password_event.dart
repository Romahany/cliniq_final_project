sealed class ForgetPasswordAction {
  const ForgetPasswordAction();
}

final class SubmitEmailAction extends ForgetPasswordAction {
  final String email;
  const SubmitEmailAction(this.email);
}

final class OtpChangedAction extends ForgetPasswordAction {
  final String otp;
  const OtpChangedAction(this.otp);
}

final class VerifyOtpAction extends ForgetPasswordAction {
  final String otp;
  const VerifyOtpAction(this.otp);
}

final class ResendOtpAction extends ForgetPasswordAction {
  const ResendOtpAction();
}

final class ResetPasswordAction extends ForgetPasswordAction {
  final String newPassword;
  final String confirmPassword;
  const ResetPasswordAction({
    required this.newPassword,
    required this.confirmPassword,
  });
}

final class ToggleNewPasswordVisibilityAction extends ForgetPasswordAction {
  const ToggleNewPasswordVisibilityAction();
}

final class ToggleConfirmPasswordVisibilityAction extends ForgetPasswordAction {
  const ToggleConfirmPasswordVisibilityAction();
}

final class ClearErrorAction extends ForgetPasswordAction {
  const ClearErrorAction();
}

final class ResetFlowAction extends ForgetPasswordAction {
  const ResetFlowAction();
}
