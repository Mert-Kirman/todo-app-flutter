import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../services/auth_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final token = await AuthStorage.getToken();
      if (token != null) {
        emit(AuthAuthenticated(token));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      await AuthStorage.saveToken(event.token);
      emit(AuthAuthenticated(event.token));
    });

    on<LoggedOut>((event, emit) async {
      await AuthStorage.deleteToken();
      emit(AuthUnauthenticated());
    });
  }
}
