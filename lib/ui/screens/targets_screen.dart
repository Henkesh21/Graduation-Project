import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:healthy_lifestyle_app/core/models/calculation_model.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:healthy_lifestyle_app/core/models/role_model.dart';
import 'package:healthy_lifestyle_app/core/models/target_model.dart';
import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:healthy_lifestyle_app/core/services/authenticate_service.dart';
import 'package:healthy_lifestyle_app/core/services/calculation_service.dart';
import 'package:healthy_lifestyle_app/core/services/target_service.dart';
import 'package:healthy_lifestyle_app/core/services/user_service.dart';
import 'package:healthy_lifestyle_app/ui/screens/count_down_timer_screen.dart';
// import 'package:healthy_lifestyle_app/ui/screens/settings_screen.dart';
import 'package:healthy_lifestyle_app/ui/widgets/select_target_dialog.dart';
import 'package:healthy_lifestyle_app/ui/widgets/target_item.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// import 'package:healthy_lifestyle_app/ui/widgets/edit_profile_dialog.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'authenticate/register_screen.dart';

class TargetsScreen extends StatefulWidget {
  static const routeName = '/targets';
  // final args;

  // const TargetsScreen({Key key, this.args}) : super(key: key);

  @override
  _TargetsScreenState createState() => _TargetsScreenState();
}

class _TargetsScreenState extends State<TargetsScreen> {
  final AuthenticateService _auth = AuthenticateService();

  var _currentUserId;

  UserService _userService = new UserService();
  List<User> _userWithCondition;
  TargetService _targetService = new TargetService();
  List<Target> _targetWithCondition;
  CalculationService _calculationService = new CalculationService();
  // List<Calculation> _calculationWithCondition;

  bool _isRegisteredUser;
  String _name;
  String _email;
  String _password;
  String _photo;

  var _userRole;
  int _roleValue;

  var _userTarget;
  var _target;
  var _singleTarget;
  String _objective;
  Timestamp _startDate;
  Timestamp _endDate;
  DateTime _startDateToDateTime;
  DateTime _endDateToDateTime;

  var _startDateFormat;
  var _endDateFormat;
  Duration _duration;
  Duration x;
  // ignore: unused_field
  Duration _dynamicDuration;
  var y;
  var z;
  int _timeStampNow;
  int _endDateInMicro;

  var _calculation;
  var _userCalculation;

  String _gender;
  String _activity;

  int _age, _weight, _height;
  String _trainingPlace;
  double _bmr;
  int _dailyCalories;
  int _neededCaloriesForTarget;
  int _days, _hours, _minutes, _seconds;
  int _dayInMicro;
  // String readTimestamp(int timestamp) {
  //   var now = new DateTime.now();
  //   var format = new DateFormat.yMMMEd();
  //   var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  //   var diff = date.difference(now);
  //   var time = '';

  //   if (diff.inSeconds <= 0 ||
  //       diff.inSeconds > 0 && diff.inMinutes == 0 ||
  //       diff.inMinutes > 0 && diff.inHours == 0 ||
  //       diff.inHours > 0 && diff.inDays == 0) {
  //     time = format.format(date);
  //   } else {
  //     if (diff.inDays == 1) {
  //       time = diff.inDays.toString() + 'DAY AGO';
  //     } else {
  //       time = diff.inDays.toString() + 'DAYS AGO';
  //     }
  //   }

  //   return time;
  // }

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

    print('_isRegisteredUser >>>>>>>>>>>>> ' + _isRegisteredUser.toString());
  }

  getTarget(String id) async {
    _targetWithCondition = await _targetService.fetchTargetsWithCondition(
      'tId',
      _currentUserId,
    );
    print('_targetWithCondition >>>>>>>>>>>>>> ' +
        _targetWithCondition.length.toString());

    for (int i = 0; i < _targetWithCondition.length; i++) {
      _singleTarget = _targetWithCondition[i];
    }
  }

  void initState() {
    super.initState();

    _auth.getCurrentUserId().then((String s) {
      _currentUserId = s;

      setState(() {
        getUserData(_currentUserId);
        getTarget(_currentUserId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final userProvider = Provider.of<UserService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Target',
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Center(
        child: ConditionalBuilder(
          condition: _roleValue != null ||
              _isRegisteredUser != null ||
              _target != null ||
              _singleTarget != null,
          // ||
          // _targetObject != null,
          builder: (context) => ConditionalBuilder(
            condition: _isRegisteredUser,
            builder: (context) => ConditionalBuilder(
              condition: _singleTarget != 'no-target',
              builder: (context) => 
              // Container(
              //   width: mediaQuery.size.width,
              //   height: mediaQuery.size.height,
              //   child:
                 SingleChildScrollView(
                                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      StreamBuilder(
                        stream: userProvider.fetchUsersAsStreamWithCondition(
                            'uId', _currentUserId),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            var _user = snapshot.data.documents
                                .map((doc) =>
                                    User.fromMap(doc.data, doc.documentID))
                                .toList();

                            for (int i = 0; i < _user.length; i++) {
                              _name = _user[i].getName;
                              _email = _user[i].getEmail;
                              _password = _user[i].getPassword;
                              _photo = _user[i].getPhoto;
                              _userRole = _user[i].getRole.toJson();

                              // print('_target >>>>>>>>>>>>> ' + _target.toString());
                              // // print('_targetObject >>>>>>>>>>>>>> ' +
                              // //     _targetObject.toString());
                              // print('_objective >>>>>>>>>>>>> ' +
                              //     _objective.toString());
                              // print('_startDate >>>>>>>>>>>>> ' +
                              //     _startDate.toString());
                              // print(
                              //     '_endDate >>>>>>>>>>>>> ' + _endDate.toString());
                              
                              _target = _user[i].getTarget;

                              _calculation = _user[i].getCalculation;

                              _gender = _user[i].getGender;
                              _age = _user[i].getAge;
                              _weight = _user[i].getWeight;
                              _height = _user[i].getHeight;
                              _activity = _user[i].getActivity;

                              if (_target != 'no-target') {
                                _userTarget = _user[i].getTarget;

                                _objective = _userTarget['objective'] ?? '';
                                _startDate = _userTarget['start_date'] ?? '';
                                _endDate = _userTarget['end_date'] ?? '';
                                _trainingPlace =
                                    _userTarget['training_place'] ?? '';
                                // _activityFactor =
                                //     _userTarget['activity_factor'] ?? '';

                                _startDateToDateTime =
                                    _startDate.toDate().toLocal();
                                _startDateFormat = DateFormat.yMMMEd()
                                    .format(_startDateToDateTime);

                                _endDateToDateTime = _endDate.toDate().toLocal();
                                _endDateFormat = DateFormat.yMMMEd()
                                    .format(_endDateToDateTime);

                                _duration = _endDateToDateTime
                                    .toLocal()
                                    .difference(_startDateToDateTime);

                                x = _endDateToDateTime
                                    .toLocal()
                                    .difference(DateTime.now().toLocal());

                                y = x.compareTo(_duration);

                                z = _endDateToDateTime
                                        .toLocal()
                                        .difference(DateTime.now().toLocal()) -
                                    _startDateToDateTime
                                        .toLocal()
                                        .difference(DateTime.now().toLocal());

                                // if (y == 0) {
                                //   _dynamicDuration = x;
                                // } else {
                                //   _dynamicDuration = z;
                                // }

                                _dynamicDuration =
                                    _endDateToDateTime.difference(DateTime.now());

                                // _days = _dynamicDuration.inDays;

                                _timeStampNow =
                                    // Timestamp.now();
                                    Timestamp.fromMicrosecondsSinceEpoch(
                                            DateTime.now().microsecondsSinceEpoch)
                                        .microsecondsSinceEpoch;

                                _endDateInMicro = _endDate.microsecondsSinceEpoch;

                                print('_timeStampNow >>>>>>>>>>>>> ' +
                                    _timeStampNow.toString());

                                print('_endDateInMicro >>>>>>>>>>>>> ' +
                                    _endDateInMicro.toString());

                                // int _diff = _endDate - _timeStampNow;

                                int _diff = _endDateInMicro - _timeStampNow;

                                _dayInMicro = 24 * 60 * 60 * 1000 * 1000;
                                _days = (_diff / _dayInMicro)
                                    // as int;
                                    .floor();
                                _hours = (_diff /
                                        _dayInMicro /
                                        (60 * 60 * 1000 * 1000))
                                    // as int;
                                    .floor();
                                _minutes =
                                    (_diff / _dayInMicro / (60 * 1000 * 1000))
                                        // .truncate();
                                        // as int;
                                        .floor();
                                _seconds = (_diff / _dayInMicro / (1000 * 1000))
                                    // .truncate();
                                    // as int
                                    .floor();

                                print('_diff >>>>>>>>>>>>> ' + _diff.toString());
                                print('_day micro >>>>>>>>>>>>> ' +
                                    _dayInMicro.toString());
                                print('_NUMBER OF DAYS >>>>>>>>>>>>> ' +
                                    _days.toString());
                                print('_NUMBER OF HOURS >>>>>>>>>>>>> ' +
                                    _hours.toString());
                                print('_NUMBER OF MINUTES >>>>>>>>>>>>> ' +
                                    _minutes.toString());
                                print('_NUMBER OF SECONDS >>>>>>>>>>>>> ' +
                                    _seconds.toString());

                                print('Days >>>>>>>>>>>>>>>  ' +
                                    (_diff / _dayInMicro).toString());

                                print('Hours >>>>>>>>>>>>>>>  ' +
                                    (_diff /
                                            _dayInMicro /
                                            (60 * 60 * 1000 * 1000))
                                        .toString());

                                print('Minutes >>>>>>>>>>>>>>>  ' +
                                    (_diff / _dayInMicro / (60 * 1000 * 1000))
                                        .toString());

                                print('Seconds >>>>>>>>>>>>>>>  ' +
                                    (_diff / _dayInMicro / (1000 * 1000))
                                        .toString());

                                // _dynamicDuration = _endDate - Timestamp.fromMicrosecondsSinceEpoch(
                                //   DateTime.now().microsecondsSinceEpoch);
                                //  y = DateTime.now().subtract(duration)

                                //  z = _duration.inDays -

                                if (_calculation != 'no-calculation') {
                                  _userCalculation = _user[i].getCalculation;

                                  _bmr = _userCalculation['bmr'] ?? 0;
                                  _dailyCalories =
                                      _userCalculation['daily_calories'] ?? 0;
                                  _neededCaloriesForTarget = _userCalculation[
                                          'needed_calories_for_target'] ??
                                      0;
                                  // _consumedCalories =
                                  //     _userCalculation['consumed_calories'] ?? '';
                                }

                                print('DateTime.now() >>>>>>>>>>>>> ' +
                                    DateTime.now().toString());
                                print('_startDateToDateTime >>>>>>>>>>>>> ' +
                                    _startDateToDateTime.toString());
                                print('_endDateToDateTime >>>>>>>>>>>>> ' +
                                    _endDateToDateTime.toString());
                                print('_startDate >>>>>>>>>>>>> ' +
                                    _startDate.toString());
                                print('_endDate >>>>>>>>>>>>> ' +
                                    _endDate.toString());
                                print('_duration >>>>>>>>>>>>> ' +
                                    _duration.toString());
                                print('x >>>>>>>>>>>>> ' + x.toString());
                                print('y >>>>>>>>>>>>> ' + y.toString());
                                print('z >>>>>>>>>>>>> ' + z.toString());
                              }
                            }
                            return ConditionalBuilder(
                              condition: _target != 'no-target',
                              builder: (context) => SingleChildScrollView(
                                                            child: Column(
                                  children: <Widget>[
                                    TargetItem(
                                      userService: _userService,
                                      currentUserId: _currentUserId,
                                      name: _name,
                                      email: _email,
                                      password: _password,
                                      photo: _photo,
                                      role: _userRole,
                                      targetService: _targetService,
                                      objective: _objective,
                                      startDate: _startDateFormat,
                                      endDate: _endDateFormat,
                                      gender: _gender,
                                      age: _age,
                                      weight: _weight,
                                      height: _height,
                                      calculationService: _calculationService,
                                      bmr: _bmr,
                                      dailyCalories: _dailyCalories,
                                      neededCaloriesForTarget:
                                          _neededCaloriesForTarget,
                                      activity: _activity,
                                      trainingPlace: _trainingPlace,
                                    ),
                                    SizedBox(
                                      height: mediaQuery.size.height / 30,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                          CountDownTimerScreen.routeName,
                                          arguments: {
                                            // 'duration': _dynamicDuration,

                                            'days': _days,
                                            'hours': _hours,
                                            'minutes': _minutes,
                                            'seconds': _seconds,

                                            // 'days': _dynamicDuration.inDays,
                                            // 'hours': _dynamicDuration.inHours,
                                            // 'minutes': _dynamicDuration.inMinutes,
                                            // 'seconds': _dynamicDuration.inSeconds,
                                          },
                                        );
                                      },
                                      child: Text('Target Count Down 🤩'),
                                    ),
                                  ],
                                ),
                              ),
                              fallback: (context) => SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FittedBox(
                                      child: Text(
                                        ' Don\'t Have A Target Yet! 🤔 ',
                                        style:
                                            Theme.of(context).textTheme.bodyText2,
                                      ),
                                    ),
                                    SizedBox(
                                      height: mediaQuery.size.height / 30,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return SelectTargetDialog(
                                                currentUserId: _currentUserId,
                                                email: _email,
                                                name: _name,
                                                password: _password,
                                                photo: _photo,
                                                role: _userRole,
                                                userService: _userService,
                                                targetService: _targetService,
                                                calculationService:
                                                    _calculationService,
                                              );
                                            });
                                      },
                                      child: Text('Let\'s Start A Challenge! 😃'),
                                    ),
                                  ],
                                ),
                              ),
                              //  Center(
                              //   child: RaisedButton(
                              //     onPressed: () {
                              //       showDialog(
                              //           context: context,
                              //           builder: (_) {
                              //             return SelectTargetDialog(
                              //               currentUserId: _currentUserId,
                              //               email: _email,
                              //               name: _name,
                              //               password: _password,
                              //               photo: _photo,
                              //               role: _userRole,
                              //               userService: _userService,
                              //               targetService: _targetService,
                              //               calculationService: _calculationService,
                              //             );
                              //           });
                              //     },
                              //     child: Text('Let\'s start a challenge! 😃'),
                              //   ),
                              // ),
                            );
                          } else {
                            return SpinKitChasingDots(
                              color: Theme.of(context).accentColor,
                              size: 60.0,
                            );
                          }
                        },
                      ),
                    ],
                ),
                 ),
              // ),
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
      // ),
      // ),
    );
  }
}
