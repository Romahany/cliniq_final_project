import 'package:cliniq_final_project/config/base/base_response.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/login_credentials.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/repo/auth_repo.dart';
import 'package:cliniq_final_project/features/auth/domain/use_case/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockAuthRepo;
  late LoginUseCase loginUseCase;

  setUpAll(() {
    registerFallbackValue(
      const LoginCredentials(
        email: 'fallback@cliniq.com',
        password: 'password123',
      ),
    );
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    loginUseCase = LoginUseCase(mockAuthRepo);
  });

  const credentials = LoginCredentials(
    email: 'test@cliniq.com',
    password: 'password123',
    rememberMe: true,
  );

  const loginEntity = LoginEntity(
    user: UserEntity(id: '1', email: 'test@cliniq.com'),
    token: 'jwt_token',
  );

  test('calls AuthRepo.login and returns SuccessResponce on success', () async {
    when(() => mockAuthRepo.login(credentials))
        .thenAnswer((_) async => SuccessResponce(loginEntity));

    final result = await loginUseCase(credentials);

    expect(result, isA<SuccessResponce<LoginEntity>>());
    final success = result as SuccessResponce<LoginEntity>;
    expect(success.data, equals(loginEntity));
    verify(() => mockAuthRepo.login(credentials)).called(1);
  });

  test('calls AuthRepo.login and returns ErrorResponce on failure', () async {
    final exception = Exception('Invalid credentials');
    when(() => mockAuthRepo.login(credentials))
        .thenAnswer((_) async => ErrorResponce(exception));

    final result = await loginUseCase(credentials);

    expect(result, isA<ErrorResponce<LoginEntity>>());
    verify(() => mockAuthRepo.login(credentials)).called(1);
  });
}
