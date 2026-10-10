import 'package:injectable/injectable.dart';

import '../../../../config/base/base_response.dart';
import '../entities/forget_entity/reset_passsword_entity.dart';
import '../repo/auth_repo.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepo _authRepo;

  const ResetPasswordUseCase(this._authRepo);

  Future<BaseResponce<ResetPasswordEntity>> call({
    required String email,
    required String newPassword,
    String? otp,
  }) async {
    return await _authRepo.resetPassword(
      email: email,
      newPassword: newPassword,
      otp: otp,
    );
  }
}
