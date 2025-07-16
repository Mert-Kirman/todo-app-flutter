abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  AuthAuthenticated(this.token);
}

class AuthUnauthenticated extends AuthState {}
