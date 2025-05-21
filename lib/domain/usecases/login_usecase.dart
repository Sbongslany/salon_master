import 'package:dartz/dartz.dart';
import 'package:salon_master/core/errors/failures.dart';
import 'package:salon_master/data/models/auth_response_model.dart';
import 'package:salon_master/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthResponseModel>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}