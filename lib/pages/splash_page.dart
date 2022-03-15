import 'package:flutter/material.dart';
import 'package:flutter_api_rest/bloc/user_bloc.dart';
import 'package:flutter_api_rest/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../data/authentication_client.dart';
import 'home.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return state.conectado
              ? const Home()
              : const LoginPage();
        },
      ),
    );
  }
}
