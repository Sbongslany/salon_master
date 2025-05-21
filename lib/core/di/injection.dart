import 'package:get_it/get_it.dart';
import 'package:salon_master/data/datasources/auth_datasource.dart';
import 'package:salon_master/data/repositories/auth_repository_impl.dart';
import 'package:salon_master/domain/repositories/auth_repository.dart';
import 'package:salon_master/domain/usecases/login_usecase.dart';
import 'package:salon_master/domain/usecases/register_usecase.dart';
import 'package:salon_master/presentation/blocs/auth/auth_bloc.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Data sources
  locator.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl());

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(dataSource: locator()),
  );

  // Use cases
  locator.registerLazySingleton(() => LoginUseCase(locator()));
  locator.registerLazySingleton(() => RegisterUseCase(locator()));

  // Blocs
  locator.registerFactory(() => AuthBloc(
    loginUseCase: locator(),
    registerUseCase: locator(),
  ));
}