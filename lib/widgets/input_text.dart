import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final bool obscureText, borderEnabled;
  final double fontSize;
  final void Function(String)? onChange;
  final String? Function(String? text)? validator;

  const InputText(
      {Key? key,
      required this.label,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.borderEnabled = true,
      this.onChange,
      this.validator,
      this.fontSize = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: fontSize),
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChange,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        enabledBorder: borderEnabled
          ? const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12))
          : InputBorder.none,
          labelStyle: const TextStyle(
            color: Colors.black45, fontWeight: FontWeight.w500)
      )
    );
  }
}
