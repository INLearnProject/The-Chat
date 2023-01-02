import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

import '../../controllers/chat_controller.dart';

class ComponentChatBuilder extends StatelessWidget {
  final String discussionID;
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  ComponentChatBuilder(this.discussionID, {super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Provider.of<ChatController>(context);
    String message = "";

    return StreamBuilder<QuerySnapshot>(
        stream: controller.getChat(discussionID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Pas de données pour cette dicussion.");
          }
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, item) {
                      final DateTime? dateString =
                          DateTime.tryParse(snapshot.data!.docs[item]["date"]);
                      final String dateFormated = dateString != null
                          ? formatDate(dateString,
                              [dd, '-', mm, '-', yy, ' ', HH, ':', ss])
                          : "Erreur";

                      final String displayName = snapshot
                          .data!.docs[item]["sender"]
                          .toString()
                          .split("@")[0]
                          .toUpperCase();
                      bool isMe = snapshot.data!.docs[item]["sender"] ==
                              controller.activeUser!.email
                          ? true
                          : false;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  displayName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  dateFormated,
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              color:
                                  isMe ? Colors.lightBlueAccent : Colors.white,
                              child: Text(snapshot.data!.docs[item]["content"]),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              Form(
                key: _keyForm,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          onSaved: (value) {
                            message = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Le champs est vide";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: "Hey! Je veux dire quelque chose",
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      TextButton(
                        child: const Text(
                          "Envoyer",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_keyForm.currentState!.validate()) {
                            _keyForm.currentState!.save();
                            _keyForm.currentState!.reset();
                            controller.sendPostChat(
                                postChat: message, discussionID: discussionID);
                          }
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
