import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../controllers/chat_controller.dart';

class ComponentAlertDialog extends StatelessWidget {
  final String discussionID;

  const ComponentAlertDialog(this.discussionID, {super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        "Supprimer la discussion",
        textAlign: TextAlign.center,
      ),
      titlePadding: const EdgeInsets.all(8.0),
      children: <Widget>[
        const Text(
          "Voulez-vous supprimer la discussion ?",
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                child: const Text("Non"),
                onPressed: () => Navigator.pop(context)),
            TextButton(
              child: const Text("Oui"),
              onPressed: () async {
                Provider.of<ChatController>(context, listen: false)
                    .deleteDiscussion(discussionID);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ],
    );
  }
}
