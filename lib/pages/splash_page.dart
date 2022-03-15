import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../data/authentication_client.dart';
import 'home_page.dart';
import 'login_page.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthenticationClient _authenticationClient =
      GetIt.instance<AuthenticationClient>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  Future<void> _checkLogin() async {
    final token = await _authenticationClient.accessToken;
    if (token == null) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
      return;
    }
    Navigator.pushReplacementNamed(context, HomePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
