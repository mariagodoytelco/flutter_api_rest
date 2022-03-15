import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/register_form.dart';
import '../widgets/avatar_button.dart';
import '../utils/responsive.dart';
import '../widgets/circle.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = 'register';
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double pinkSize = responsive.wp(88);
    final double orangeSize = responsive.wp(57);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: responsive.height,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _circlePink(pinkSize),
                _circleOrange(orangeSize),
                _avatar(responsive),
                const RegisterForm(),
                _buttonBack()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buttonBack() {
    return Positioned(
        left: 15,
        top: 15,
        child: SafeArea(
          child: CupertinoButton(
            color: Colors.black26,
            padding: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(30),
            child: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ));
  }

  Positioned _avatar(Responsive responsive) {
    return Positioned(
      top: responsive.wp(80) * 0.22,
      child: Column(
        children: [
          Text(
            'Hello!\nSign up to get started',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: responsive.dp(1.6))
          ),
          SizedBox(height: responsive.dp(4.5)),
          AvatarButton(imageSize: responsive.wp(25))
        ],
      )
    );
  }

  Positioned _circleOrange(double orangeSize) {
    return Positioned(
      top: -orangeSize * 0.35,
      left: -orangeSize * 0.15,
      child: Circle(
        size: orangeSize,
        colors: const [Colors.orange, Colors.deepOrangeAccent]
      )
    );
  }

  Positioned _circlePink(double pinkSize) {
    return Positioned(
      top: -pinkSize * 0.3,
      right: -pinkSize * 0.2,
      child: Circle(
        size: pinkSize, colors: const [Colors.pinkAccent, Colors.pink]
      )
    );
  }
}
