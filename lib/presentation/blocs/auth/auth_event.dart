part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final UserModel user;

  const RegisterEvent(this.user);

  @override
  List<Object?> get props => [user];
}