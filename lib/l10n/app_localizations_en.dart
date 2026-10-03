// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get emailError => 'This Email is not valid';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get passwordError => 'Invalid password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgetPassword => 'Forget password?';

  @override
  String get loginButton => 'Login';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get firstNameLabel => 'First name';

  @override
  String get firstNameHint => 'Enter first name';

  @override
  String get lastNameLabel => 'Last name';

  @override
  String get lastNameHint => 'Enter last name';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Confirm password';

  @override
  String get phoneNumberLabel => 'Phone number';

  @override
  String get phoneNumberHint => 'Enter phone number';

  @override
  String get genderTitle => 'Gender';

  @override
  String get female => 'Female';

  @override
  String get male => 'Male';

  @override
  String get termsPrefix => 'Creating an account, you agree to our ';

  @override
  String get termsLink => 'Terms&Conditions';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get passwordAppBarTitle => 'Password';

  @override
  String get forgetPasswordHeader => 'Forget password';

  @override
  String get forgetPasswordSubtitle =>
      'Please enter your email associated to your account';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get emailVerificationTitle => 'Email verification';

  @override
  String get emailVerificationSubtitle =>
      'Please enter your code that send to your email address';

  @override
  String get invalidCodeError => 'Invalid code';

  @override
  String get didntReceiveCode => 'Didn\'t receive code? ';

  @override
  String get resendLink => 'Resend';

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get resetPasswordSubtitle =>
      'Password must not be empty and must contain\n 6 characters with upper case letter and one\n number at least';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get floweryAppbarTitle => 'Flowery';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get passwordStrongRules =>
      'Password must contain uppercase, lowercase, number and special character';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get confirmPasswordMismatch => 'Passwords do not match';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get usernameMinLength => 'Username must be at least 3 characters';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get firstNameOnlyLetters => 'First name must contain only letters';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get lastNameOnlyLetters => 'Last name must contain only letters';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid => 'Enter a valid Egyptian phone number';

  @override
  String get registerError => 'Failed register';

  @override
  String get registerSuccess => 'Register successful';
}
