import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../controllers/chat_controller.dart';

import '../constants/routes_constant.dart';

import 'components/appbar_component.dart';
import 'components/chat_builder_component.dart';

class UserChatScreen extends StatelessWidget {
  final String discussionID;

  const UserChatScreen({required this.discussionID, super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Provider.of<ChatController>(context);
    return Scaffold(
      appBar: ComponentAppBar(titleAppBar: ": chat").build(),
      body: SafeArea(
        child: FutureBuilder(
          future: controller.checkIdentity(
            onNoAuth: () => Navigator.pushNamedAndRemoveUntil(context,
                RoutesConstant.welcome, (Route<dynamic> route) => false),
          ),
          builder: (context, AsyncSnapshot<User?> data) {
            if (!data.hasData) {
              return const CircularProgressIndicator();
            }
            return ComponentChatBuilder(discussionID);
          },
        ),
      ),
    );
  }
}
