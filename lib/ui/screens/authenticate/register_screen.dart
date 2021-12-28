import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healthy_lifestyle_app/ui/screens/authenticate/sign_in_screen.dart';

import 'package:provider/provider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:healthy_lifestyle_app/core/models/role_model.dart';
import 'package:healthy_lifestyle_app/core/services/authenticate_service.dart';
import 'package:healthy_lifestyle_app/core/services/role_service.dart';
import 'package:healthy_lifestyle_app/ui/screens/home/home_screen.dart';
import 'package:healthy_lifestyle_app/ui/shared/build_sign_in_and_register.dart';
// import 'package:healthy_lifestyle_app/ui/shared/loading.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  final Function toggleView;

  RegisterScreen({this.toggleView});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthenticateService _auth = AuthenticateService();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String name = '';
  String email = '';
  String password = '';
  String error;

  var _currentItemSelected;

  List<Role> roles;
  Role role;
  List<Role> rolesWithCondition;
  var roleObject;

  didChangeDependencies();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final roleProvider = Provider.of<RoleService>(context);

    Widget buildForm(BuildContext context) {
      return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            ConditionalBuilder(
              condition: error == 'Please supply a valid email',
              builder: (context) => Center(
                child: Text(
                  error,
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Name',
                prefixIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).canvasColor,
                ),
              ),
              validator: (val) {
                if (val.isEmpty) {
                  return 'Enter your name';
                } else if (val.length < 2) {
                  return 'Name not long enough';
                } else
                  return null;
              },
              // (val) => val.isEmpty ? 'Enter your name' : null,
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.all(mediaQuery.size.width / 90),
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
              padding: EdgeInsets.all(mediaQuery.size.width / 90),
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
              padding: EdgeInsets.all(mediaQuery.size.width / 90),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: roleProvider.fetchRolesAsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    roles = snapshot.data.documents
                        .map((doc) => Role.fromMap(doc.data, doc.documentID))
                        .toList();

                    List<DropdownMenuItem> rolesList = [];
                    for (int i = 0; i < snapshot.data.documents.length; i++) {
                      role = roles[i];

                      if (role.getName != 'admin') {
                        rolesList.add(
                          DropdownMenuItem(
                            child: Text(
                              role.getName,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            value: "${role.getName}",
                          ),
                        );
                      }
                    }
                    return Container(
                      width: mediaQuery.size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Container(
                          //   child: Icon(
                          //     FontAwesomeIcons.userCircle,
                          //     color: Theme.of(context).canvasColor,
                          //   ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.all(mediaQuery.size.width / 85),
                          // ),
                          Container(
                            width: mediaQuery.size.width * 0.4,
                            child: DropdownButtonFormField<dynamic>(
                              icon: Icon(
                                FontAwesomeIcons.userCircle,
                                color: Theme.of(context).canvasColor,
                              ),
                              items: rolesList,
                              onChanged: (val) async {
                                final snackBar = SnackBar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  content: Text(
                                    'Type is $val',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(
                                          fontSize: 12,
                                        ),
                                  ),
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                                setState(() {
                                  _currentItemSelected = val;
                                });
                                rolesWithCondition = await roleProvider
                                    .fetchRolesWithCondition('name', val);
                                print('rolesWithCondition >>>>>>>>>>>>>> ' +
                                    rolesWithCondition.toString());

                                for (int i = 0;
                                    i < rolesWithCondition.length;
                                    i++) {
                                  print(
                                      'rolesWithCondition name >>>>>>>>>>>>>> ' +
                                          '${rolesWithCondition[i].getName}');

                                  roleObject = rolesWithCondition[i].toJson();
                                  print('roleObject >>>>>>>>>>>>>> ' +
                                      roleObject.toString());
                                }
                              },
                              value: _currentItemSelected,
                              isExpanded: false,
                              hint: new Text(
                                "Type",
                              ),
                              validator: (val) =>
                                  val == null ? 'Select a type' : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SpinKitChasingDots(
                      color: Theme.of(context).accentColor,
                      size: 40.0,
                    );
                  }
                }),
            Padding(
              padding: EdgeInsets.all(mediaQuery.size.width / 90),
            ),
            RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    loading = true;
                  });
                  print('roleObject from register >>>>>>>>>>>>>>  ' +
                      roleObject.toString());
                  dynamic result = await _auth.registerWithEmailAndPassword(
                    email,
                    password,
                    name,
                    roleObject,
                  );
                  if (result == null) {
                    setState(() {
                      error = 'Please supply a valid email';
                      loading = false;
                    });
                  } else {
                    Navigator.of(context)
                        .pushReplacementNamed(HomeScreen.routeName);
                    print('Registered');
                  }
                }
              },
              child: Text('Register'),
            ),
            FittedBox(
              child: Text(
                'Already have an account?',
                style: Theme.of(context).textTheme.headline1.copyWith(
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(SignInScreen.routeName);

                // widget.toggleView();
              },
              child: Text('Sign in'),
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
                  }
                }),
          ],
        ),
      );
    }

    Form registerForm = buildForm(context);

    return BuildSignInAndRegister(
      form: registerForm,
      loading: loading,
    );
  }
}
