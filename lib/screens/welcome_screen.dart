import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../constants/routes_constant.dart';
import '../constants/global_constant.dart';

import '../controllers/chat_controller.dart';

import 'components/appbar_component.dart';
import 'components/button_component.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ComponentAppBar(titleAppBar: "").build(),
      backgroundColor: const Color(GlobalConstant.colorBackground),
      body: FutureBuilder(
        future: Provider.of<ChatController>(context).checkIdentity(
          onAuth: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, RoutesConstant.userHome);
            });
          },
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    child: Hero(
                      tag: "logoTag",
                      child: Image.asset(GlobalConstant.assetLogo),
                    ),
                  ),
                  const SizedBox(height: 48.0),
                  Hero(
                    tag: "signinLogoTag",
                    child: ComponentButton(
                      buttonName: "Se connecter",
                      onPressed: () =>
                          Navigator.pushNamed(context, RoutesConstant.signin),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Hero(
                    tag: "registerLogoTag",
                    child: ComponentButton(
                      buttonName: "S'inscrire",
                      onPressed: () =>
                          Navigator.pushNamed(context, RoutesConstant.register),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
