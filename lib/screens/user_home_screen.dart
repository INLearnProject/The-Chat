import 'package:flutter/material.dart';

import 'components/appbar_component.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../controllers/chat_controller.dart';

import 'components/floating_action_component.dart';
import 'components/alert_dialog_component.dart';

import '../constants/routes_constant.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Provider.of<ChatController>(context);

    return Scaffold(
      floatingActionButton: ComponentFloatingAction(),
      appBar: ComponentAppBar(titleAppBar: ": espace membre", actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.close,
            size: 30.0,
            color: Colors.red,
          ),
          onPressed: () {
            controller.signOut();
            Navigator.pushReplacementNamed(context, RoutesConstant.welcome);
          },
        ),
      ]).build(),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: SafeArea(
          child: FutureBuilder<User?>(
            future: controller.checkIdentity(
              onNoAuth: () => Navigator.pushNamedAndRemoveUntil(context,
                  RoutesConstant.welcome, (Route<dynamic> route) => false),
            ),
            builder: (context, AsyncSnapshot<User?> data) {
              if (!data.hasData) {
                return const CircularProgressIndicator();
              }
              return FutureBuilder(
                future: controller.getDiscussions(),
                builder: (context, AsyncSnapshot<QuerySnapshot> discussions) {
                  if (!discussions.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return RefreshIndicator(
                    onRefresh: () => controller.refreshDiscussions(),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: discussions.data!.docs.length,
                      itemBuilder: (context, item) {
                        return Column(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              child: ListTile(
                                onLongPress: () {
                                  bool isCreator = discussions.data!.docs[item]
                                              ["creatorID"] ==
                                          controller.activeUser!.uid
                                      ? true
                                      : false;
                                  if (isCreator) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ComponentAlertDialog(
                                              discussions.data!.docs[item].id);
                                        });
                                  }
                                },
                                onTap: () => Navigator.pushNamed(
                                    context, RoutesConstant.userChat,
                                    arguments: discussions.data!.docs[item].id),
                                title:
                                    Text(discussions.data!.docs[item]["name"]),
                              ),
                            ),
                            const Divider(height: 1.0),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
