import 'package:cliniq_final_project/config/base/base_state.dart';
import 'package:cliniq_final_project/config/routing/routes.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:cliniq_final_project/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:cliniq_final_project/features/auth/presentation/login/manager/login_state.dart';
import 'package:cliniq_final_project/features/auth/presentation/login/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_helper.dart';

class MockLoginCubit extends Mock implements LoginCubit {}

void main() {
  late MockLoginCubit mockLoginCubit;

  setUp(() {
    mockLoginCubit = MockLoginCubit();
    when(() => mockLoginCubit.state).thenReturn(const LoginState());
    when(() => mockLoginCubit.stream)
        .thenAnswer((_) => Stream.value(const LoginState()));
    when(() => mockLoginCubit.close()).thenAnswer((_) async {});
  });

  Widget buildLoginWidget({LoginCubit? cubit, RouteFactory? onGenerateRoute}) {
    return createTestableWidget(
      onGenerateRoute: onGenerateRoute,
      child: LoginView(cubit: cubit ?? mockLoginCubit),
    );
  }

  testWidgets(
    'renders all visual elements on LoginView according to MD3 specs',
    (tester) async {
      await tester.pumpWidget(buildLoginWidget());
      await tester.pumpAndSettle();

      // Verify Title and Back Button
      expect(find.text('Login'), findsNWidgets(2)); // Header + Button text
      expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);

      // Verify Email Field
      expect(find.byKey(const Key('login_email_field')), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);

      // Verify Password Field
      expect(find.byKey(const Key('login_password_field')), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
      expect(
        find.byKey(const Key('login_password_visibility_button')),
        findsOneWidget,
      );

      // Verify Remember Me and Forgot Password
      expect(
        find.byKey(const Key('login_remember_me_checkbox')),
        findsOneWidget,
      );
      expect(find.text('Remember me'), findsOneWidget);
      expect(
        find.byKey(const Key('login_forgot_password_button')),
        findsOneWidget,
      );
      expect(find.text('Forget password?'), findsOneWidget);

      // Verify Buttons
      expect(find.byKey(const Key('login_submit_button')), findsOneWidget);
      expect(find.byKey(const Key('login_guest_button')), findsOneWidget);
      expect(find.text('Continue as guest'), findsOneWidget);

      // Verify Bottom Sign Up Link
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.byKey(const Key('login_signup_link')), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    },
  );

  testWidgets('toggles password visibility when eye icon button is tapped', (
    tester,
  ) async {
    when(() => mockLoginCubit.togglePasswordVisibility()).thenReturn(null);

    await tester.pumpWidget(buildLoginWidget());
    await tester.pumpAndSettle();

    final visibilityButton = find.byKey(
      const Key('login_password_visibility_button'),
    );
    expect(visibilityButton, findsOneWidget);

    await tester.tap(visibilityButton);
    await tester.pump();

    verify(() => mockLoginCubit.togglePasswordVisibility()).called(1);
  });

  testWidgets('toggles remember me when checkbox is tapped', (tester) async {
    when(() => mockLoginCubit.toggleRememberMe(any())).thenReturn(null);

    await tester.pumpWidget(buildLoginWidget());
    await tester.pumpAndSettle();

    final checkbox = find.byKey(const Key('login_remember_me_checkbox'));
    await tester.tap(checkbox);
    await tester.pump();

    verify(() => mockLoginCubit.toggleRememberMe(true)).called(1);
  });

  testWidgets('shows validation errors when fields are empty upon submitting', (
    tester,
  ) async {
    await tester.pumpWidget(buildLoginWidget());
    await tester.pumpAndSettle();

    final loginButton = find.byKey(const Key('login_submit_button'));
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

    verifyNever(
      () => mockLoginCubit.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('shows "This Email is not valid" when email format is invalid', (
    tester,
  ) async {
    await tester.pumpWidget(buildLoginWidget());
    await tester.pumpAndSettle();

    final emailField = find.byKey(const Key('login_email_field'));
    await tester.enterText(emailField, 'invalid-email');

    final passwordField = find.byKey(const Key('login_password_field'));
    await tester.enterText(passwordField, '12345678');

    final loginButton = find.byKey(const Key('login_submit_button'));
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verify exact design error message matching Image 2
    expect(find.text('This Email is not valid'), findsOneWidget);

    verifyNever(
      () => mockLoginCubit.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('calls login when valid email and password are submitted', (
    tester,
  ) async {
    when(
      () => mockLoginCubit.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});

    await tester.pumpWidget(buildLoginWidget());
    await tester.pumpAndSettle();

    final emailField = find.byKey(const Key('login_email_field'));
    await tester.enterText(emailField, 'doctor@cliniq.com');

    final passwordField = find.byKey(const Key('login_password_field'));
    await tester.enterText(passwordField, 'Password123');

    final loginButton = find.byKey(const Key('login_submit_button'));
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    verify(
      () => mockLoginCubit.login(
        email: 'doctor@cliniq.com',
        password: 'Password123',
      ),
    ).called(1);
  });

  testWidgets(
    'displays loading spinner on login button when isLoading is true',
    (tester) async {
      const loadingState = LoginState(
        loginState: BaseState<LoginEntity>(isLoading: true),
      );
      when(() => mockLoginCubit.state).thenReturn(loadingState);
      when(() => mockLoginCubit.stream)
          .thenAnswer((_) => Stream.value(loadingState));

      await tester.pumpWidget(buildLoginWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('shows SnackBar when state has errorMessage', (tester) async {
    when(() => mockLoginCubit.stream).thenAnswer(
      (_) => Stream.value(
        const LoginState(
          loginState: BaseState<LoginEntity>(
            errorMessage: 'Invalid credentials. Please try again.',
          ),
        ),
      ),
    );

    await tester.pumpWidget(buildLoginWidget());
    await tester.pumpAndSettle();

    expect(find.text('Invalid credentials. Please try again.'), findsOneWidget);
  });

  testWidgets('navigates to forgot password screen when link is tapped', (
    tester,
  ) async {
    bool navigated = false;

    await tester.pumpWidget(
      buildLoginWidget(
        onGenerateRoute: (settings) {
          if (settings.name == Routes.forgotPassword) {
            navigated = true;
            return MaterialPageRoute(
              builder: (_) =>
                  const Scaffold(body: Text('Forgot Password Screen')),
            );
          }
          return null;
        },
      ),
    );
    await tester.pumpAndSettle();

    final forgotBtn = find.byKey(const Key('login_forgot_password_button'));
    await tester.tap(forgotBtn);
    await tester.pumpAndSettle();

    expect(navigated, isTrue);
  });

  testWidgets('navigates to sign up screen when link is tapped', (
    tester,
  ) async {
    bool navigated = false;

    await tester.pumpWidget(
      buildLoginWidget(
        onGenerateRoute: (settings) {
          if (settings.name == Routes.signUp) {
            navigated = true;
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Sign Up Screen')),
            );
          }
          return null;
        },
      ),
    );
    await tester.pumpAndSettle();

    final signupLink = find.byKey(const Key('login_signup_link'));
    await tester.tap(signupLink);
    await tester.pumpAndSettle();

    expect(navigated, isTrue);
  });

  testWidgets('guest button triggers action without error', (tester) async {
    await tester.pumpWidget(buildLoginWidget());
    await tester.pumpAndSettle();

    final guestBtn = find.byKey(const Key('login_guest_button'));
    await tester.tap(guestBtn);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_guest_button')), findsOneWidget);
  });

  testWidgets('back button pops when navigator can pop', (tester) async {
    bool popped = false;
    await tester.pumpWidget(
      createTestableWidget(
        child: Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (navContext) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.of(navContext)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => LoginView(cubit: mockLoginCubit),
                          ),
                        )
                        .then((_) => popped = true);
                  },
                  child: const Text('Open Login'),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Open login
    await tester.tap(find.text('Open Login'));
    await tester.pumpAndSettle();

    // Tap back button
    final backBtn = find.bySemanticsLabel('Back');
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    expect(popped, isTrue);
  });
}
