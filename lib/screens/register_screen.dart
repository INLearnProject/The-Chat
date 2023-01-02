import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import 'components/appbar_component.dart';
import 'components/button_component.dart';
import 'components/textformfield_component.dart';

import '../constants/global_constant.dart';
import '../constants/routes_constant.dart';

class RegisterScreen extends StatelessWidget {
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    String email = "";
    String password = "";

    return Scaffold(
      appBar: ComponentAppBar(titleAppBar: ": s'inscrire").build(),
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
                  flex: 2,
                  child: Hero(
                      tag: "logoTag",
                      child: Image.asset(GlobalConstant.assetLogo)),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                Flexible(
                  child: ComponentTextFormField(
                    validator: (email) {
                      if (!EmailValidator.validate(email!)) {
                        return "Merci d'entrer une adresse email correcte.";
                      }
                      return null;
                    },
                    hintText: "Adresse email",
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
                Flexible(
                  child: ComponentTextFormField(
                    obscureText: true,
                    controller: _passController,
                    validator: (mdp) {
                      if (mdp!.length < 6) {
                        return "Le mot de passe doit contenir au minimum 6 caractères.";
                      } else if (!mdp.contains("@")) {
                        return "Le mot de passe doit contenir un @.";
                      }
                      return null;
                    },
                    hintText: "Mot de passe",
                    onSaved: (value) {
                      password = value!;
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
                Flexible(
                  child: ComponentTextFormField(
                    obscureText: true,
                    validator: (confirmMdp) {
                      if (confirmMdp!.isEmpty) {
                        return "Merci de confirmer votre mot de passe.";
                      } else if (confirmMdp != _passController.text) {
                        return "La confirmation du mot de passe n'est pas identique au mot de passe.";
                      }
                      return null;
                    },
                    hintText: "Confirmer mot de passe",
                    onSaved: (value) {},
                  ),
                ),
                const SizedBox(height: 24.0),
                Flexible(
                  child: Hero(
                    tag: "registerLogoTag",
                    child: ComponentButton(
                      buttonName: "S'inscrire",
                      onPressed: () async {
                        FocusManager.instance.primaryFocus!.unfocus();
                        try {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final User? user =
                                (await _firebase.createUserWithEmailAndPassword(
                                        email: email, password: password))
                                    .user;

                            if (mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RoutesConstant.userHome,
                                  (Route<dynamic> route) => false);
                            }
                            print(user);
                          }
                        } catch (error) {
                          print(error);
                        }
                      },
                    ),
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
