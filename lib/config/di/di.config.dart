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

import '../../features/auth/data/repo_impl/auth_repo_impl.dart' as _i279;
import '../../features/auth/domain/repo/auth_repo.dart' as _i170;
import '../../features/auth/domain/use_case/login_use_case.dart' as _i973;
import '../../features/auth/presentation/login/manager/login_cubit.dart'
    as _i889;
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
    gh.lazySingleton<_i170.AuthRepo>(
      () => _i279.AuthRepoImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i973.LoginUseCase>(
      () => _i973.LoginUseCase(gh<_i170.AuthRepo>()),
    );
    gh.factory<_i889.LoginCubit>(
      () => _i889.LoginCubit(gh<_i973.LoginUseCase>()),
    );
    return this;
  }
}

class _$DioModule extends _i977.DioModule {}

class _$SecureStorageModule extends _i327.SecureStorageModule {}
