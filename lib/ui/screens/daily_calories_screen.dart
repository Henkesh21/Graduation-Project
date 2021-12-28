import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_lifestyle_app/core/models/calculation_model.dart';
// import 'package:healthy_lifestyle_app/core/models/calculation_model.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:healthy_lifestyle_app/core/models/role_model.dart';
import 'package:healthy_lifestyle_app/core/models/target_model.dart';
import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:healthy_lifestyle_app/core/services/authenticate_service.dart';
import 'package:healthy_lifestyle_app/core/services/calculation_service.dart';
import 'package:healthy_lifestyle_app/core/services/target_service.dart';
import 'package:healthy_lifestyle_app/core/services/user_service.dart';
// import 'package:healthy_lifestyle_app/ui/screens/count_down_timer_screen.dart';
// import 'package:healthy_lifestyle_app/ui/screens/targets_screen.dart';
// import 'package:healthy_lifestyle_app/ui/screens/settings_screen.dart';
import 'package:healthy_lifestyle_app/ui/widgets/select_target_dialog.dart';
// import 'package:healthy_lifestyle_app/ui/widgets/target_item.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// import 'package:healthy_lifestyle_app/ui/widgets/edit_profile_dialog.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
import 'authenticate/register_screen.dart';

class DailyCaloriesScreen extends StatefulWidget {
  static const routeName = '/daily-calories';
  // final args;

  // const DailyCaloriesScreen({Key key, this.args}) : super(key: key);

  @override
  _DailyCaloriesScreenState createState() => _DailyCaloriesScreenState();
}

class _DailyCaloriesScreenState extends State<DailyCaloriesScreen> {
  final AuthenticateService _auth = AuthenticateService();

  var _currentUserId;

  UserService _userService = new UserService();
  List<User> _userWithCondition;
  TargetService _targetService = new TargetService();
  List<Target> _targetWithCondition;
  CalculationService _calculationService = new CalculationService();
  // ignore: unused_field
  List<Calculation> _calculationWithCondition;

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
  // Timestamp _startDate;
  // Timestamp _endDate;
  // DateTime _startDateToDateTime;
  // DateTime _endDateToDateTime;

  // var _startDateFormat;
  // var _endDateFormat;
  // Duration _duration;
  // Duration x;
  // Duration _dynamicDuration;
  // var y;
  // var z;

  var _calculation;
  var _userCalculation;

  // ignore: unused_field
  String _gender;
  // ignore: unused_field
  String _activity;

  // ignore: unused_field
  int _age, _weight, _height;
  // String _trainingPlace;

  // ignore: unused_field
  double _bmr;
  int _dailyCalories;
  int _neededCaloriesForTarget;
  int _consumedCalories;
  // int _days, _hours, _minutes, _seconds;

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
          'Daily Calories',
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
              builder: (context) => Container(
                width: mediaQuery.size.width,
                height: mediaQuery.size.height,
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

                            _target = _user[i].getTarget;
                            _age = _user[i].getAge;
                            _weight = _user[i].getWeight;
                            _height = _user[i].getHeight;
                            _activity = _user[i].getActivity;
                            _calculation = _user[i].getCalculation;

                            if (_target != 'no-target') {
                              _userTarget = _user[i].getTarget;

                              _objective = _userTarget['objective'] ?? '';

                              _gender = _user[i].getGender;

                              if (_calculation != 'no-calculation') {
                                _userCalculation = _user[i].getCalculation;

                                _bmr = _userCalculation['bmr'] ?? 0.0;
                                _dailyCalories =
                                    _userCalculation['daily_calories'] ?? 0;
                                _neededCaloriesForTarget = _userCalculation[
                                        'needed_calories_for_target'] ??
                                    0;
                                _consumedCalories =
                                    _userCalculation['consumed_calories'] ?? 0;
                              }

                              // if(){

                              // _remainingCalories = _calculationService
                              //     .calculateRemainingCalories(
                              //   _neededCaloriesForTarget,
                              //   _consumedCalories,
                              //   _quantity,
                              //   _calories,
                              //   _userEnteredQuantity,
                              // );

                              // var newCalculation = await _calculationService.addCalculationWithCustomId(
                              //   Calculation.fromCalculation(
                              //     cId: _currentUserId,
                              //     bmr: _bmr,
                              //     dailyCalories: _dailyCalories,
                              //     neededCaloriesForTarget:
                              //         _neededCaloriesForTarget,
                              //     consumedCalories: _totalConsumedCalories,
                              //   ),
                              //   _currentUserId,
                              // );

                              // await _userService.updateUser(
                              //   User.fromUser(
                              //     uId: _currentUserId,
                              //     email: _email,
                              //     password: _password,
                              //     name: _name,
                              //     photo: _photo,
                              //     role: _role,
                              //     target: _target,
                              //     gender: _gender,
                              //     calculation: newCalculation,
                              //     age: _age,
                              //     weight: _weight,
                              //     height: _height,
                              //     activity: _activity,
                              //   ),
                              //   _currentUserId,
                              // );}
                            }
                          }
                          return ConditionalBuilder(
                            condition: _target != 'no-target',
                            builder: (context) => Column(
                              children: <Widget>[
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  elevation: 10,
                                  margin: EdgeInsets.all(
                                      mediaQuery.size.width / 30),
                                  child:
                                      //Slidable(
                                      //   actionPane: SlidableDrawerActionPane(),
                                      //   actionExtentRatio: 0.25,
                                      //   actions: <Widget>[
                                      //     IconSlideAction(
                                      //       caption: 'Edit',
                                      //       color: Theme.of(context)
                                      //           .secondaryHeaderColor,
                                      //       icon: Icons.edit,
                                      //       onTap: () {
                                      //         showDialog(
                                      //             context: context,
                                      //             builder: (_) {
                                      //               return EditTargetDialog(
                                      //                 userService: widget.userService,
                                      //                 currentUserId:
                                      //                     widget.currentUserId,
                                      //                 name: widget.name,
                                      //                 email: widget.email,
                                      //                 password: widget.password,
                                      //                 photo: widget.photo,
                                      //                 role: widget.role,
                                      //                 targetService:
                                      //                     widget.targetService,
                                      //                 objective: widget.objective,
                                      //                 // startDate: widget.startDate,
                                      //                 // endDate: widget.endDate,
                                      //                 gender: widget.gender,
                                      //                 age: widget.age,
                                      //                 weight: widget.weight,
                                      //                 height: widget.height,
                                      //                 calculationService:
                                      //                     widget.calculationService,
                                      //                 // bmr: widget.bmr,
                                      //                 // dailyCalories: widget.dailyCalories,
                                      //                 // neededCaloriesForTarget: widget.neededCaloriesForTarget,
                                      //                 activity: widget.activity,
                                      //                 trainingPlace:
                                      //                     widget.trainingPlace,
                                      //               );
                                      //             });
                                      //       },
                                      //     ),
                                      //   ],
                                      //   secondaryActions: <Widget>[
                                      //     IconSlideAction(
                                      //         caption: 'Cancel',
                                      //         color: Theme.of(context)
                                      //             .secondaryHeaderColor,
                                      //         icon: Icons.cancel,
                                      //         onTap: () async {
                                      //           await widget.targetService
                                      //               .deleteTarget(
                                      //                   widget.currentUserId);
                                      //           await widget.calculationService
                                      //               .deleteCalculation(
                                      //                   widget.currentUserId);
                                      //           await widget.userService.updateUser(
                                      //             User.fromUser(
                                      //               uId: widget.currentUserId,
                                      //               email: widget.email,
                                      //               password: widget.password,
                                      //               name: widget.name,
                                      //               photo: widget.photo,
                                      //               role: widget.role,
                                      //               target: 'no-target',
                                      //               gender: 'no-gender',
                                      //               calculation: 'no-calculation',
                                      //               age: null,
                                      //               weight: null,
                                      //               height: null,
                                      //               activity: 'no-activity',
                                      //             ),
                                      //             widget.currentUserId,
                                      //           );
                                      //         }),
                                      //   ],
                                      //   child:
                                      Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
                                      borderRadius: BorderRadius.circular(7.0),
                                      border: Border.all(
                                        color: Theme.of(context).accentColor,
                                        width: 3.0,
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(
                                        mediaQuery.size.width / 50,
                                      ),
                                      leading: Container(
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).accentColor,
                                          radius: 30,
                                          child: Icon(
                                            FontAwesomeIcons.tasks,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      title: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: mediaQuery.size.height / 50,
                                          ),
                                          child: Text(
                                            'Your Calories',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          )),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          FittedBox(
                                            child: Text(
                                              'Normal Calories: $_dailyCalories Kcal',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 0,
                                              vertical:
                                                  mediaQuery.size.height / 50,
                                            ),
                                          ),
                                          FittedBox(
                                            child: Text(
                                              'Target Calories: $_neededCaloriesForTarget Kcal',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 0,
                                              vertical:
                                                  mediaQuery.size.height / 50,
                                            ),
                                          ),
                                          FittedBox(
                                            child: Text(
                                              'Consumed Calories: $_consumedCalories Kcal',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 0,
                                              vertical:
                                                  mediaQuery.size.height / 50,
                                            ),
                                          ),
                                          FittedBox(
                                            child: Text(
                                              'Remaining Calories: ${_neededCaloriesForTarget - _consumedCalories} Kcal',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 0,
                                              vertical:
                                                  mediaQuery.size.height / 50,
                                            ),
                                          ),
                                          // FittedBox(
                                          //   child:
                                          ConditionalBuilder(
                                            condition: _objective == 'cut',
                                            builder: (context) => Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Hint:',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                        fontSize: 12,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical:
                                                        mediaQuery.size.width /
                                                            90,
                                                  ),
                                                ),
                                                Text(
                                                  'You can subtract up to 500 : 1000 Kcal from your normal calories',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                        fontSize: 12,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            fallback: (context) => Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Hint:',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                        fontSize: 12,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical:
                                                        mediaQuery.size.width /
                                                            90,
                                                  ),
                                                ),
                                                Text(
                                                  'You can add up to 500 : 1000 Kcal from your normal calories',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                        fontSize: 12,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ),
                                )

                                // TargetItem(
                                //   userService: _userService,
                                //   currentUserId: _currentUserId,
                                //   name: _name,
                                //   email: _email,
                                //   password: _password,
                                //   photo: _photo,
                                //   role: _userRole,
                                //   targetService: _targetService,
                                //   objective: _objective,
                                //   startDate: _startDateFormat,
                                //   endDate: _endDateFormat,
                                //   gender: _gender,
                                //   age: _age,
                                //   weight: _weight,
                                //   height: _height,
                                //   calculationService: _calculationService,
                                //   bmr: _bmr,
                                //   dailyCalories: _dailyCalories,
                                //   neededCaloriesForTarget:
                                //       _neededCaloriesForTarget,
                                //   activity: _activity,
                                //   trainingPlace: _trainingPlace,
                                // ),
                                // SizedBox(
                                //   height: mediaQuery.size.height / 30,
                                // ),
                                // RaisedButton(
                                //   onPressed: () {
                                //     Navigator.of(context).pushNamed(
                                //       CountDownTimerScreen.routeName,
                                //       arguments: {
                                //         'duration': _dynamicDuration,

                                //         // 'days': _days,
                                //         // 'hours': _hours,
                                //         // 'minutes': _minutes,
                                //         // 'seconds': _seconds,
                                //       },
                                //     );
                                //   },
                                //   child: Text('Target Count Down 🤩'),
                                // ),
                              ],
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
                                      // Navigator.of(context).pushReplacementNamed(
                                      //     TargetsScreen.routeName);
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
