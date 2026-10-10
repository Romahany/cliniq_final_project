import 'package:cliniq_final_project/core/extensions/localization_extension.dart';
import 'package:flutter/cupertino.dart';

class AuthValidators {
  AuthValidators._(); // prevent instantiation

  static String? email(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return context.l10n.emailInvalid;
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
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );
    if (!passwordRegex.hasMatch(value)) {
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
    if (!RegExp(r'^[a-zA-Z]{2,30}$').hasMatch(value)) {
      return context.l10n.firstNameOnlyLetters;
    }
    return null;
  }

  static String? lastName(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.lastNameRequired;
    }
    if (!RegExp(r'^[a-zA-Z]{2,30}$').hasMatch(value)) {
      return context.l10n.lastNameOnlyLetters;
    }
    return null;
  }

  static String? phone(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.l10n.phoneRequired;
    }
    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
      return context.l10n.phoneInvalid;
    }
    return null;
  }
}
