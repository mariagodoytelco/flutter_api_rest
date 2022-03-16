import 'package:flutter/material.dart';
import 'package:flutter_api_rest/bloc/user_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';
import '../bloc/user_state.dart';
import 'home.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const ObtenerInformacionUsuarioEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state.conectado) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Home()));
          
        } else {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
          
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
