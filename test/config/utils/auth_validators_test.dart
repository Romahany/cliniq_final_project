import 'package:cliniq_final_project/config/utils/auth_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_helper.dart';

void main() {
  group('AuthValidators - Pure Helpers', () {
    test('isValidEmail returns true for valid emails', () {
      expect(AuthValidators.isValidEmail('test@example.com'), isTrue);
      expect(AuthValidators.isValidEmail('user.name@domain.co'), isTrue);
      expect(AuthValidators.isValidEmail('john_doe@clinic.org'), isTrue);
    });

    test('isValidEmail returns false for invalid emails', () {
      expect(AuthValidators.isValidEmail(null), isFalse);
      expect(AuthValidators.isValidEmail(''), isFalse);
      expect(AuthValidators.isValidEmail('   '), isFalse);
      expect(AuthValidators.isValidEmail('plainaddress'), isFalse);
      expect(AuthValidators.isValidEmail('@missingusername.com'), isFalse);
      expect(AuthValidators.isValidEmail('user@.com'), isFalse);
    });

    test('isValidPassword checks minimum length correctly', () {
      expect(AuthValidators.isValidPassword(null), isFalse);
      expect(AuthValidators.isValidPassword(''), isFalse);
      expect(AuthValidators.isValidPassword('1234567'), isFalse);
      expect(AuthValidators.isValidPassword('12345678'), isTrue);
      expect(AuthValidators.isValidPassword('longpassword123'), isTrue);
    });
  });

  group('AuthValidators - Localized Validators', () {
    testWidgets(
      'email validator with context returns correct localized errors',
      (tester) async {
        late BuildContext buildContext;

        await tester.pumpWidget(
          createTestableWidget(
            child: Builder(
              builder: (context) {
                buildContext = context;
                return const SizedBox();
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Empty or null
        expect(AuthValidators.email(null, buildContext), 'Email is required');
        expect(AuthValidators.email('', buildContext), 'Email is required');
        expect(AuthValidators.email('   ', buildContext), 'Email is required');

        // Invalid format matches exact design error message
        expect(
          AuthValidators.email('invalid-email', buildContext),
          'This Email is not valid',
        );

        // Valid email
        expect(AuthValidators.email('valid@email.com', buildContext), isNull);
      },
    );

    testWidgets('password validator returns correct localized errors', (
      tester,
    ) async {
      late BuildContext buildContext;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              buildContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        AuthValidators.password(null, buildContext),
        'Password is required',
      );
      expect(AuthValidators.password('', buildContext), 'Password is required');
      expect(
        AuthValidators.password('12345', buildContext),
        'Password must be at least 8 characters',
      );
      expect(AuthValidators.password('12345678', buildContext), isNull);
    });

    testWidgets('strongPassword validator checks rules', (tester) async {
      late BuildContext buildContext;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              buildContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        AuthValidators.strongPassword(null, buildContext),
        'Password is required',
      );
      expect(
        AuthValidators.strongPassword('simplepassword', buildContext),
        'Password must contain uppercase, lowercase, number and special character',
      );
      expect(AuthValidators.strongPassword('Pass@1234', buildContext), isNull);
    });

    testWidgets('confirmPassword validator checks match', (tester) async {
      late BuildContext buildContext;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              buildContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        AuthValidators.confirmPassword(null, 'Pass@123', buildContext),
        'Please confirm your password',
      );
      expect(
        AuthValidators.confirmPassword('Mismatch@1', 'Pass@123', buildContext),
        'Passwords do not match',
      );
      expect(
        AuthValidators.confirmPassword('Pass@123', 'Pass@123', buildContext),
        isNull,
      );
    });

    testWidgets('username, names, and phone validators work properly', (
      tester,
    ) async {
      late BuildContext buildContext;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              buildContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Username
      expect(
        AuthValidators.username(null, buildContext),
        'Username is required',
      );
      expect(
        AuthValidators.username('ab', buildContext),
        'Username must be at least 3 characters',
      );
      expect(AuthValidators.username('john_doe', buildContext), isNull);

      // First Name
      expect(
        AuthValidators.firstName(null, buildContext),
        'First name is required',
      );
      expect(
        AuthValidators.firstName('John123', buildContext),
        'First name must contain only letters',
      );
      expect(AuthValidators.firstName('John', buildContext), isNull);

      // Last Name
      expect(
        AuthValidators.lastName(null, buildContext),
        'Last name is required',
      );
      expect(
        AuthValidators.lastName('Doe1', buildContext),
        'Last name must contain only letters',
      );
      expect(AuthValidators.lastName('Doe', buildContext), isNull);

      // Phone
      expect(
        AuthValidators.phone(null, buildContext),
        'Phone number is required',
      );
      expect(
        AuthValidators.phone('12345', buildContext),
        'Enter a valid Egyptian phone number',
      );
      expect(AuthValidators.phone('01012345678', buildContext), isNull);
    });
  });
}
