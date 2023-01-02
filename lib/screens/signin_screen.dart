import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import '../constants/global_constant.dart';
import '../constants/routes_constant.dart';

import 'components/appbar_component.dart';
import 'components/button_component.dart';
import 'components/textformfield_component.dart';
import 'components/error_dialog_component.dart';

class SigninScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  SigninScreen({super.key});

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    String? email;
    String? password;

    return Scaffold(
      appBar: ComponentAppBar(titleAppBar: ": se connecter").build(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                      tag: "logoTag",
                      child: Image.asset(GlobalConstant.assetLogo)),
                ),
                const SizedBox(height: 48.0),
                ComponentTextFormField(
                  validator: (email) {
                    if (!EmailValidator.validate(email!)) {
                      return "L'adresse email est invalide.";
                    }
                    return null;
                  },
                  hintText: "Adresse email",
                  onSaved: (emailSaved) {
                    email = emailSaved;
                  },
                ),
                const SizedBox(height: 10.0),
                ComponentTextFormField(
                  obscureText: true,
                  validator: (mdp) {
                    if (mdp!.length < 6) {
                      return "Le mot de passe doit contenir au minimum 6 caractères.";
                    } else if (!mdp.contains("@")) {
                      return "Le mot de passe doit contenir un @.";
                    }
                    return null;
                  },
                  hintText: "Mot de passe",
                  onSaved: (passwordSaved) {
                    password = passwordSaved;
                  },
                ),
                const SizedBox(height: 24.0),
                Hero(
                  tag: "signinLogoTag",
                  child: ComponentButton(
                    buttonName: "Se connecter",
                    onPressed: () async {
                      FocusManager.instance.primaryFocus!.unfocus();

                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        try {
                          final User? user =
                              (await _firebase.signInWithEmailAndPassword(
                                      email: email!, password: password!))
                                  .user;
                          if (mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                RoutesConstant.userHome,
                                (Route<dynamic> route) => false);
                          }
                          print(user);
                        } on FirebaseAuthException catch (error) {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  ComponentErrorDialog(error.code));
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
