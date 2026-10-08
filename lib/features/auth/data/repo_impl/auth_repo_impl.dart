import 'package:injectable/injectable.dart';

import '../../../../config/base/base_response.dart';
import '../../domain/entities/login_entity/user_entity.dart';
import '../../domain/entities/register_entity/register_entity.dart';
import '../../domain/entities/register_entity/register_params.dart';
import '../../domain/repo/auth_repo.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  @override
  Future<BaseResponce<RegisterEntity>> register(RegisterParams params) async {
    return SuccessResponce(
      RegisterEntity(
        message: 'Account created successfully',
        user: UserEntity(
          firstName: params.firstName,
          lastName: params.lastName,
          email: params.email,
          phone: params.phone,
          gender: params.gender,
        ),
        token: 'mock_token',
      ),
    );
  }
}
