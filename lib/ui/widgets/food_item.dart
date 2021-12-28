import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:healthy_lifestyle_app/core/models/target_model.dart';
// import 'package:healthy_lifestyle_app/core/models/target_model.dart';
import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:healthy_lifestyle_app/core/services/authenticate_service.dart';
import 'package:healthy_lifestyle_app/core/services/calculation_service.dart';
import 'package:healthy_lifestyle_app/core/services/target_service.dart';
// import 'package:healthy_lifestyle_app/core/services/target_service.dart';
import 'package:healthy_lifestyle_app/core/services/user_service.dart';
import 'package:healthy_lifestyle_app/ui/screens/authenticate/register_screen.dart';
// import 'package:healthy_lifestyle_app/ui/screens/targets_screen.dart';
import 'package:healthy_lifestyle_app/ui/widgets/add_item_to_meal_dialog.dart';
// import 'package:healthy_lifestyle_app/ui/widgets/select_target_dialog.dart';
import 'package:provider/provider.dart';

class FoodItemWidget extends StatefulWidget {
  final String name;
  final String imageUrl;
  final int quantity;
  final int calories;
  final int proteins;
  final int fat;
  final int carb;
  final unit;
  const FoodItemWidget({
    Key key,
    this.name,
    this.imageUrl,
    this.quantity,
    this.calories,
    this.proteins,
    this.fat,
    this.carb,
    this.unit,
  }) : super(key: key);

  @override
  _FoodItemWidgetState createState() => _FoodItemWidgetState();
}

class _FoodItemWidgetState extends State<FoodItemWidget> {
  final AuthenticateService _auth = AuthenticateService();
  var _currentUserId;
  UserService _userService = new UserService();
  List<User> _userWithCondition;
  TargetService _targetService = new TargetService();
  // List<Target> _targetWithCondition;
  CalculationService _calculationService = new CalculationService();
  bool _isRegisteredUser;
  String _name;
  String _email;
  String _password;
  String _photo;
  var _userRole;
  int _roleValue;
  // var _singleTarget;
  var _userTarget;
  var _calculation;
  var _userCalculation;
  var _target;
  double _bmr;
  int _dailyCalories;
  int _neededCaloriesForTarget;
  int _consumedCalories;
  String _gender;
  // double _activityFactor;
  String _activity;
  int _age, _weight, _height;
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

  // getTarget(String id) async {
  //   _targetWithCondition = await _targetService.fetchTargetsWithCondition(
  //     'tId',
  //     _currentUserId,
  //   );
  //   print('_targetWithCondition >>>>>>>>>>>>>> ' +
  //       _targetWithCondition.length.toString());

  //   // for (int i = 0; i < _targetWithCondition.length; i++) {
  //   //   _singleTarget = _targetWithCondition[i];
  //   // }
  // }

  void initState() {
    super.initState();

    _auth.getCurrentUserId().then((String s) {
      _currentUserId = s;

      setState(() {
        getUserData(_currentUserId);
        // getTarget(_currentUserId);
      });
      // setState(() {

      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final userProvider = Provider.of<UserService>(context);

    return
        // InkWell(
        //   onTap: () => () {},
        // selectMeal(context),
        // child:
        Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      elevation: 10,
      margin: EdgeInsets.all(mediaQuery.size.width / 30),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        actions: <Widget>[
          IconSlideAction(
            caption: 'Details',
            color: Theme.of(context).secondaryHeaderColor,
            icon: Icons.details,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      backgroundColor: Theme.of(context).canvasColor,
                      content: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            right: -40.0,
                            top: -40.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                child: Icon(Icons.close),
                                backgroundColor: Theme.of(context).errorColor,
                              ),
                            ),
                          ),
                          Table(
                            border: TableBorder.all(
                              width: 2.0,
                              color: Theme.of(context).secondaryHeaderColor,
                              // style:BorderStyle.solid
                            ),
                            children: [
                              TableRow(
                                // decoration: ,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                        mediaQuery.size.width / 50),
                                    child: Text(
                                      'Calories per ${widget.quantity} ${widget.unit}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontSize: 12,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        mediaQuery.size.width / 30),
                                    child: Text(
                                      '${widget.calories}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontSize: 12,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                // decoration: ,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                        mediaQuery.size.width / 50),
                                    child: Text(
                                      'Proteins per ${widget.quantity} ${widget.unit}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontSize: 12,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        mediaQuery.size.width / 30),
                                    child: Text(
                                      '${widget.proteins}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontSize: 12,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                // decoration: ,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                        mediaQuery.size.width / 50),
                                    child: Text(
                                      'Fat per ${widget.quantity} ${widget.unit}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontSize: 12,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        mediaQuery.size.width / 30),
                                    child: Text(
                                      '${widget.fat}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontSize: 12,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                // decoration: ,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                        mediaQuery.size.width / 50),
                                    child: Text(
                                      'Carb per ${widget.quantity} ${widget.unit}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontSize: 12,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        mediaQuery.size.width / 30),
                                    child: Text(
                                      '${widget.carb}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontSize: 12,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  });
            },
          ),
        ],
        secondaryActions: <Widget>[
          ConditionalBuilder(
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
                        print(
                            '_userRole >>>>>>>>>>>>>> ' + _userRole.toString());
                        _roleValue = _userRole['value'] ?? '';

                        _gender = _user[i].getGender;
                        _age = _user[i].getAge;
                        _weight = _user[i].getWeight;
                        _height = _user[i].getHeight;
                        _activity = _user[i].getActivity;
                        // setState(() {
                        _target = _user[i].getTarget;
                        _calculation = _user[i].getCalculation;

                        if (_target != 'no-target') {
                          _userTarget = _user[i].getTarget;
                          print('_userTarget >>>>>>>>>>>>>> ' +
                              _userTarget.toString());

                          _userTarget = _user[i].getTarget;

                          // _objective = _userTarget['objective'] ?? '';
                          // _startDate = _userTarget['start_date'] ?? '';
                          // _endDate = _userTarget['end_date'] ?? '';
                          // _trainingPlace =
                          //     _userTarget['training_place'] ?? '';
                          // _activityFactor =
                          //     _userTarget['activity_factor'] ?? '';

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
                        }
                        // });
                      }
                      return ConditionalBuilder(
                        condition: _roleValue != null || _target != null,
                        builder: (context) => ConditionalBuilder(
                            condition: _roleValue == 2,
                            builder: (context) => IconSlideAction(
                                  caption: 'Add',
                                  color: Theme.of(context).secondaryHeaderColor,
                                  icon: Icons.add_circle,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ConditionalBuilder(
                                          condition: _target != 'no-target',
                                          builder: (context) =>
                                              AddItemToMealDialog(
                                            hasTarget: 1,
                                            currentUserId: _currentUserId,
                                            email: _email,
                                            name: _name,
                                            password: _password,
                                            photo: _photo,
                                            role: _userRole,
                                            userService: _userService,
                                            targetService: _targetService,
                                            target: _target,
                                            gender: _gender,
                                            calculation: _calculation,
                                            age: _age,
                                            weight: _weight,
                                            height: _height,
                                            activity: _activity,
                                            calculationService:
                                                _calculationService,
                                            quantity: widget.quantity,
                                            calories: widget.calories,
                                            unit: widget.unit,
                                            bmr: _bmr,
                                            dailyCalories: _dailyCalories,
                                            neededCaloriesForTarget:
                                                _neededCaloriesForTarget,
                                            consumedCalories: _consumedCalories,
                                          ),

                                          //  AlertDialog(
                                          //   shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(4.0),
                                          //   ),
                                          //   backgroundColor:
                                          //       Theme.of(context).canvasColor,
                                          //   content: Stack(
                                          //     overflow: Overflow.visible,
                                          //     children: <Widget>[
                                          //       Positioned(
                                          //         right: -40.0,
                                          //         top: -40.0,
                                          //         child: InkResponse(
                                          //           onTap: () {
                                          //             Navigator.of(context)
                                          //                 .pop();
                                          //           },
                                          //           child: CircleAvatar(
                                          //             child: Icon(Icons.close),
                                          //             backgroundColor:
                                          //                 Theme.of(context)
                                          //                     .errorColor,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       SingleChildScrollView(
                                          //         child: Center(
                                          //           child: Text(
                                          //             'Coming... 😃',
                                          //             style: Theme.of(context)
                                          //                 .textTheme
                                          //                 .bodyText2,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          fallback: (context) =>
                                              AddItemToMealDialog(
                                            hasTarget: 0,
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
                                          ),

                                          // AlertDialog(
                                          //   shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(4.0),
                                          //   ),
                                          //   backgroundColor:
                                          //       Theme.of(context).canvasColor,
                                          //   content: Stack(
                                          //     overflow: Overflow.visible,
                                          //     children: <Widget>[
                                          //       Positioned(
                                          //         right: -40.0,
                                          //         top: -40.0,
                                          //         child: InkResponse(
                                          //           onTap: () {
                                          //             Navigator.of(context)
                                          //                 .pop();
                                          //           },
                                          //           child: CircleAvatar(
                                          //             child: Icon(Icons.close),
                                          //             backgroundColor:
                                          //                 Theme.of(context)
                                          //                     .errorColor,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       SingleChildScrollView(
                                          //         child: Column(
                                          //           mainAxisAlignment:
                                          //               MainAxisAlignment
                                          //                   .center,
                                          //           children: <Widget>[
                                          //             FittedBox(
                                          //               child: Text(
                                          //                 ' Don\'t Have a Targt Yet! 🤔 ',
                                          //                 style:
                                          //                     Theme.of(context)
                                          //                         .textTheme
                                          //                         .bodyText2,
                                          //               ),
                                          //             ),
                                          //             SizedBox(
                                          //               height: mediaQuery
                                          //                       .size.height /
                                          //                   30,
                                          //             ),
                                          //             RaisedButton(
                                          //               onPressed: () {
                                          //                 Navigator.of(context)
                                          //                     .pushNamed(
                                          //                         TargetsScreen
                                          //                             .routeName);
                                          //               },
                                          //               child: FittedBox(
                                          //                 child: Text(
                                          //                     'Let\'s start a challenge! 😃'),
                                          //               ),
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                        );
                                      },
                                    );
                                  },
                                ),
                            // fallback: (context) => IconSlideAction(
                            //   caption: 'Add',
                            //   color:
                            //       Theme.of(context).secondaryHeaderColor,
                            //   icon: Icons.add_circle,
                            //   onTap: () {
                            //     showDialog(
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return AlertDialog(
                            //           shape: RoundedRectangleBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(4.0),
                            //           ),
                            //           backgroundColor:
                            //               Theme.of(context).canvasColor,
                            //           content: Stack(
                            //             overflow: Overflow.visible,
                            //             children: <Widget>[
                            //               Positioned(
                            //                 right: -40.0,
                            //                 top: -40.0,
                            //                 child: InkResponse(
                            //                   onTap: () {
                            //                     Navigator.of(context)
                            //                         .pop();
                            //                   },
                            //                   child: CircleAvatar(
                            //                     child: Icon(Icons.close),
                            //                     backgroundColor:
                            //                         Theme.of(context)
                            //                             .errorColor,
                            //                   ),
                            //                 ),
                            //               ),
                            //               // Center(
                            //               //   child:
                            //               RaisedButton(
                            //                 onPressed: () {
                            //                   Navigator.of(context)
                            //                       .pushNamed(TargetsScreen
                            //                           .routeName);
                            //                 },
                            //                 child: FittedBox(
                            //                   child: Text(
                            //                       'Let\'s start a challenge! 😃'),
                            //                 ),
                            //               ),
                            //               // ),
                            //             ],
                            //           ),
                            //         );
                            //       },
                            //     );
                            //   },
                            // ),

                            // ),

                            //   fallback: (context) => SpinKitChasingDots(
                            //     color: Theme.of(context).accentColor,
                            //     size: 60.0,
                            //   ),
                            // ),
                            //   ),
                            // ),
                            fallback: (context) => Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                  ),
                                )
                            // SpinKitChasingDots(
                            //   color: Theme.of(context).accentColor,
                            //   size: 60.0,
                            // ),
                            ),
                      );
                    } else {
                      return SpinKitChasingDots(
                        color: Theme.of(context).accentColor,
                        size: 60.0,
                      );
                    }
                  }),
              fallback: (context) => IconSlideAction(
                caption: 'Add',
                color: Theme.of(context).secondaryHeaderColor,
                icon: Icons.add_circle,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        backgroundColor: Theme.of(context).canvasColor,
                        content: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              right: -40.0,
                              top: -40.0,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.close),
                                  backgroundColor: Theme.of(context).errorColor,
                                ),
                              ),
                            ),
                            LayoutBuilder(
                              builder: (ctx, constraints) {
                                return SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Welcome 😃',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      SizedBox(
                                        height: mediaQuery.size.height / 30,
                                      ),
                                      FittedBox(
                                        child: Text(
                                          ' Don\'t Have An Account Yet! 🤔 ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaQuery.size.height / 30,
                                      ),
                                      Text(
                                        'Join Us 🤩',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      SizedBox(
                                        height: mediaQuery.size.height / 30,
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              RegisterScreen.routeName);
                                        },
                                        child: Text('Register'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            fallback: (context) => SpinKitChasingDots(
              color: Theme.of(context).accentColor,
              size: 60.0,
            ),
          ),

          // IconSlideAction(
          //   caption: 'Add',
          //   color: Theme.of(context).secondaryHeaderColor,
          //   icon: Icons.add_circle,
          //   onTap: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(4.0),
          //           ),
          //           backgroundColor: Theme.of(context).canvasColor,
          //           content: Stack(
          //             overflow: Overflow.visible,
          //             children: <Widget>[
          //               Positioned(
          //                 right: -40.0,
          //                 top: -40.0,
          //                 child: InkResponse(
          //                   onTap: () {
          //                     Navigator.of(context).pop();
          //                   },
          //                   child: CircleAvatar(
          //                     child: Icon(Icons.close),
          //                     backgroundColor: Theme.of(context).errorColor,
          //                   ),
          //                 ),
          //               ),

          //                     return ConditionalBuilder(
          //                       condition: _target != null,
          //                       builder: (context) => ConditionalBuilder(
          //                         condition: _target != 'no-target',
          //                         builder: (context) => Center(
          //                           child: RaisedButton(
          //                             onPressed: () {
          //                               Navigator.of(context)
          //                                   .pushNamed(TargetsScreen.routeName);
          //                             },
          //                             child:
          //                                 Text('Let\'s start a challenge! 😃'),
          //                           ),
          //                         ),
          //                         fallback: (context) => SpinKitChasingDots(
          //                           color: Theme.of(context).accentColor,
          //                           size: 60.0,
          //                         ),
          //                       ),
          //                     );
          //                   } else {
          //                     return SpinKitChasingDots(
          //                       color: Theme.of(context).accentColor,
          //                       size: 60.0,
          //                     );
          //                   }
          //                 },
          //               ),
          //               // Text(
          //               //   'Add',
          //               //   style: Theme.of(context).textTheme.bodyText2.copyWith(
          //               //         fontSize: 12,
          //               //       ),
          //               //   textAlign: TextAlign.center,
          //               // ),
          //             ],
          //           ),
          //         );
          //       },
          //     );
          //   },
          // ),
        ],
        child: Container(
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
              mediaQuery.size.width / 60,
            ),
            leading: Container(
              // width: mediaQuery.size.width * 0.25,
              // height: mediaQuery.size.height * 0.5,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                radius: 30,

                child: ConditionalBuilder(
                  condition: widget.imageUrl == '',
                  builder: (context) {
                    return Container(
                      // width: mediaQuery.size.width,
                      // height: mediaQuery.size.height,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(7.0),
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
                      // width: mediaQuery.size.width,
                      // height: mediaQuery.size.height,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(7.0),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.imageUrl,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // ),
              ),
            ),
            // ),
            title: Padding(
              padding: EdgeInsets.only(
                bottom: mediaQuery.size.width / 90,
              ),
              child: Text(
                '${widget.name}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            // subtitle:
          ),
        ),
      ),
      // ),
    );
  }
}
