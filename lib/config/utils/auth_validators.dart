import 'package:flutter/widgets.dart';

import '../../core/extensions/localization_extension.dart';

class AuthValidators {
  AuthValidators._(); // prevent instantiation

  static final RegExp _emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$');
  static final RegExp _strongPasswordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
  );
  static final RegExp _nameRegex = RegExp(r'^[a-zA-Z]{2,30}$');
  static final RegExp _egyptianPhoneRegex = RegExp(r'^01[0125][0-9]{8}$');

  /// Pure validator helper for email
  static bool isValidEmail(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    return _emailRegex.hasMatch(value.trim());
  }

  /// Pure validator helper for password
  static bool isValidPassword(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) return false;
    return value.length >= minLength;
  }

  static String? email(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.emailRequired;
    }
    if (!isValidEmail(value)) {
      return context.l10n.emailError;
    }
    return null;
  }

  static String? password(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.passwordRequired;
    }
    if (value.length < 8) {
      return context.l10n.passwordMinLength;
    }
    return null;
  }

  /// Stricter policy for creating a new password (registration / reset),
  /// as opposed to [password] which only checks an existing password is present.
  static String? strongPassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.passwordRequired;
    }
    if (!_strongPasswordRegex.hasMatch(value)) {
      return context.l10n.passwordStrongRules;
    }
    return null;
  }

  static String? confirmPassword(
    String? value,
    String original,
    BuildContext context,
  ) {
    if (value == null || value.isEmpty) {
      return context.l10n.confirmPasswordRequired;
    }
    if (value != original) {
      return context.l10n.confirmPasswordMismatch;
    }
    return null;
  }

  static String? username(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.usernameRequired;
    }
    if (value.trim().length < 3) {
      return context.l10n.usernameMinLength;
    }
    return null;
  }

  static String? firstName(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.firstNameRequired;
    }
    if (!_nameRegex.hasMatch(value.trim())) {
      return context.l10n.firstNameOnlyLetters;
    }
    return null;
  }

  static String? lastName(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.lastNameRequired;
    }
    if (!_nameRegex.hasMatch(value.trim())) {
      return context.l10n.lastNameOnlyLetters;
    }
    return null;
  }

  static String? phone(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.phoneRequired;
    }
    if (!_egyptianPhoneRegex.hasMatch(value.trim())) {
      return context.l10n.phoneInvalid;
    }
    return null;
  }
}
