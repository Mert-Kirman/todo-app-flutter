abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String token;
  LoggedIn(this.token);
}

class LoggedOut extends AuthEvent {}
