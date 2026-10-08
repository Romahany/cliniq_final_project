import 'package:cliniq_final_project/config/base/base_response.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/register_entity/register_params.dart';
import 'package:cliniq_final_project/features/auth/domain/repo/auth_repo.dart';
import 'package:cliniq_final_project/features/auth/domain/use_case/register_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockAuthRepo;
  late RegisterUseCase registerUseCase;

  const tParams = RegisterParams(
    firstName: 'Sara',
    lastName: 'Ahmed',
    email: 'sara@test.com',
    password: 'Password@123',
    confirmPassword: 'Password@123',
    phone: '01012345678',
    gender: 'Female',
  );

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    registerUseCase = RegisterUseCase(mockAuthRepo);
  });

  group('RegisterUseCase Tests', () {
    test('should return SuccessResponce when repo returns success', () async {
      const tRegisterEntity = RegisterEntity(
        message: 'Account created successfully',
        user: UserEntity(
          id: '1',
          firstName: 'Sara',
          lastName: 'Ahmed',
          email: 'sara@test.com',
        ),
        token: 'sample_jwt_token',
      );

      when(() => mockAuthRepo.register(tParams))
          .thenAnswer((_) async => SuccessResponce(tRegisterEntity));

      final result = await registerUseCase(tParams);

      expect(result, isA<SuccessResponce<RegisterEntity>>());
      final success = result as SuccessResponce<RegisterEntity>;
      expect(success.data, equals(tRegisterEntity));
      verify(() => mockAuthRepo.register(tParams)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test('should return ErrorResponce when repo returns failure', () async {
      final tException = Exception('Email already in use');

      when(() => mockAuthRepo.register(tParams))
          .thenAnswer((_) async => ErrorResponce(tException));

      final result = await registerUseCase(tParams);

      expect(result, isA<ErrorResponce<RegisterEntity>>());
      final error = result as ErrorResponce<RegisterEntity>;
      expect(error.errorMessage, isNotEmpty);
      verify(() => mockAuthRepo.register(tParams)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });
  });
}
