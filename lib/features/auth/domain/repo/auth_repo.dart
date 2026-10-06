import '../../../../config/base/base_response.dart';
import '../entities/login_entity/login_credentials.dart';
import '../entities/login_entity/login_entity.dart';

abstract class AuthRepo {
  Future<BaseResponce<LoginEntity>> login(LoginCredentials credentials);
}
