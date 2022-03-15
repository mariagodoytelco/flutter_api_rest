import 'package:flutter/material.dart';

class Circle extends StatefulWidget {
  final double size;
  final List<Color> colors;

  const Circle({Key? key, required this.size, required this.colors})
      : assert(size > 0), assert(colors .length >= 2),
        super(key: key);

  @override
  State<Circle> createState() => _CircleState();
}

class _CircleState extends State<Circle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: widget.colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
    );
  }
}
