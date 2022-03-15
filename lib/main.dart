import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helpers/dependency_injection.dart';
import 'pages/splash_page.dart';
import 'pages/home_page.dart';
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      routes: {
        RegisterPage.routeName: (context) => const RegisterPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        HomePage.routeName: (_) => const HomePage()
      },
    );
  }
}
