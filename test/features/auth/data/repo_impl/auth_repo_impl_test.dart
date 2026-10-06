import 'package:cliniq_final_project/config/base/base_response.dart';
import 'package:cliniq_final_project/core/constants/storage_keys.dart';
import 'package:cliniq_final_project/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/login_credentials.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockSecureStorage;
  late AuthRepoImpl authRepo;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    authRepo = AuthRepoImpl(mockSecureStorage);
  });

  test(
    'login stores token and rememberedEmail when rememberMe is true',
    () async {
      const creds = LoginCredentials(
        email: 'test@cliniq.com',
        password: 'password123',
        rememberMe: true,
      );

      when(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final result = await authRepo.login(creds);

      expect(result, isA<SuccessResponce<LoginEntity>>());
      verify(
        () => mockSecureStorage.write(
          key: StorageKeys.accessToken,
          value: any(named: 'value'),
        ),
      ).called(1);
      verify(
        () => mockSecureStorage.write(
          key: StorageKeys.rememberedEmail,
          value: 'test@cliniq.com',
        ),
      ).called(1);
    },
  );

  test('login deletes rememberedEmail when rememberMe is false', () async {
    const creds = LoginCredentials(
      email: 'test@cliniq.com',
      password: 'password123',
      rememberMe: false,
    );

    when(
      () => mockSecureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockSecureStorage.delete(key: any(named: 'key')))
        .thenAnswer((_) async {});

    final result = await authRepo.login(creds);

    expect(result, isA<SuccessResponce<LoginEntity>>());
    verify(
      () => mockSecureStorage.write(
        key: StorageKeys.accessToken,
        value: any(named: 'value'),
      ),
    ).called(1);
    verify(() => mockSecureStorage.delete(key: StorageKeys.rememberedEmail))
        .called(1);
  });

  test(
    'login returns ErrorResponce if an exception occurs during storage',
    () async {
      const creds = LoginCredentials(
        email: 'test@cliniq.com',
        password: 'password123',
        rememberMe: true,
      );

      when(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(Exception('Storage error'));

      final result = await authRepo.login(creds);

      expect(result, isA<ErrorResponce<LoginEntity>>());
    },
  );
}
