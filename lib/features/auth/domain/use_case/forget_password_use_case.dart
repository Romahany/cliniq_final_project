import 'package:injectable/injectable.dart';

import '../../../../config/base/base_response.dart';
import '../entities/forget_entity/forget_password_entity.dart';
import '../repo/auth_repo.dart';

@injectable
class ForgetPasswordUseCase {
  final AuthRepo _authRepo;

  const ForgetPasswordUseCase(this._authRepo);

  Future<BaseResponce<ForgetPasswordEntity>> call(String email) async {
    return await _authRepo.forgotPassword(email);
  }
}
