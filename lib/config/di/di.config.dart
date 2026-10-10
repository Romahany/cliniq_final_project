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
import '../../features/auth/domain/use_case/forget_password_use_case.dart'
    as _i90;
import '../../features/auth/domain/use_case/resend_otp_use_case.dart' as _i1050;
import '../../features/auth/domain/use_case/reset_password_use_case.dart'
    as _i149;
import '../../features/auth/domain/use_case/verify_otp_use_case.dart' as _i69;
import '../../features/auth/presentation/forget_password/manager/cubit/forget_password_cubit.dart'
    as _i667;
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
    gh.lazySingleton<_i170.AuthRepo>(() => const _i279.AuthRepoImpl());
    gh.factory<_i90.ForgetPasswordUseCase>(
      () => _i90.ForgetPasswordUseCase(gh<_i170.AuthRepo>()),
    );
    gh.factory<_i1050.ResendOtpUseCase>(
      () => _i1050.ResendOtpUseCase(gh<_i170.AuthRepo>()),
    );
    gh.factory<_i149.ResetPasswordUseCase>(
      () => _i149.ResetPasswordUseCase(gh<_i170.AuthRepo>()),
    );
    gh.factory<_i69.VerifyOtpUseCase>(
      () => _i69.VerifyOtpUseCase(gh<_i170.AuthRepo>()),
    );
    gh.factory<_i667.ForgetPasswordCubit>(
      () => _i667.ForgetPasswordCubit(
        gh<_i90.ForgetPasswordUseCase>(),
        gh<_i69.VerifyOtpUseCase>(),
        gh<_i149.ResetPasswordUseCase>(),
        gh<_i1050.ResendOtpUseCase>(),
      ),
    );
    return this;
  }
}

class _$DioModule extends _i977.DioModule {}

class _$SecureStorageModule extends _i327.SecureStorageModule {}
