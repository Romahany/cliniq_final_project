import 'package:injectable/injectable.dart';

import '../../../../config/base/base_response.dart';
import '../entities/forget_entity/verify_otp_entity.dart';
import '../repo/auth_repo.dart';

@injectable
class VerifyOtpUseCase {
  final AuthRepo _authRepo;

  const VerifyOtpUseCase(this._authRepo);

  Future<BaseResponce<VerifyOtpEntity>> call({
    required String email,
    required String otp,
  }) async {
    return await _authRepo.verifyOtp(email: email, otp: otp);
  }
}
