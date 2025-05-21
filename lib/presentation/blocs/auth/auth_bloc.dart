import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salon_master/core/errors/failures.dart';
import 'package:salon_master/data/models/auth_response_model.dart';
import 'package:salon_master/data/models/user_model.dart';
import 'package:salon_master/domain/usecases/login_usecase.dart';
import 'package:salon_master/domain/usecases/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthBloc({required this.loginUseCase, required this.registerUseCase}) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.email, event.password);
    result.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (authResponse) => emit(AuthSuccess(authResponse)),
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(event.user);
    result.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (authResponse) => emit(AuthSuccess(authResponse)),
    );
  }
}