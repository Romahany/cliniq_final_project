import '../../../../config/base/base_response.dart';
import '../entities/forget_entity/forget_password_entity.dart';
import '../entities/forget_entity/reset_passsword_entity.dart';
import '../entities/forget_entity/verify_otp_entity.dart';

abstract class AuthRepo {
  Future<BaseResponce<ForgetPasswordEntity>> forgotPassword(String email);

  Future<BaseResponce<VerifyOtpEntity>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<BaseResponce<ResetPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
    String? otp,
  });

  Future<BaseResponce<ForgetPasswordEntity>> resendOtp(String email);
}
