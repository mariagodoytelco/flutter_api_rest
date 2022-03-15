import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../data/authentication_client.dart';
import '../utils/dialogs.dart';
import '../api/authentication_api.dart';
import '../pages/home_page.dart';
import '../utils/responsive.dart';
import 'input_text.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _authenticationAPI = GetIt.instance<AuthenticationAPI>();
  final AuthenticationClient _authenticationClient =
      GetIt.instance<AuthenticationClient>();
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '', _pass = '';

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive(context);

    return Positioned(
      bottom: 30,
      child: Container(
        constraints: BoxConstraints(maxWidth: responsive.isTablet ? 430 : 360),
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
        onPressed: _submit,
        child: Text(
          'Sign in',
          style:
          TextStyle(color: Colors.white, fontSize: responsive.dp(1.5))
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.pink,
          padding: const EdgeInsets.symmetric(vertical: 15)
        )
      )
    );
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
              }
            )
          ),
          TextButton(
            onPressed: () {},
            child: Text('Forgot Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                color: Colors.black87
              )
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10)
            )
          )
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

  Future<void> _submit() async {
    final isOk = _formKey.currentState!.validate();
    if (isOk) {
      ProgressDialog.show(context);

      final response =
          await _authenticationAPI.login(email: _email, password: _pass);

      ProgressDialog.dismiss(context);
      if (response.data != null) {
        await _authenticationClient.saveSession(response.data!);
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (_) => false);
      } else {
        String message = response.error!.message;

        if (response.error!.statusCode == -1) {
          message = 'Bad Network.';
        } else if (response.error!.statusCode == 403) {
          message = 'Invalid password.';
        } else if (response.error!.statusCode == 404) {
          message = 'User not found.';
        }

        Dialogs.alert(context, title: 'ERROR', description: message);
      }
    }
  }
}
