import 'package:flutter/material.dart';
import 'package:flutter_api_rest/bloc/user_bloc.dart';
import 'package:flutter_api_rest/bloc/user_event.dart';
import 'package:flutter_api_rest/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/dialogs.dart';
import '../pages/home.dart';
import '../utils/responsive.dart';
import 'input_text.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '', _pass = '';

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive(context);

    return BlocListener<UserBloc, UserState>(listener: (context, state) {
      if (state.error == null && state.conectado) {
        Navigator.pushNamedAndRemoveUntil(
            context, Home.routeName, (_) => false);
      } if(state.error != null && !state.conectado){
        String message = 'error';
        int status = state.error!;

        if (status == -1) {
          message = 'Bad Network.';
        } else if (status == 403) {
          message = 'Invalid password.';
        } else if (status == 404) {
          message = 'User not found.';
        }

        Dialogs.alert(context, title: 'ERROR', description: message);

      }
    }, 
    child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      return Positioned(
        bottom: 30,
        child: Container(
          constraints:
              BoxConstraints(maxWidth: responsive.isTablet ? 430 : 360),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _inputEmail(responsive),
                SizedBox(height: responsive.dp(2)),
                _inputPassword(responsive),
                SizedBox(height: responsive.dp(5)),
                _buttonLogin(responsive),
                SizedBox(height: responsive.dp(3)),
                _buttonRegister(responsive),
                SizedBox(height: responsive.dp(10)),
              ],
            ),
          ),
        ),
      );
    }));
  }

  Row _buttonRegister(Responsive responsive) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('New to Friendly Desi?',
          style: TextStyle(fontSize: responsive.dp(1.5))),
      TextButton(
          onPressed: () => Navigator.pushNamed(context, 'register'),
          child: Text('Sign up',
              style: TextStyle(
                  color: Colors.pinkAccent, fontSize: responsive.dp(1.5))))
    ]);
  }

  SizedBox _buttonLogin(Responsive responsive) {
    return SizedBox(
        width: double.infinity,
        child: TextButton(
            onPressed:_submit,
            child: Text('Sign in',
                style: TextStyle(
                    color: Colors.white, fontSize: responsive.dp(1.5))),
            style: TextButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(vertical: 15))));
  }

  Container _inputPassword(Responsive responsive) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        children: [
          Expanded(
              child: InputText(
                  label: 'PASSWORD',
                  obscureText: true,
                  borderEnabled: false,
                  fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.4),
                  onChange: (text) => _pass = text,
                  validator: (text) {
                    if (text!.trim().isEmpty) {
                      return 'Invalid password';
                    }
                    return null;
                  })),
          TextButton(
              onPressed: () {},
              child: Text('Forgot Password',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                      color: Colors.black87)),
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10)))
        ],
      ),
    );
  }

  InputText _inputEmail(Responsive responsive) {
    return InputText(
      label: 'EMAIL ADDRESS',
      keyboardType: TextInputType.emailAddress,
      fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.4),
      onChange: (text) => _email = text,
      validator: (text) {
        if (!text!.contains('@')) {
          return 'Invalid email';
        }
        return null;
      },
    );
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      ProgressDialog.show(context);
      context.read<UserBloc>().add(IniciarSesionUsuario(_email, _pass));   
      ProgressDialog.dismiss(context);
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Home()));
    }
  }
}
