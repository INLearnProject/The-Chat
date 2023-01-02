import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../controllers/chat_controller.dart';

class ComponentFloatingAction extends StatelessWidget {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  ComponentFloatingAction({super.key});

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    final ChatController controller = Provider.of<ChatController>(context);
    String discussionName = "";

    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return SafeArea(
                  child: Form(
                key: _keyForm,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          onSaved: (value) {
                            discussionName = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Le champs est vide";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Ajouter une discussion",
                          ),
                        ),
                      ),
                      TextButton(
                        child: const Text(
                          "Ajouter",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () async {
                          if (_keyForm.currentState!.validate()) {
                            _keyForm.currentState!.save();
                            await controller.sendNewDiscussion(discussionName);

                            if (mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ));
            });
      },
      child: const Icon(Icons.add),
    );
  }
}
