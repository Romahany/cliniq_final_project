// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/domain/repo/auth_repo.dart' as _i170;
import '../../features/auth/domain/use_case/register_use_case.dart' as _i463;
import '../../features/auth/presentation/register/manager/register_cubit.dart'
    as _i784;
import '../dio/dio_module.dart' as _i977;
import '../utils/secure_storage_module.dart' as _i327;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    final secureStorageModule = _$SecureStorageModule();
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => secureStorageModule.secureStorage,
    );
    gh.factory<_i463.RegisterUseCase>(
      () => _i463.RegisterUseCase(gh<_i170.AuthRepo>()),
    );
    gh.factory<_i784.RegisterCubit>(
      () => _i784.RegisterCubit(gh<_i463.RegisterUseCase>()),
    );
    return this;
  }
}

class _$DioModule extends _i977.DioModule {}

class _$SecureStorageModule extends _i327.SecureStorageModule {}
