import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../data/authentication_client.dart';
import '../pages/home.dart';
import '../api/authentication_api.dart';
import '../utils/dialogs.dart';
import '../utils/responsive.dart';
import 'input_text.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _authenticationAPI = GetIt.instance<AuthenticationAPI>();
  final AuthenticationClient _authenticationClient =
      GetIt.instance<AuthenticationClient>();
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '', _pass = '', _username = '';

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
              _inputUsername(responsive),
              SizedBox(height: responsive.dp(2)),
              _inputEmail(responsive),
              SizedBox(height: responsive.dp(2)),
              _inputPassword(responsive),
              SizedBox(height: responsive.dp(5)),
              _buttonRegister(responsive),
              SizedBox(height: responsive.dp(3)),
              _buttonLogin(responsive),
              SizedBox(height: responsive.dp(10)),
            ],
          ),
        ),
      ),
    );
  }

  Row _buttonLogin(Responsive responsive) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Already have an account?',
          style: TextStyle(fontSize: responsive.dp(1.5))),
      TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Sign in',
              style: TextStyle(
                  color: Colors.pinkAccent, fontSize: responsive.dp(1.5))))
    ]);
  }

  SizedBox _buttonRegister(Responsive responsive) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: _submit,
        child: Text(
          'Sign up',
          style: TextStyle(color: Colors.white, fontSize: responsive.dp(1.5))
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.pink,
          padding: const EdgeInsets.symmetric(vertical: 15)
        )
      )
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

  InputText _inputPassword(Responsive responsive) {
    return InputText(
        label: 'PASSWORD',
        obscureText: true,
        //borderEnabled: false,
        fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.4),
        onChange: (text) => _pass = text,
        validator: (text) {
          if (text!.trim().length < 6) {
            return 'Invalid password';
          }
          return null;
        });
  }

  _inputUsername(Responsive responsive) {
    return InputText(
      label: 'USERNAME',
      keyboardType: TextInputType.name,
      fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.4),
      onChange: (text) => _username = text,
      validator: (text) {
        if (text!.trim().length < 5) {
          return 'Invalid username';
        }
        return null;
      },
    );
  }

  Future<void> _submit() async {
    final isOk = _formKey.currentState!.validate();
    if (isOk) {
      ProgressDialog.show(context);
      
      final response = await _authenticationAPI.register(
          username: _username, email: _email, password: _pass);

      ProgressDialog.dismiss(context);
      if (response.data != null) {
        await _authenticationClient.saveSession(response.data!);
        Navigator.pushNamedAndRemoveUntil(
            context, Home.routeName, (_) => false);
      } else {
        String message = response.error!.message;

        if (response.error!.statusCode == -1) {
          message = 'Bad Network.';
        } else if (response.error!.statusCode == 409) {
          message = 'Duplicate user in: ${jsonEncode(response.error!.data["duplicatedFields"])}';
        }

        Dialogs.alert(context, title: 'ERROR', description: message);
      }
    }
  }
}
