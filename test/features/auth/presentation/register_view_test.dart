import 'package:cliniq_final_project/config/base/base_response.dart';
import 'package:cliniq_final_project/config/base/base_state.dart';
import 'package:cliniq_final_project/config/routing/routes.dart';
import 'package:cliniq_final_project/core/shared/app_widgets/custom_button.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/register_entity/register_params.dart';
import 'package:cliniq_final_project/features/auth/domain/use_case/register_use_case.dart';
import 'package:cliniq_final_project/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:cliniq_final_project/features/auth/presentation/register/view/register_view.dart';
import 'package:cliniq_final_project/features/auth/presentation/register/view/widgets/already_have_account_widget.dart';
import 'package:cliniq_final_project/features/auth/presentation/register/view/widgets/gender_selection_widget.dart';
import 'package:cliniq_final_project/features/auth/presentation/register/view/widgets/register_form.dart';
import 'package:cliniq_final_project/features/auth/presentation/register/view/widgets/register_header.dart';
import 'package:cliniq_final_project/features/auth/presentation/register/view/widgets/terms_and_conditions_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_helper.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late MockRegisterUseCase mockUseCase;
  late RegisterCubit cubit;

  setUpAll(() {
    registerFallbackValue(
      const RegisterParams(
        firstName: '',
        lastName: '',
        email: '',
        password: '',
        confirmPassword: '',
        phone: '',
        gender: '',
      ),
    );
  });

  setUp(() {
    mockUseCase = MockRegisterUseCase();
    cubit = RegisterCubit(mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  Widget buildRegisterScreen({
    RegisterCubit? testCubit,
    NavigatorObserver? observer,
    Map<String, WidgetBuilder>? routes,
  }) {
    return createTestableWidget(
      navigatorObserver: observer,
      routes: routes,
      child: RegisterView(cubit: testCubit ?? cubit),
    );
  }

  group('RegisterView Widget Tests', () {
    testWidgets('renders all screen components and initial layout', (
      tester,
    ) async {
      await tester.pumpWidget(buildRegisterScreen());
      await tester.pumpAndSettle();

      expect(find.byType(RegisterHeader), findsOneWidget);
      expect(find.byType(RegisterForm), findsOneWidget);
      expect(find.byType(GenderSelectionWidget), findsOneWidget);
      expect(find.byType(TermsAndConditionsWidget), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.byType(AlreadyHaveAccountWidget), findsOneWidget);

      expect(find.text('Sign up'), findsWidgets); // Header & Button
      expect(find.text('First name'), findsWidgets);
      expect(find.text('Last name'), findsWidgets);
      expect(find.text('Email'), findsWidgets);
      expect(find.text('Password'), findsWidgets);
      expect(find.text('Confirm password'), findsWidgets);
      expect(find.text('Phone number'), findsWidgets);
      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
    });

    testWidgets('triggers form validation on empty submit', (tester) async {
      await tester.pumpWidget(buildRegisterScreen());
      await tester.pumpAndSettle();

      // Find Sign up button and tap
      final signUpButton = find.widgetWithText(CustomButton, 'Sign up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      // Form validation errors should be displayed
      expect(find.text('First name is required'), findsOneWidget);
      expect(find.text('Last name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Phone number is required'), findsOneWidget);
    });

    testWidgets('toggles password and confirm password obscure text', (
      tester,
    ) async {
      await tester.pumpWidget(buildRegisterScreen());
      await tester.pumpAndSettle();

      // Initially visibility off icons are shown
      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));

      // Tap first eye icon (password toggle)
      await tester.tap(find.byIcon(Icons.visibility_off_outlined).first);
      await tester.pumpAndSettle();

      expect(cubit.state.isPasswordVisible, isTrue);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap second eye icon (confirm password toggle)
      await tester.tap(find.byIcon(Icons.visibility_off_outlined).first);
      await tester.pumpAndSettle();

      expect(cubit.state.isConfirmPasswordVisible, isTrue);
      expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
    });

    testWidgets('selects gender Male on radio tap', (tester) async {
      await tester.pumpWidget(buildRegisterScreen());
      await tester.pumpAndSettle();

      expect(cubit.state.selectedGender, equals('Female'));

      // Tap Male option
      await tester.tap(find.text('Male'));
      await tester.pumpAndSettle();

      expect(cubit.state.selectedGender, equals('Male'));
    });

    testWidgets('submits form successfully with valid inputs', (tester) async {
      const tEntity = RegisterEntity(
        message: 'Account created successfully',
        user: UserEntity(id: '1', firstName: 'Sara'),
      );

      when(() => mockUseCase(any()))
          .thenAnswer((_) async => SuccessResponce(tEntity));

      await tester.pumpWidget(
        buildRegisterScreen(
          routes: {
            Routes.login: (_) => const Scaffold(body: Text('Login Screen')),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Enter First Name
      await tester.enterText(
        find.widgetWithText(TextFormField, 'First name').first,
        'Sara',
      );

      // Enter Last Name
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Last name').first,
        'Ahmed',
      );

      // Enter Email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'sara@example.com',
      );

      // Enter Password (strong)
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'SecureP@ss1',
      );

      // Enter Confirm Password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm password'),
        'SecureP@ss1',
      );

      // Enter Egyptian Phone Number
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone number'),
        '01012345678',
      );

      await tester.pumpAndSettle();

      // Tap Sign up button
      final signUpButton = find.widgetWithText(CustomButton, 'Sign up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      verify(() => mockUseCase(any())).called(1);
      expect(find.text('Account created successfully'), findsOneWidget);
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('shows error SnackBar when registration fails', (tester) async {
      when(() => mockUseCase(any())).thenAnswer(
        (_) async => ErrorResponce(Exception('Email already registered')),
      );

      await tester.pumpWidget(buildRegisterScreen());
      await tester.pumpAndSettle();

      // Fill valid form
      await tester.enterText(
        find.widgetWithText(TextFormField, 'First name').first,
        'Sara',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Last name').first,
        'Ahmed',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'sara@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'SecureP@ss1',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm password'),
        'SecureP@ss1',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone number'),
        '01012345678',
      );

      await tester.pumpAndSettle();

      final signUpButton = find.widgetWithText(CustomButton, 'Sign up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets(
      'tapping already have account login button triggers navigation',
      (tester) async {
        await tester.pumpWidget(
          buildRegisterScreen(
            routes: {
              Routes.login: (_) => const Scaffold(body: Text('Login Screen')),
            },
          ),
        );
        await tester.pumpAndSettle();

        final loginLink = find.text('Login');
        await tester.ensureVisible(loginLink);
        await tester.tap(loginLink);
        await tester.pumpAndSettle();

        expect(find.text('Login Screen'), findsOneWidget);
      },
    );

    testWidgets('tapping back button pops navigation', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterView(cubit: cubit),
                    ),
                  );
                },
                child: const Text('Open Register'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Register'));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterView), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Open Register'), findsOneWidget);
    });

    testWidgets('shows loading spinner in button when state is loading', (
      tester,
    ) async {
      cubit.emit(
        cubit.state.copyWith(
          registerState: const BaseState<RegisterEntity>(isLoading: true),
        ),
      );

      await tester.pumpWidget(buildRegisterScreen());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
