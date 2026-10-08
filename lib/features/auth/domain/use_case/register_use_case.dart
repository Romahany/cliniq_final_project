import 'package:injectable/injectable.dart';

import '../../../../config/base/base_response.dart';
import '../entities/register_entity/register_entity.dart';
import '../entities/register_entity/register_params.dart';
import '../repo/auth_repo.dart';

@injectable
class RegisterUseCase {
  final AuthRepo _authRepo;

  const RegisterUseCase(this._authRepo);

  Future<BaseResponce<RegisterEntity>> call(RegisterParams params) {
    return _authRepo.register(params);
  }
}
