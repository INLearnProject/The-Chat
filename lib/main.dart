import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'controllers/chat_controller.dart';

import 'screens/welcome_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/register_screen.dart';
import 'screens/user_home_screen.dart';
import 'screens/user_chat_screen.dart';

import 'constants/routes_constant.dart';
import 'constants/global_constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TheChatApp());
}

class TheChatApp extends StatelessWidget {
  const TheChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatController>(
      create: (context) => ChatController(),
      child: MaterialApp(
        title: "The Chat",
        initialRoute: RoutesConstant.welcome,
        onGenerateRoute: (route) {
          switch (route.name) {
            case RoutesConstant.userChat:
              return MaterialPageRoute(
                  builder: (context) =>
                      UserChatScreen(discussionID: route.arguments.toString()));
            default:
              return MaterialPageRoute(
                  builder: (context) => const UserHomeScreen());
          }
        },
        routes: {
          RoutesConstant.welcome: (context) => const WelcomeScreen(),
          RoutesConstant.register: (context) => RegisterScreen(),
          RoutesConstant.signin: (context) => SigninScreen(),
          RoutesConstant.userHome: (context) => const UserHomeScreen(),
          // RoutesConstant.changePassword : (context) => ChangePassword()
        },
        theme: ThemeData(
          appBarTheme:
              const AppBarTheme(color: Colors.transparent, elevation: 0.0),
          scaffoldBackgroundColor: const Color(GlobalConstant.colorBackground),
        ),
      ),
    );
  }
}
