import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base/base_response.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../domain/entities/login_entity/login_credentials.dart';
import '../../domain/entities/login_entity/login_entity.dart';
import '../../domain/entities/login_entity/user_entity.dart';
import '../../domain/repo/auth_repo.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final FlutterSecureStorage _secureStorage;

  AuthRepoImpl(this._secureStorage);

  @override
  Future<BaseResponce<LoginEntity>> login(LoginCredentials credentials) async {
    try {
      final entity = LoginEntity(
        user: UserEntity(id: 'user_1', email: credentials.email),
        token: 'auth_token_${credentials.email.hashCode}',
      );

      await _secureStorage.write(
        key: StorageKeys.accessToken,
        value: entity.token,
      );

      if (credentials.rememberMe) {
        await _secureStorage.write(
          key: StorageKeys.rememberedEmail,
          value: credentials.email,
        );
      } else {
        await _secureStorage.delete(key: StorageKeys.rememberedEmail);
      }

      return SuccessResponce(entity);
    } on Exception catch (e) {
      return ErrorResponce(e);
    }
  }
}
