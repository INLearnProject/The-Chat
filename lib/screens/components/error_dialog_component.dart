import 'package:flutter/material.dart';

class ComponentErrorDialog extends StatelessWidget {
  final String errorCode;
  const ComponentErrorDialog(this.errorCode, {super.key});

  @override
  Widget build(BuildContext context) {
    String message = "";

    switch (errorCode) {
      case "user-not-found":
      case "wrong-password":
        message = "Les indentifiants sont incorrects, merci de réessayer.";
        break;
      default:
        message =
            "Une erreur inattendue est survenue, merci de réessayer dans quelques minutes.";
        break;
    }

    return SimpleDialog(
      title: const Text(
        "Erreur",
        style: TextStyle(color: Colors.red),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(message),
        ),
        TextButton(
          child: const Text("Fermer"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
