import 'package:injectable/injectable.dart';

import '../../../../config/base/base_response.dart';
import '../entities/login_entity/login_credentials.dart';
import '../entities/login_entity/login_entity.dart';
import '../repo/auth_repo.dart';

@injectable
class LoginUseCase {
  final AuthRepo _authRepo;

  const LoginUseCase(this._authRepo);

  Future<BaseResponce<LoginEntity>> call(LoginCredentials credentials) {
    return _authRepo.login(credentials);
  }
}
