import 'package:dartz/dartz.dart';
import 'package:salon_master/core/errors/failures.dart';
import 'package:salon_master/data/datasources/auth_datasource.dart';
import 'package:salon_master/data/models/auth_response_model.dart';
import 'package:salon_master/data/models/user_model.dart';
import 'package:salon_master/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, AuthResponseModel>> login(String email, String password) async {
    try {
      final response = await dataSource.login(email, password);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponseModel>> register(UserModel user) async {
    try {
      final response = await dataSource.register(user);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}