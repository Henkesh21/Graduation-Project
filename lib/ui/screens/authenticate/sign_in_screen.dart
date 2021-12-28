import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:healthy_lifestyle_app/core/services/authenticate_service.dart';
import 'package:healthy_lifestyle_app/ui/screens/authenticate/register_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/home/home_screen.dart';
import 'package:healthy_lifestyle_app/ui/shared/build_sign_in_and_register.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign-in';

  final Function toggleView;

  SignInScreen({this.toggleView});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthenticateService _auth = AuthenticateService();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error;

  didChangeDependencies();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // final isLandscape = mediaQuery.orientation == Orientation.landscape;

    Widget buildForm(BuildContext context) {
      return Form(
        key: _formKey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // SizedBox(
            //   height: 10.0,
            // ),
            ConditionalBuilder(
              condition: error == 'Could not sign in with those credentials',
              builder: (context) => Center(
                child: Text(
                  error,
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(
                  Icons.email,
                  color: Theme.of(context).canvasColor,
                ),
              ),
              validator: (val) => val.isEmpty ? 'Enter an email' : null,
              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.all(mediaQuery.size.width / 30),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(
                  Icons.lock,
                  color: Theme.of(context).canvasColor,
                ),
              ),
              obscureText: true,
              validator: (val) =>
                  val.length < 6 ? 'Enter a password 6+ chars long' : null,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.all(mediaQuery.size.width / 60),
            ),
            // SizedBox(
            //   height: 10.0,
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // print(email);
                      // print(password);
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Could not sign in with those credentials';
                          loading = false;
                        });
                      } else {
                        Navigator.of(context).pushNamed(HomeScreen.routeName);
                        print('Signed in');
                      }
                    }
                  },
                  child: Text('Sign in'),
                ),
                FittedBox(
                  child: Text(
                    'New?',
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: 14,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(RegisterScreen.routeName);

                    // widget.toggleView();
                  },
                  child: Text('Register'),
                ),
              ],
            ),

            Center(
              child: FittedBox(
                child: Text(
                  'Or',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: 14,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            RaisedButton(
                child: Text(
                  'Sign in anonymously',
                ),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  dynamic result = await _auth.signInAnon();
                  if (result == null) {
                    print('Error signing in');
                    setState(() {
                      loading = false;
                    });
                  } else {
                    Navigator.of(context)
                        .pushReplacementNamed(HomeScreen.routeName);
                    print('Signed in');
                    // print(result.uid);
                  }
                }),
          ],
        ),
      );
    }

    Form signInForm = buildForm(context);

    return BuildSignInAndRegister(
      form: signInForm,
      loading: loading,
    );
  }
}
