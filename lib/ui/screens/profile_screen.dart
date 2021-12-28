// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
// import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_lifestyle_app/core/models/role_model.dart';
import 'package:healthy_lifestyle_app/core/models/user_model.dart';
// import 'package:healthy_lifestyle_app/core/services/storage_service.dart';
import 'package:healthy_lifestyle_app/core/services/authenticate_service.dart';
// import 'package:healthy_lifestyle_app/core/services/role_service.dart';
import 'package:healthy_lifestyle_app/core/services/user_service.dart';
import 'package:healthy_lifestyle_app/ui/screens/authenticate/register_screen.dart';
import 'package:healthy_lifestyle_app/ui/widgets/edit_profile_dialog.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthenticateService _auth = AuthenticateService();

  List<Role> roles;
  Role role;
  List<Role> rolesWithCondition;

  var _currentUserId;

  UserService _userService = new UserService();
  List<User> _userWithCondition;
  bool _isRegisteredUser;
  String _name;
  String _email;
  String _password;
  String _photo;
  var _userRole;
  String _roleName;
  var _userTarget;
  var _target;
  var _calculation;
  var _userCalculation;
  String _gender;
  // double _activityFactor;
  String _activity;
  int _age, _weight, _height;
  String _trainingPlace;
  double _bmr;
  int _dailyCalories;
  int _neededCaloriesForTarget;

  getUserData(String id) async {
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
    // for (int i = 0; i < _userWithCondition.length; i++) {
    //   setState(() {
    //     _name = _userWithCondition[i].getName;
    //     _email = _userWithCondition[i].getEmail;
    //     _password = _userWithCondition[i].getPassword;
    //     _photo = _userWithCondition[i].getPhoto;
    //     _userRole = _userWithCondition[i].getRole.toJson();
    //     print('_userRole >>>>>>>>>>>>>> ' + _userRole.toString());
    //     _roleName = _userRole['name'] ?? '';
    //   });
    // }
    print('_isRegisteredUser >>>>>>>>>>>>>' + _isRegisteredUser.toString());
    return _isRegisteredUser;
  }

  void initState() {
    _auth.getCurrentUserId().then((String s) {
      _currentUserId = s;
      getUserData(_currentUserId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final userProvider = Provider.of<UserService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Center(
        child: ConditionalBuilder(
          condition: _isRegisteredUser != null,
          builder: (context) => ConditionalBuilder(
            condition: _isRegisteredUser,
            builder: (context) => StreamBuilder(
              stream: userProvider.fetchUsersAsStreamWithCondition(
                  'uId', _currentUserId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var _user = snapshot.data.documents
                      .map((doc) => User.fromMap(doc.data, doc.documentID))
                      .toList();

                  for (int i = 0; i < _user.length; i++) {
                    _name = _user[i].getName;
                    _email = _user[i].getEmail;
                    _password = _user[i].getPassword;
                    _photo = _user[i].getPhoto;
                    _userRole = _user[i].getRole.toJson();
                    _roleName = _userRole['name'] ?? '';

                    _target = _user[i].getTarget;

                    _gender = _user[i].getGender;
                    _age = _user[i].getAge;
                    _weight = _user[i].getWeight;
                    _height = _user[i].getHeight;
                    _activity = _user[i].getActivity;
                    _userTarget = _user[i].getTarget;
                    _userCalculation = _user[i].getCalculation;

                    // print('_target >>>>>>>>>>>>> ' + _target.toString());
                    // // print('_targetObject >>>>>>>>>>>>>> ' +
                    // //     _targetObject.toString());
                    // print('_objective >>>>>>>>>>>>> ' +
                    //     _objective.toString());
                    // print('_startDate >>>>>>>>>>>>> ' +
                    //     _startDate.toString());
                    // print(
                    //     '_endDate >>>>>>>>>>>>> ' + _endDate.toString());
                    if (_target != 'no-target') {
                      // _objective = _userTarget['objective'] ?? '';
                      // _startDate = _userTarget['start_date'] ?? '';
                      // _endDate = _userTarget['end_date'] ?? '';
                      // _trainingPlace = _userTarget['training_place'] ?? '';
                      // // _activityFactor =
                      // //     _userTarget['activity_factor'] ?? '';

                      // _startDateToDateTime = _startDate.toDate().toLocal();
                      // _startDateFormat =
                      //     DateFormat.yMMMEd().format(_startDateToDateTime);

                      // _endDateToDateTime = _endDate.toDate().toLocal();
                      // _endDateFormat =
                      //     DateFormat.yMMMEd().format(_endDateToDateTime);

                      // _duration = _endDateToDateTime
                      //     .toLocal()
                      //     .difference(_startDateToDateTime);

                      // x = _endDateToDateTime
                      //     .toLocal()
                      //     .difference(DateTime.now().toLocal());

                      // y = x.compareTo(_duration);

                      // z = _endDateToDateTime
                      //         .toLocal()
                      //         .difference(DateTime.now().toLocal()) -
                      //     _startDateToDateTime
                      //         .toLocal()
                      //         .difference(DateTime.now().toLocal());

                      // if (y == 0) {
                      //   _dynamicDuration = x;
                      // } else {
                      //   _dynamicDuration = z;
                      // }

                      //  y = DateTime.now().subtract(duration)

                      //  z = _duration.inDays -

                      // _hours = _endDateToDateTime
                      //     .difference(_startDateToDateTime)
                      //     .inHours;
                      // _minutes = _endDateToDateTime
                      //     .difference(_startDateToDateTime)
                      //     .inMinutes;
                      // _seconds = _endDateToDateTime
                      //     .difference(_startDateToDateTime)
                      //     .inSeconds;

                      _calculation = _user[i].getCalculation;

                      if (_calculation != 'no-calculation') {
                        _bmr = _userCalculation['bmr'] ?? 0;
                        _dailyCalories =
                            _userCalculation['daily_calories'] ?? 0;
                        _neededCaloriesForTarget =
                            _userCalculation['needed_calories_for_target'] ?? 0;
                        // _consumedCalories =
                        //     _userCalculation['consumed_calories'] ?? '';
                      }

                      // print('DateTime.now() >>>>>>>>>>>>> ' +
                      //     DateTime.now().toString());
                      // print('_startDateToDateTime >>>>>>>>>>>>> ' +
                      //     _startDateToDateTime.toString());
                      // print('_endDateToDateTime >>>>>>>>>>>>> ' +
                      //     _endDateToDateTime.toString());
                      // print(
                      //     '_startDate >>>>>>>>>>>>> ' + _startDate.toString());
                      // print('_endDate >>>>>>>>>>>>> ' + _endDate.toString());
                      // print('_duration >>>>>>>>>>>>> ' + _duration.toString());
                      // print('x >>>>>>>>>>>>> ' + x.toString());
                      // print('y >>>>>>>>>>>>> ' + y.toString());
                      // print('z >>>>>>>>>>>>> ' + z.toString());
                    }
                  }
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Hero(
                        //   tag: 'Profile photo',
                        //   child:
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: mediaQuery.size.height / 30,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).accentColor,
                            radius: 80.0,
                            child: ConditionalBuilder(
                              condition: _photo == 'no-photo',
                              builder: (context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                        'assets/images/waiting.png',
                                      ),
                                    ),
                                  ),
                                );
                              },
                              fallback: (context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        _photo,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.all(mediaQuery.size.height / 50),
                        // ),
                        RaisedButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return EditProfileDialog(
                                  userService: _userService,
                                  currentUserId: _currentUserId,
                                  name: _name,
                                  email: _email,
                                  password: _password,
                                  photo: _photo,
                                  role: _userRole,
                                  target: _userTarget,
                                  gender: _gender,
                                  calculation: _userCalculation,
                                  bmr: _bmr,
                                  age: _age,
                                  activity: _activity,
                                  weight: _weight,
                                  height: _height,
                                  dailyCalories: _dailyCalories,
                                  neededCaloriesForTarget:
                                      _neededCaloriesForTarget,
                                  trainingPlace: _trainingPlace,
                                );
                              },
                            );
                          },
                          child: Text('Edit profile'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(mediaQuery.size.height / 50),
                        ),
                        FittedBox(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.person, size: 16),
                                ),
                                TextSpan(
                                    text: ' $_name',
                                    style: Theme.of(context).textTheme.bodyText2
                                    // .copyWith(
                                    //   fontSize: 12,
                                    // ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(mediaQuery.size.height / 30),
                        ),
                        FittedBox(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.email, size: 16),
                                ),
                                TextSpan(
                                    text: ' $_email',
                                    style: Theme.of(context).textTheme.bodyText2
                                    // .copyWith(
                                    //   fontSize: 12,
                                    // ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(mediaQuery.size.height / 30),
                        ),
                        FittedBox(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(FontAwesomeIcons.userCircle,
                                      size: 16),
                                ),
                                TextSpan(
                                    text: ' $_roleName',
                                    style: Theme.of(context).textTheme.bodyText2
                                    // .copyWith(
                                    //   fontSize: 12,
                                    // ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(mediaQuery.size.height / 30),
                        ),

                        ConditionalBuilder(
                          condition: _target != null,
                          builder: (context) => ConditionalBuilder(
                            condition: _target != 'no-target',
                            builder: (context) => Column(
                              children: <Widget>[
                                FittedBox(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: ConditionalBuilder(
                                            condition: _gender == 'male',
                                            builder: (context) => Icon(
                                              FontAwesomeIcons.male,
                                              size: 16,
                                            ),
                                            fallback: (context) => Icon(
                                              FontAwesomeIcons.female,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                            text: ' $_gender',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                            // .copyWith(
                                            //   fontSize: 12,
                                            // ),
                                            ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      mediaQuery.size.height / 30),
                                ),
                                FittedBox(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                          ),
                                        ),
                                        TextSpan(
                                            text: ' $_age',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                            // .copyWith(
                                            //   fontSize: 12,
                                            // ),
                                            ),
                                      ],
                                    ),
                                  ),
                                ),
                                // FittedBox(
                                //   child: RichText(
                                //     text: TextSpan(
                                //       children: [
                                //         WidgetSpan(
                                //           child: Icon(
                                //             FontAwesomeIcons.percent,
                                //             size: 16,
                                //           ),
                                //         ),
                                //         TextSpan(
                                //             text: ' $_weight',
                                //             style: Theme.of(context)
                                //                 .textTheme
                                //                 .bodyText2
                                //             // .copyWith(
                                //             //   fontSize: 12,
                                //             // ),
                                //             ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // Padding(
                                //   padding: EdgeInsets.all(
                                //       mediaQuery.size.height / 30),
                                // ),
                                // FittedBox(
                                //   child: RichText(
                                //     text: TextSpan(
                                //       children: [
                                //         WidgetSpan(
                                //           child: Icon(
                                //             FontAwesomeIcons.percent,
                                //             size: 16,
                                //           ),
                                //         ),
                                //         TextSpan(
                                //             text: ' $_height',
                                //             style: Theme.of(context)
                                //                 .textTheme
                                //                 .bodyText2
                                //             // .copyWith(
                                //             //   fontSize: 12,
                                //             // ),
                                //             ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.all(mediaQuery.size.height / 30),
                        // ),

                        // ConditionalBuilder(
                        //   condition: _target != null,
                        //   builder: (context) => ConditionalBuilder(
                        //     condition: _target != 'no-target',
                        //     builder: (context) => FittedBox(
                        //       child: RichText(
                        //         text: TextSpan(
                        //           children: [
                        //             WidgetSpan(
                        //               child: Icon(FontAwesomeIcons.percent,
                        //                   size: 16),
                        //             ),
                        //             TextSpan(
                        //                 text: ' $_weight',
                        //                 style: Theme.of(context)
                        //                     .textTheme
                        //                     .bodyText2
                        //                 // .copyWith(
                        //                 //   fontSize: 12,
                        //                 // ),
                        //                 ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // // Padding(
                        // //   padding: EdgeInsets.all(mediaQuery.size.height / 30),
                        // // ),

                        // ConditionalBuilder(
                        //   condition: _target != null,
                        //   builder: (context) => ConditionalBuilder(
                        //     condition: _target != 'no-target',
                        //     builder: (context) => FittedBox(
                        //       child: RichText(
                        //         text: TextSpan(
                        //           children: [
                        //             WidgetSpan(
                        //               child: Icon(
                        //                 FontAwesomeIcons.percent,
                        //                 size: 16,
                        //               ),
                        //             ),
                        //             TextSpan(
                        //                 text: ' $_height',
                        //                 style: Theme.of(context)
                        //                     .textTheme
                        //                     .bodyText2
                        //                 // .copyWith(
                        //                 //   fontSize: 12,
                        //                 // ),
                        //                 ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.all(mediaQuery.size.height / 30),
                        // ),
                      ],
                    ),
                  );
                } else {
                  return SpinKitChasingDots(
                    color: Theme.of(context).accentColor,
                    size: 60.0,
                  );
                }
              },
            ),
            fallback: (context) => LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Welcome 😃',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height / 30,
                    ),
                    FittedBox(
                      child: Text(
                        ' Don\'t Have An Account Yet! 🤔 ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height / 30,
                    ),
                    Text(
                      'Join Us 🤩',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(
                      height: mediaQuery.size.height / 30,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegisterScreen.routeName);
                      },
                      child: Text('Register'),
                    ),
                  ],
                );
              },
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
