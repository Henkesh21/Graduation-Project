import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:healthy_lifestyle_app/ui/screens/authenticate/authenticate_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/home/home_screen.dart';

class WrapperScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _WrapperScreenState createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final _user = Provider.of<User>(context);
    // print(user);
    bool _isSigned;
    //return either home or authenticate widget

    if (_user == null) {
      setState(() {
        _isSigned = false;
      });
    } else {
      setState(() {
        _isSigned = true;
      });
    }
    if (!_isSigned) {
      return AuthenticateScreen();
    } else {
      return HomeScreen();
    }
  }
}
