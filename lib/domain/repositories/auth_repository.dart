import 'package:dartz/dartz.dart';
import 'package:salon_master/core/errors/failures.dart';
import 'package:salon_master/data/models/auth_response_model.dart';
import 'package:salon_master/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponseModel>> login(String email, String password);
  Future<Either<Failure, AuthResponseModel>> register(UserModel user);
}