import 'package:flutter/material.dart';

class ComponentButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;

  const ComponentButton(
      {required this.buttonName, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: onPressed,
        child: Text(
          buttonName,
          style: const TextStyle(fontSize: 17.0),
        ),
      ),
    );
  }
}
