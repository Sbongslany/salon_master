import 'package:dartz/dartz.dart';
import 'package:salon_master/core/errors/failures.dart';
import 'package:salon_master/data/models/auth_response_model.dart';
import 'package:salon_master/data/models/user_model.dart';

import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, AuthResponseModel>> call(UserModel user) async {
    return await repository.register(user);
  }
}