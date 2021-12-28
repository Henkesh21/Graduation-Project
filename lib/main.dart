import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_lifestyle_app/core/models/calculation_model.dart';
import 'package:healthy_lifestyle_app/core/models/target_model.dart';
import 'package:healthy_lifestyle_app/core/services/calculation_service.dart';
import 'package:healthy_lifestyle_app/core/services/category_service.dart';
import 'package:healthy_lifestyle_app/core/services/exercise_service.dart';
import 'package:healthy_lifestyle_app/core/services/food_item_service.dart';
import 'package:healthy_lifestyle_app/core/services/target_service.dart';

import 'package:provider/provider.dart';
// import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:healthy_lifestyle_app/core/services/authenticate_service.dart';
import 'package:healthy_lifestyle_app/core/services/role_service.dart';
import 'package:healthy_lifestyle_app/core/services/user_service.dart';
import 'package:healthy_lifestyle_app/notifiers/dark_theme_provider.dart';
import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:healthy_lifestyle_app/utils/styles.dart';
import 'package:healthy_lifestyle_app/ui/router.dart';
import 'package:workmanager/workmanager.dart';

import 'core/services/module_service.dart';

void printHello() {
  // ignore: unused_local_variable
  final DateTime now = DateTime.now();
  // ignore: unused_local_variable
  final int isolateId = Isolate.current.hashCode;
  // print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  print('HELLO...........!!!!!!!!!!!!');
}

final AuthenticateService _auth = AuthenticateService();

var _currentUserId;

UserService _userService = new UserService();
List<User> _userWithCondition;
// ignore: unused_element
TargetService _targetService = new TargetService();
// ignore: unused_element
List<Target> _targetWithCondition;
CalculationService _calculationService = new CalculationService();
// List<Calculation> _calculationWithCondition;

bool _isRegisteredUser;
String _name;
String _email;
String _password;
String _photo;

var _userRole;
// ignore: unused_element
int _roleValue;

var _userTarget;
var _target;
// ignore: unused_element
var _singleTarget;
// ignore: unused_element
String _objective;
// ignore: unused_element
Timestamp _startDate;
// ignore: unused_element
Timestamp _endDate;
// ignore: unused_element
DateTime _startDateToDateTime;
// ignore: unused_element
DateTime _endDateToDateTime;

// ignore: unused_element
var _startDateFormat;
// ignore: unused_element
var _endDateFormat;
// ignore: unused_element
Duration _duration;
Duration x;
// ignore: unused_element
Duration _dynamicDuration;
var y;
var z;
// ignore: unused_element
int _timeStampNow;
// ignore: unused_element
int _endDateInMicro;

var _calculation;
var _userCalculation;

String _gender;
String _activity;

int _age, _weight, _height;
// ignore: unused_element
String _trainingPlace;
double _bmr;
int _dailyCalories;
int _neededCaloriesForTarget;
// ignore: unused_element
int _consumedCalories;

resetConsumedCaloriesEveryDay() async {
  _auth.getCurrentUser().then((user) async {
    if (user != null) {
      _auth.getCurrentUserId().then((String s) async {
        _currentUserId = s;
        _userWithCondition =
            await _userService.fetchUsersWithCondition('uId', _currentUserId);
        if (_userWithCondition.isEmpty) {
          // setState(() {
          _isRegisteredUser = false;
          // });
        } else {
          // setState(() {
          _isRegisteredUser = true;
          // });
        }
        print('_isRegisteredUser from myApp() >>>>>>>>>>>>>' +
            _isRegisteredUser.toString());

        if (_isRegisteredUser == true) {
          for (int i = 0; i < _userWithCondition.length; i++) {
            _name = _userWithCondition[i].getName;
            _email = _userWithCondition[i].getEmail;
            _password = _userWithCondition[i].getPassword;
            _photo = _userWithCondition[i].getPhoto;
            _userRole = _userWithCondition[i].getRole.toJson();

            _target = _userWithCondition[i].getTarget;

            _calculation = _userWithCondition[i].getCalculation;
            _gender = _userWithCondition[i].getGender;
            _age = _userWithCondition[i].getAge;
            _weight = _userWithCondition[i].getWeight;
            _height = _userWithCondition[i].getHeight;
            _activity = _userWithCondition[i].getActivity;
            if (_target != 'no-target') {
              _userTarget = _userWithCondition[i].getTarget;

              _objective = _userTarget['objective'] ?? '';
              _startDate = _userTarget['start_date'] ?? '';
              _endDate = _userTarget['end_date'] ?? '';
              _trainingPlace = _userTarget['training_place'] ?? '';
              // _activityFactor =
              //     _userTarget['activity_factor'] ?? '';

              if (_calculation != 'no-calculation') {
                _userCalculation = _userWithCondition[i].getCalculation;

                _bmr = _userCalculation['bmr'] ?? 0;
                _dailyCalories = _userCalculation['daily_calories'] ?? 0;
                _neededCaloriesForTarget =
                    _userCalculation['needed_calories_for_target'] ?? 0;
                _consumedCalories = _userCalculation['consumed_calories'] ?? 0;
              }
              var newCalculation =
                  await _calculationService.addCalculationWithCustomId(
                Calculation.fromCalculation(
                  cId: _currentUserId,
                  bmr: _bmr,
                  dailyCalories: _dailyCalories,
                  neededCaloriesForTarget: _neededCaloriesForTarget,
                  consumedCalories: 0,
                ),
                _currentUserId,
              );

              await _userService.updateUser(
                User.fromUser(
                  uId: _currentUserId,
                  email: _email,
                  password: _password,
                  name: _name,
                  photo: _photo,
                  role: _userRole,
                  target: _target,
                  gender: _gender,
                  calculation: newCalculation,
                  age: _age,
                  weight: _weight,
                  height: _height,
                  activity: _activity,
                ),
                _currentUserId,
              );
            }
          }
        }
      });
    }
  });
}

void callbackDispatcher() {
  Workmanager.executeTask((backgroundTask, inputData) {
    switch (backgroundTask) {
      case Workmanager.iOSBackgroundTask:
      case "firebaseTask":
        print("You are now in a background Isolate");
        print("Do some work with Firebase");
        resetConsumedCaloriesEveryDay();
        // Firebase.doSomethingHere();
        break;
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  // // TestWidgetsFlutterBinding.ensureInitialized();
  // Calculation calculation;
  // final int alarmID = 0;
  // await AndroidAlarmManager.initialize();
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager.initialize(callbackDispatcher);
  Workmanager.registerPeriodicTask(
    "1",
    "firebaseTask",
    frequency: Duration(minutes: 15),
    // constraints: WorkManagerConstraintConfig(networkType: NetworkType.connected),
  );
  runApp(MyApp());
  // await AndroidAlarmManager.periodic(
  //   const Duration(minutes: 1),
  //   alarmID,
  //   printHello,
  //   wakeup: true,
  // );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  // RoleService roleProvider = new RoleService();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthenticateService().user,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) {
              return themeChangeProvider;
            },
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) {
              return RoleService();
            },
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) {
              return UserService();
            },
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) {
              return ModuleService();
            },
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) {
              return CategoryService();
            },
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) {
              return ExerciseService();
            },
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) {
              return FoodItemService();
            },
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) {
              return TargetService();
            },
          ),
        ],
        child: Consumer<DarkThemeProvider>(
            builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            initialRoute: '/',
            onGenerateRoute: Router.generateRoute,
          );
        }),
      ),
    );
  }
}
