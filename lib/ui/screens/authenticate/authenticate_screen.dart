import 'package:flutter/material.dart';

import 'register_screen.dart';

import 'sign_in_screen.dart';

class AuthenticateScreen extends StatefulWidget {
  static const routeName = '/authenticate';

  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
      //to reverse the state
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignInScreen(toggleView:toggleView);
    } else {
      return RegisterScreen(toggleView:toggleView);
    }
  }
}
