import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_bloc.dart';
import 'helpers/dependency_injection.dart';
import 'pages/splash_page.dart';
import 'pages/home.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';

void main() {
  DependencyInjection.initialization();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/' :(context) => const SplashPage()
          },
        ));
  }
}
