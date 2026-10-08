import 'package:bloc_test/bloc_test.dart';
import 'package:cliniq_final_project/config/base/base_response.dart';
import 'package:cliniq_final_project/config/base/base_state.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/register_entity/register_params.dart';
import 'package:cliniq_final_project/features/auth/domain/use_case/register_use_case.dart';
import 'package:cliniq_final_project/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:cliniq_final_project/features/auth/presentation/register/manager/register_event.dart';
import 'package:cliniq_final_project/features/auth/presentation/register/manager/register_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late MockRegisterUseCase mockRegisterUseCase;
  late RegisterCubit registerCubit;

  const tParams = RegisterParams(
    firstName: 'Sara',
    lastName: 'Ahmed',
    email: 'sara@test.com',
    password: 'Password@123',
    confirmPassword: 'Password@123',
    phone: '01012345678',
    gender: 'Female',
  );

  const tRegisterEntity = RegisterEntity(
    message: 'Registered successfully',
    user: UserEntity(id: '1', firstName: 'Sara'),
    token: 'jwt_token',
  );

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    registerCubit = RegisterCubit(mockRegisterUseCase);
  });

  tearDown(() {
    registerCubit.close();
  });

  group('RegisterCubit Tests', () {
    test('initial state is correct', () {
      expect(
        registerCubit.state,
        equals(
          const RegisterState(
            registerState: BaseState<RegisterEntity>(),
            isPasswordVisible: false,
            isConfirmPasswordVisible: false,
            selectedGender: 'Female',
            isAgreedToTerms: true,
          ),
        ),
      );
    });

    blocTest<RegisterCubit, RegisterState>(
      'emits [loading, success] when register succeeds',
      build: () {
        when(() => mockRegisterUseCase(tParams))
            .thenAnswer((_) async => SuccessResponce(tRegisterEntity));
        return registerCubit;
      },
      act: (cubit) => cubit.register(tParams),
      expect: () => [
        const RegisterState(
          registerState: BaseState<RegisterEntity>(isLoading: true),
        ),
        const RegisterState(
          registerState: BaseState<RegisterEntity>(
            isLoading: false,
            data: tRegisterEntity,
            errorMessage: '',
          ),
        ),
      ],
      verify: (_) {
        verify(() => mockRegisterUseCase(tParams)).called(1);
      },
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits [loading, failure] when register fails',
      build: () {
        when(() => mockRegisterUseCase(tParams))
            .thenAnswer((_) async => ErrorResponce(Exception('Network error')));
        return registerCubit;
      },
      act: (cubit) => cubit.register(tParams),
      expect: () => [
        const RegisterState(
          registerState: BaseState<RegisterEntity>(isLoading: true),
        ),
        predicate<RegisterState>((state) {
          return !state.registerState.isLoading &&
              state.registerState.errorMessage.isNotEmpty;
        }),
      ],
      verify: (_) {
        verify(() => mockRegisterUseCase(tParams)).called(1);
      },
    );

    blocTest<RegisterCubit, RegisterState>(
      'toggles password visibility correctly',
      build: () => registerCubit,
      act: (cubit) {
        cubit.togglePasswordVisibility();
        cubit.togglePasswordVisibility();
      },
      expect: () => [
        const RegisterState(isPasswordVisible: true),
        const RegisterState(isPasswordVisible: false),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'toggles confirm password visibility correctly',
      build: () => registerCubit,
      act: (cubit) {
        cubit.toggleConfirmPasswordVisibility();
        cubit.toggleConfirmPasswordVisibility();
      },
      expect: () => [
        const RegisterState(isConfirmPasswordVisible: true),
        const RegisterState(isConfirmPasswordVisible: false),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'changes selected gender correctly',
      build: () => registerCubit,
      act: (cubit) => cubit.changeGender('Male'),
      expect: () => [const RegisterState(selectedGender: 'Male')],
    );

    blocTest<RegisterCubit, RegisterState>(
      'resets register state correctly',
      build: () => registerCubit,
      seed: () => const RegisterState(
        registerState: BaseState<RegisterEntity>(errorMessage: 'Some error'),
      ),
      act: (cubit) => cubit.resetRegisterState(),
      expect: () => [
        const RegisterState(registerState: BaseState<RegisterEntity>()),
      ],
    );

    group('onEvent dispatching tests', () {
      blocTest<RegisterCubit, RegisterState>(
        'handles RegisterSubmitEvent via onEvent',
        build: () {
          when(() => mockRegisterUseCase(tParams))
              .thenAnswer((_) async => SuccessResponce(tRegisterEntity));
          return registerCubit;
        },
        act: (cubit) => cubit.onEvent(const RegisterSubmitEvent(tParams)),
        expect: () => [
          const RegisterState(
            registerState: BaseState<RegisterEntity>(isLoading: true),
          ),
          const RegisterState(
            registerState: BaseState<RegisterEntity>(
              isLoading: false,
              data: tRegisterEntity,
              errorMessage: '',
            ),
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'handles TogglePasswordVisibilityEvent via onEvent',
        build: () => registerCubit,
        act: (cubit) => cubit.onEvent(const TogglePasswordVisibilityEvent()),
        expect: () => [const RegisterState(isPasswordVisible: true)],
      );

      blocTest<RegisterCubit, RegisterState>(
        'handles ToggleConfirmPasswordVisibilityEvent via onEvent',
        build: () => registerCubit,
        act: (cubit) =>
            cubit.onEvent(const ToggleConfirmPasswordVisibilityEvent()),
        expect: () => [const RegisterState(isConfirmPasswordVisible: true)],
      );

      blocTest<RegisterCubit, RegisterState>(
        'handles ChangeGenderEvent via onEvent',
        build: () => registerCubit,
        act: (cubit) => cubit.onEvent(const ChangeGenderEvent('Male')),
        expect: () => [const RegisterState(selectedGender: 'Male')],
      );

      blocTest<RegisterCubit, RegisterState>(
        'handles ResetRegisterStateEvent via onEvent',
        build: () => registerCubit,
        seed: () => const RegisterState(
          registerState: BaseState<RegisterEntity>(errorMessage: 'error'),
        ),
        act: (cubit) => cubit.onEvent(const ResetRegisterStateEvent()),
        expect: () => [
          const RegisterState(registerState: BaseState<RegisterEntity>()),
        ],
      );
    });

    group('RegisterEvent equality and props', () {
      test('verifies all event props', () {
        const submit1 = RegisterSubmitEvent(tParams);
        const submit2 = RegisterSubmitEvent(tParams);
        expect(submit1, equals(submit2));
        expect(submit1.props, equals([tParams]));

        const togglePass1 = TogglePasswordVisibilityEvent();
        const togglePass2 = TogglePasswordVisibilityEvent();
        expect(togglePass1, equals(togglePass2));
        expect(togglePass1.props, isEmpty);

        const toggleConfirm1 = ToggleConfirmPasswordVisibilityEvent();
        const toggleConfirm2 = ToggleConfirmPasswordVisibilityEvent();
        expect(toggleConfirm1, equals(toggleConfirm2));
        expect(toggleConfirm1.props, isEmpty);

        const gender1 = ChangeGenderEvent('Male');
        const gender2 = ChangeGenderEvent('Male');
        expect(gender1, equals(gender2));
        expect(gender1.props, equals(['Male']));

        const reset1 = ResetRegisterStateEvent();
        const reset2 = ResetRegisterStateEvent();
        expect(reset1, equals(reset2));
        expect(reset1.props, isEmpty);
      });
    });
  });
}
