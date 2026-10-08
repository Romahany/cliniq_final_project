import '../../../../config/base/base_response.dart';
import '../entities/register_entity/register_entity.dart';
import '../entities/register_entity/register_params.dart';

abstract class AuthRepo {
  Future<BaseResponce<RegisterEntity>> register(RegisterParams params);
}
