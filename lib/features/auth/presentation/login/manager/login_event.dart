sealed class LoginEvent {
  const LoginEvent();
}

final class TogglePasswordVisibilityEvent extends LoginEvent {
  const TogglePasswordVisibilityEvent();
}

final class ToggleRememberMeEvent extends LoginEvent {
  final bool? value;
  const ToggleRememberMeEvent(this.value);
}

final class SubmitLoginEvent extends LoginEvent {
  final String email;
  final String password;

  const SubmitLoginEvent({required this.email, required this.password});
}

final class ResetLoginStateEvent extends LoginEvent {
  const ResetLoginStateEvent();
}
