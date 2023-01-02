import 'package:flutter/material.dart';

class ComponentTextFormField extends StatelessWidget {
  final String hintText;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool? obscureText;

  const ComponentTextFormField(
      {required this.hintText,
      required this.onSaved,
      this.validator,
      this.controller,
      this.obscureText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: Colors.redAccent[700]!),
            borderRadius: BorderRadius.circular(32.0)),
        errorStyle: TextStyle(color: Colors.redAccent[700]),
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.0,
            color: Colors.lightBlueAccent,
          ),
          borderRadius: BorderRadius.circular(32.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2.5,
            color: Colors.lightBlueAccent,
          ),
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
  }
}
