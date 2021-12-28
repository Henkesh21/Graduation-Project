import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:healthy_lifestyle_app/ui/screens/admin_dashboard/categories_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/admin_dashboard/exercises_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/admin_dashboard/food_items_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/admin_dashboard/modules_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/admin_dashboard/roles_screen.dart';

import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:healthy_lifestyle_app/core/services/authenticate_service.dart';
import 'package:healthy_lifestyle_app/core/services/user_service.dart';

// import 'package:healthy_lifestyle_app/ui/screens/authenticate/authenticate_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/authenticate/sign_in_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/daily_calories_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/home/home_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/profile_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/settings_screen.dart';
import 'package:healthy_lifestyle_app/ui/screens/targets_screen.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final AuthenticateService _auth = AuthenticateService();
  var _currentUserId;
  UserService _userService = new UserService();
  List<User> _userWithCondition;
  String _userName;
  Map _role;
  String _name;
  var _value;
  var _roleValue;
  bool _isRegisteredUser;

  Widget buildListTile(
      String title, Icon icon, Function tapHandler, Color color) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      onTap: tapHandler,
    );
  }

  Future<int> getUserData(String id) async {
    _userWithCondition = await _userService.fetchUsersWithCondition('uId', id);
    if (_userWithCondition.isEmpty) {
      setState(() {
        _isRegisteredUser = false;
      });
    } else {
      setState(() {
        _isRegisteredUser = true;
      });
    }
    print('_isRegisteredUser >>>>>>>>>>>>>' + _isRegisteredUser.toString());
    for (int i = 0; i < _userWithCondition.length; i++) {
      _userName = _userWithCondition[i].getName;
      print('_userName >>>>>>>>>>>>>> ' + '$_userName');
      _role = _userWithCondition[i].getRole.toJson();
      print('_role >>>>>>>>>>>>>> ' + _role.toString());
      _name = _role['name'] ?? '';
      _value = _role['value'] ?? '';
      print('_name >>>>>>>>>>>>>> ' + _name);
      print('_roleValue  >>>>>>>>>>>>>> ' + '$_value');
    }
    return _value;
  }

  void initState() {
    super.initState();

    _auth.getCurrentUserId().then((String s) {
      _currentUserId = s;
      getUserData(_currentUserId).then((int n) {
        setState(() {
          _roleValue = n;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _color = Theme.of(context).secondaryHeaderColor;
    final mediaQuery = MediaQuery.of(context);

    didChangeDependencies();

    return Drawer(
      child: SingleChildScrollView(
        child: ConditionalBuilder(
          condition: _roleValue != null || _isRegisteredUser != null,
          builder: (context) => ConditionalBuilder(
            condition: _isRegisteredUser || !_isRegisteredUser,
            builder: (context) => Column(
              children: <Widget>[
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Let\'s Do It 💪🏽',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                buildListTile(
                  'Home',
                  Icon(
                    FontAwesomeIcons.home,
                    size: 26,
                    color: Theme.of(context).accentColor,
                  ),
                  () {
                    Navigator.of(context)
                        .pushReplacementNamed(HomeScreen.routeName);
                  },
                  _color,
                ),
                buildListTile(
                  'Profile',
                  Icon(
                    FontAwesomeIcons.userCircle,
                    size: 26,
                    color: Theme.of(context).accentColor,
                  ),
                  () async {
                    Navigator.of(context).pushNamed(ProfileScreen.routeName);
                  },
                  _color,
                ),
                ConditionalBuilder(
                    condition: !_isRegisteredUser || _roleValue == 2,
                    // fallback: , runs if false but builder runs if false
                    builder: (context) {
                      return buildListTile(
                        'Start A Journey',
                        Icon(
                          FontAwesomeIcons.fire,
                          size: 26,
                          color: Theme.of(context).accentColor,
                        ),
                        () {
                          Navigator.of(context)
                              .pushNamed(TargetsScreen.routeName);
                        },
                        _color,
                      );
                    }),
                ConditionalBuilder(
                    condition: !_isRegisteredUser || _roleValue == 2,
                    // fallback: , runs if false but builder runs if false
                    builder: (context) {
                      return buildListTile(
                        'Daily Calories',
                        Icon(
                          FontAwesomeIcons.tasks,
                          size: 26,
                          color: Theme.of(context).accentColor,
                        ),
                        () async {
                          Navigator.of(context)
                              .pushNamed(DailyCaloriesScreen.routeName);
                        },
                        _color,
                      );
                    }),

                buildListTile(
                  'Settings',
                  Icon(
                    FontAwesomeIcons.tools,
                    size: 26,
                    color: Theme.of(context).accentColor,
                  ),
                  () {
                    Navigator.of(context).pushNamed(SettingsScreen.routeName);
                  },
                  _color,
                ),

                ConditionalBuilder(
                    condition: _roleValue == 1,
                    // fallback: , runs if false but builder runs if false
                    builder: (context) {
                      return Container(
                        width: mediaQuery.size.width * 0.8,
                        child: Divider(
                          // thickness: 1,
                          height: 5,
                          color: Theme.of(context).secondaryHeaderColor,
                          // indent: 65,
                        ),
                      );
                    }),

                ConditionalBuilder(
                    condition: _roleValue == 1,
                    // fallback: , runs if false but builder runs if false
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.all(
                          mediaQuery.size.height / 95,
                        ),
                        child: Row(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.computer, size: 40),
                                  ),
                                  TextSpan(
                                    text: ' Dashboard',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensed',
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: _color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ConditionalBuilder(
                    condition: _roleValue == 1,
                    // fallback: , runs if false but builder runs if false
                    builder: (context) {
                      return Container(
                        width: mediaQuery.size.width * 0.7,
                        child: Divider(
                          // thickness: 1,
                          height: 5,
                          color: Theme.of(context).secondaryHeaderColor,
                          indent: 0,
                        ),
                      );
                    }),

                ConditionalBuilder(
                    condition: _roleValue == 1,
                    builder: (context) {
                      return buildListTile(
                        'Modules',
                        Icon(
                          FontAwesomeIcons.boxes,
                          size: 26,
                          color: Theme.of(context).accentColor,
                        ),
                        () async {
                          Navigator.of(context)
                              .pushNamed(ModulesScreen.routeName);
                        },
                        _color,
                      );
                    }),

                ConditionalBuilder(
                    condition: _roleValue == 1,
                    // fallback: , runs if false but builder runs if false
                    builder: (context) {
                      return buildListTile(
                        'Roles',
                        Icon(
                          FontAwesomeIcons.user,
                          size: 26,
                          color: Theme.of(context).accentColor,
                        ),
                        () async {
                          Navigator.of(context)
                              .pushNamed(RolesScreen.routeName);
                        },
                        _color,
                      );
                    }),

                ConditionalBuilder(
                    condition: _roleValue == 1,
                    // fallback: , runs if false but builder runs if false
                    builder: (context) {
                      return buildListTile(
                        'Categories',
                        Icon(
                          FontAwesomeIcons.layerGroup,
                          size: 26,
                          color: Theme.of(context).accentColor,
                        ),
                        () async {
                          Navigator.of(context)
                              .pushNamed(CategoriesScreen.routeName);
                        },
                        _color,
                      );
                    }),
                ConditionalBuilder(
                    condition: _roleValue == 1,
                    // fallback: , runs if false but builder runs if false
                    builder: (context) {
                      return buildListTile(
                        'Exercises',
                        Icon(
                          Icons.fitness_center,
                          size: 26,
                          color: Theme.of(context).accentColor,
                        ),
                        () async {
                          Navigator.of(context)
                              .pushNamed(ExercisesScreen.routeName);
                        },
                        _color,
                      );
                    }),
                ConditionalBuilder(
                    condition: _roleValue == 1,
                    // fallback: , runs if false but builder runs if false
                    builder: (context) {
                      return buildListTile(
                        'Foods',
                        Icon(
                          Icons.restaurant,
                          size: 26,
                          color: Theme.of(context).accentColor,
                        ),
                        () async {
                          Navigator.of(context)
                              .pushNamed(FoodItemsScreen.routeName);
                        },
                        _color,
                      );
                    }),
                // setState(() {
                // });
                ConditionalBuilder(
                    condition: _roleValue == 1,
                    // fallback: , runs if false but builder runs if false
                    builder: (context) {
                      return Container(
                        width: mediaQuery.size.width * 0.8,
                        child: Divider(
                          // thickness: 1,
                          height: 5,
                          color: Theme.of(context).secondaryHeaderColor,
                          // indent: 65,
                        ),
                      );
                    }),
                buildListTile(
                  'Logout',
                  Icon(
                    Icons.exit_to_app,
                    size: 26,
                    color: Theme.of(context).accentColor,
                  ),
                  () async {
                    await _auth.signOut();
                    Navigator.of(context)
                        .pushReplacementNamed(SignInScreen.routeName);
                  },
                  _color,
                ),
              ],
            ),
          ),
          fallback: (context) => SpinKitChasingDots(
            color: Theme.of(context).accentColor,
            size: 60.0,
          ),
        ),
      ),
    );
  }
}
