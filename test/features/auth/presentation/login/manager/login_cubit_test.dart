import 'package:bloc_test/bloc_test.dart';
import 'package:cliniq_final_project/config/base/base_response.dart';
import 'package:cliniq_final_project/config/base/base_state.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/login_credentials.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/use_case/login_use_case.dart';
import 'package:cliniq_final_project/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:cliniq_final_project/features/auth/presentation/login/manager/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late LoginCubit loginCubit;

  setUpAll(() {
    registerFallbackValue(
      const LoginCredentials(
        email: 'fallback@cliniq.com',
        password: 'password123',
      ),
    );
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    loginCubit = LoginCubit(mockLoginUseCase);
  });

  tearDown(() {
    loginCubit.close();
  });

  const user = UserEntity(id: '1', email: 'test@cliniq.com');
  const loginEntity = LoginEntity(user: user, token: 'mock_token');

  test('initial state is LoginState default', () {
    expect(loginCubit.state, equals(const LoginState()));
  });

  blocTest<LoginCubit, LoginState>(
    'togglePasswordVisibility toggles isPasswordVisible state',
    build: () => loginCubit,
    act: (cubit) => cubit.togglePasswordVisibility(),
    expect: () => [const LoginState(isPasswordVisible: true)],
  );

  blocTest<LoginCubit, LoginState>(
    'toggleRememberMe updates rememberMe state',
    build: () => loginCubit,
    act: (cubit) => cubit.toggleRememberMe(true),
    expect: () => [const LoginState(rememberMe: true)],
  );

  blocTest<LoginCubit, LoginState>(
    'resetState emits initial LoginState',
    build: () => loginCubit,
    seed: () => const LoginState(isPasswordVisible: true, rememberMe: true),
    act: (cubit) => cubit.resetState(),
    expect: () => [const LoginState()],
  );

  blocTest<LoginCubit, LoginState>(
    'login emits loading then success state on successful use case response',
    build: () {
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => SuccessResponce(loginEntity));
      return loginCubit;
    },
    act: (cubit) =>
        cubit.login(email: 'test@cliniq.com', password: 'password123'),
    expect: () => [
      const LoginState(
        loginState: BaseState<LoginEntity>(isLoading: true, errorMessage: ''),
      ),
      const LoginState(
        loginState: BaseState<LoginEntity>(
          isLoading: false,
          data: loginEntity,
          errorMessage: '',
        ),
      ),
    ],
    verify: (_) {
      verify(() => mockLoginUseCase(any())).called(1);
    },
  );

  blocTest<LoginCubit, LoginState>(
    'login emits loading then error state on failed use case response',
    build: () {
      when(() => mockLoginUseCase(any())).thenAnswer(
        (_) async => ErrorResponce(Exception('Invalid email or password')),
      );
      return loginCubit;
    },
    act: (cubit) =>
        cubit.login(email: 'wrong@cliniq.com', password: 'password123'),
    expect: () => [
      const LoginState(
        loginState: BaseState<LoginEntity>(isLoading: true, errorMessage: ''),
      ),
      isA<LoginState>()
          .having((s) => s.loginState.isLoading, 'isLoading', isFalse)
          .having((s) => s.loginState.errorMessage, 'errorMessage', isNotEmpty),
    ],
    verify: (_) {
      verify(() => mockLoginUseCase(any())).called(1);
    },
  );
}
