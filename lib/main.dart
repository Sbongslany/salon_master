import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salon_master/core/di/injection.dart' as di;
import 'package:salon_master/core/routing/app_router.dart';
import 'package:salon_master/presentation/blocs/auth/auth_bloc.dart';

import 'core/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<AuthBloc>()),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: appRouter,
      ),
    );
  }
}