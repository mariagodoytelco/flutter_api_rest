import 'package:flutter/material.dart';

import '../widgets/login_form.dart';
import '../utils/responsive.dart';
import '../widgets/circle.dart';
import '../widgets/icon_container.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    final double pinkSize = responsive.wp(80);
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
                _logo(responsive),
                const LoginForm()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned _logo(Responsive responsive) {
    return Positioned(
        top: responsive.wp(80) * 0.35,
        child: Column(
          children: [
            IconContainer(size: responsive.wp(20)),
            SizedBox(height: responsive.dp(3)),
            Text(
              'Hello Again\nWelcome back!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: responsive.dp(1.6)),
            )
          ],
        ));
  }

  Positioned _circleOrange(double orangeSize) {
    return Positioned(
        top: -orangeSize * 0.55,
        left: -orangeSize * 0.15,
        child: Circle(
            size: orangeSize,
            colors: const [Colors.orange, Colors.deepOrangeAccent]));
  }

  Positioned _circlePink(double pinkSize) {
    return Positioned(
        top: -pinkSize * 0.4,
        right: -pinkSize * 0.2,
        child: Circle(
            size: pinkSize, colors: const [Colors.pinkAccent, Colors.pink]));
  }
}
