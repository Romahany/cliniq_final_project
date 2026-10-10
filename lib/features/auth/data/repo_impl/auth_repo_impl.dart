import 'package:injectable/injectable.dart';

import '../../../../config/base/base_response.dart';
import '../../domain/entities/forget_entity/forget_password_entity.dart';
import '../../domain/entities/forget_entity/reset_passsword_entity.dart';
import '../../domain/entities/forget_entity/verify_otp_entity.dart';
import '../../domain/repo/auth_repo.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl();

  @override
  Future<BaseResponce<ForgetPasswordEntity>> forgotPassword(
    String email,
  ) async {
    // Simulated network delay for authentic UI reaction
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (email.trim().isEmpty) {
      return ErrorResponce(
        Exception('Email cannot be empty'),
        customMessage: 'Email is required',
      );
    }
    return SuccessResponce(
      const ForgetPasswordEntity(
        message: 'Verification code sent to your email',
        isSuccess: true,
      ),
    );
  }

  @override
  Future<BaseResponce<VerifyOtpEntity>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // Code 3159 (matching screenshot 2) or 0000 simulates an invalid OTP
    if (otp == '3159' || otp == '0000') {
      return ErrorResponce(
        Exception('Invalid code'),
        customMessage: 'Invalid code',
      );
    }
    return SuccessResponce(
      const VerifyOtpEntity(
        message: 'Code verified successfully',
        isSuccess: true,
        resetToken: 'mock_reset_token_verified',
      ),
    );
  }

  @override
  Future<BaseResponce<ResetPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
    String? otp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (newPassword.length < 8) {
      return ErrorResponce(
        Exception('Password too short'),
        customMessage: 'Password must be at least 8 characters',
      );
    }
    return SuccessResponce(
      const ResetPasswordEntity(
        message: 'Password reset successfully',
        isSuccess: true,
      ),
    );
  }

  @override
  Future<BaseResponce<ForgetPasswordEntity>> resendOtp(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return SuccessResponce(
      const ForgetPasswordEntity(
        message: 'Verification code resent successfully',
        isSuccess: true,
      ),
    );
  }
}
