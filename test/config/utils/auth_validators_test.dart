import 'package:cliniq_final_project/config/utils/auth_validators.dart';
import 'package:cliniq_final_project/core/extensions/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_helper.dart';

void main() {
  group('AuthValidators Tests', () {
    testWidgets('email validation', (tester) async {
      late BuildContext ctx;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      // null or empty
      expect(AuthValidators.email(null, ctx), equals(ctx.l10n.emailRequired));
      expect(AuthValidators.email('', ctx), equals(ctx.l10n.emailRequired));
      expect(AuthValidators.email('   ', ctx), equals(ctx.l10n.emailRequired));

      // invalid format
      expect(
        AuthValidators.email('plainaddress', ctx),
        equals(ctx.l10n.emailInvalid),
      );
      expect(
        AuthValidators.email('@missingusername.com', ctx),
        equals(ctx.l10n.emailInvalid),
      );
      expect(
        AuthValidators.email('user@.com', ctx),
        equals(ctx.l10n.emailInvalid),
      );

      // valid format
      expect(AuthValidators.email('user@example.com', ctx), isNull);
      expect(AuthValidators.email('sara.mohamed@cliniq.eg', ctx), isNull);
    });

    testWidgets('password validation', (tester) async {
      late BuildContext ctx;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        AuthValidators.password(null, ctx),
        equals(ctx.l10n.passwordRequired),
      );
      expect(
        AuthValidators.password('', ctx),
        equals(ctx.l10n.passwordRequired),
      );
      expect(
        AuthValidators.password('short', ctx),
        equals(ctx.l10n.passwordMinLength),
      );
      expect(AuthValidators.password('12345678', ctx), isNull);
    });

    testWidgets('strongPassword validation', (tester) async {
      late BuildContext ctx;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        AuthValidators.strongPassword(null, ctx),
        equals(ctx.l10n.passwordRequired),
      );
      expect(
        AuthValidators.strongPassword('', ctx),
        equals(ctx.l10n.passwordRequired),
      );

      // Missing uppercase, special char, etc.
      expect(
        AuthValidators.strongPassword('alllowercase1!', ctx),
        equals(ctx.l10n.passwordStrongRules),
      );
      expect(
        AuthValidators.strongPassword('ALLUPPERCASE1!', ctx),
        equals(ctx.l10n.passwordStrongRules),
      );
      expect(
        AuthValidators.strongPassword('NoSpecialChar123', ctx),
        equals(ctx.l10n.passwordStrongRules),
      );
      expect(
        AuthValidators.strongPassword('NoNumber!@#', ctx),
        equals(ctx.l10n.passwordStrongRules),
      );

      // Valid strong password
      expect(AuthValidators.strongPassword('StrongP@ss1', ctx), isNull);
      expect(AuthValidators.strongPassword('Secure@2026', ctx), isNull);
    });

    testWidgets('confirmPassword validation', (tester) async {
      late BuildContext ctx;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        AuthValidators.confirmPassword(null, 'Pass123', ctx),
        equals(ctx.l10n.confirmPasswordRequired),
      );
      expect(
        AuthValidators.confirmPassword('', 'Pass123', ctx),
        equals(ctx.l10n.confirmPasswordRequired),
      );
      expect(
        AuthValidators.confirmPassword('Pass456', 'Pass123', ctx),
        equals(ctx.l10n.confirmPasswordMismatch),
      );
      expect(AuthValidators.confirmPassword('Pass123', 'Pass123', ctx), isNull);
    });

    testWidgets('username validation', (tester) async {
      late BuildContext ctx;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        AuthValidators.username(null, ctx),
        equals(ctx.l10n.usernameRequired),
      );
      expect(
        AuthValidators.username('', ctx),
        equals(ctx.l10n.usernameRequired),
      );
      expect(
        AuthValidators.username('ab', ctx),
        equals(ctx.l10n.usernameMinLength),
      );
      expect(AuthValidators.username('abc', ctx), isNull);
      expect(AuthValidators.username('validUser', ctx), isNull);
    });

    testWidgets('firstName validation', (tester) async {
      late BuildContext ctx;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        AuthValidators.firstName(null, ctx),
        equals(ctx.l10n.firstNameRequired),
      );
      expect(
        AuthValidators.firstName('', ctx),
        equals(ctx.l10n.firstNameRequired),
      );
      expect(
        AuthValidators.firstName('Sara12', ctx),
        equals(ctx.l10n.firstNameOnlyLetters),
      );
      expect(
        AuthValidators.firstName('S', ctx),
        equals(ctx.l10n.firstNameOnlyLetters),
      );
      expect(AuthValidators.firstName('Sara', ctx), isNull);
      expect(AuthValidators.firstName('Mohamed', ctx), isNull);
    });

    testWidgets('lastName validation', (tester) async {
      late BuildContext ctx;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        AuthValidators.lastName(null, ctx),
        equals(ctx.l10n.lastNameRequired),
      );
      expect(
        AuthValidators.lastName('', ctx),
        equals(ctx.l10n.lastNameRequired),
      );
      expect(
        AuthValidators.lastName('Ali99', ctx),
        equals(ctx.l10n.lastNameOnlyLetters),
      );
      expect(
        AuthValidators.lastName('A', ctx),
        equals(ctx.l10n.lastNameOnlyLetters),
      );
      expect(AuthValidators.lastName('Ali', ctx), isNull);
      expect(AuthValidators.lastName('Hassan', ctx), isNull);
    });

    testWidgets('phone validation', (tester) async {
      late BuildContext ctx;

      await tester.pumpWidget(
        createTestableWidget(
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(AuthValidators.phone(null, ctx), equals(ctx.l10n.phoneRequired));
      expect(AuthValidators.phone('', ctx), equals(ctx.l10n.phoneRequired));

      // Invalid Egyptian phone numbers
      expect(
        AuthValidators.phone('01412345678', ctx),
        equals(ctx.l10n.phoneInvalid),
      );
      expect(
        AuthValidators.phone('0101234567', ctx),
        equals(ctx.l10n.phoneInvalid),
      );
      expect(
        AuthValidators.phone('010123456789', ctx),
        equals(ctx.l10n.phoneInvalid),
      );
      expect(
        AuthValidators.phone('02012345678', ctx),
        equals(ctx.l10n.phoneInvalid),
      );

      // Valid Egyptian prefixes (010, 011, 012, 015)
      expect(AuthValidators.phone('01012345678', ctx), isNull);
      expect(AuthValidators.phone('01112345678', ctx), isNull);
      expect(AuthValidators.phone('01212345678', ctx), isNull);
      expect(AuthValidators.phone('01512345678', ctx), isNull);
    });
  });
}
