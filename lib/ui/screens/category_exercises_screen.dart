import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healthy_lifestyle_app/core/models/exercise_model.dart';
// import 'package:healthy_lifestyle_app/core/models/target_model.dart';
import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:healthy_lifestyle_app/core/services/authenticate_service.dart';
import 'package:healthy_lifestyle_app/core/services/exercise_service.dart';
// import 'package:healthy_lifestyle_app/core/services/target_service.dart';
import 'package:healthy_lifestyle_app/core/services/user_service.dart';
import 'package:healthy_lifestyle_app/ui/widgets/exercise_item.dart';
import 'package:provider/provider.dart';

class CategoryExercisesScreen extends StatefulWidget {
  static const routeName = '/category-exercises';

  final args;

  CategoryExercisesScreen({Key key, this.args}) : super(key: key);

  // CategoryExercisesScreen(String categoryName);

  @override
  _CategoryExercisesScreenState createState() =>
      _CategoryExercisesScreenState();
}

class _CategoryExercisesScreenState extends State<CategoryExercisesScreen> {
  String name;
  var category;

  List<Exercise> _exercises;

  final AuthenticateService _auth = AuthenticateService();
  var _currentUserId;
  UserService _userService = new UserService();
  List<User> _userWithCondition;
  // TargetService _targetService = new TargetService();
  // List<Target> _targetWithCondition;
  bool _isRegisteredUser;
  // var _singleTarget;
  String _trainingPlace;
  var _userTarget;
  var _target;

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

  //   for (int i = 0; i < _targetWithCondition.length; i++) {
  //     _singleTarget = _targetWithCondition[i];
  //   }
  // }

  void initState() {
    super.initState();

    _auth.getCurrentUserId().then((String s) {
      _currentUserId = s;

      setState(() {
        getUserData(_currentUserId);
        // getTarget(_currentUserId);
      });
    });
  }

  @override
  void didChangeDependencies() {
    final routeArgs = widget.args;
    name = routeArgs['category_name'];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseService>(context);
    final mediaQuery = MediaQuery.of(context);
    final userProvider = Provider.of<UserService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // StreamBuilder(
            //   // stream: exerciseProvider.fetchExercisesAsStreamWithNestedCondition('category', name),
            //   stream: exerciseProvider.fetchExercisesAsStream(),

            //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //     if (snapshot.hasData) {
            //       _exercises = snapshot.data.documents
            //           .map((doc) => Exercise.fromMap(doc.data, doc.documentID))
            //           .toList();

            //       return Expanded(
            //         child: ConditionalBuilder(
            //           condition: _exercises.isEmpty,
            //           builder: (context) => LayoutBuilder(
            //             builder: (ctx, constraints) {
            //               return Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: <Widget>[
            //                   Text(
            //                     'No exercises added yet!',
            //                     style: Theme.of(context).textTheme.headline6,
            //                   ),
            //                   SizedBox(
            //                     height: mediaQuery.size.height * 0.1,
            //                   ),
            //                   Container(
            //                     height: mediaQuery.size.height * 0.5,
            //                     child: Image.asset(
            //                       'assets/images/waiting.png',
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                 ],
            //               );
            //             },
            //           ),
            //           fallback: (context) => ListView.builder(
            //             itemCount: _exercises.length,
            //             itemBuilder: (buildContext, index) =>
            //                 ConditionalBuilder(
            //               condition:
            //                   _exercises[index].getCategory.toJson()['name'] ==
            //                           name ||
            //                       _trainingPlace != null,
            //               builder: (context) =>
            StreamBuilder(
              stream: userProvider.fetchUsersAsStreamWithCondition(
                  'uId', _currentUserId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var _user = snapshot.data.documents
                      .map((doc) => User.fromMap(doc.data, doc.documentID))
                      .toList();

                  for (int i = 0; i < _user.length; i++) {
                    _target = _user[i].getTarget;

                    if (_target != 'no-target') {
                      _userTarget = _user[i].getTarget;

                      _trainingPlace = _userTarget['training_place'] ?? '';
                    }
                  }

                  return ConditionalBuilder(
                    condition: _target != null || _trainingPlace != null,
                    builder: (context) => ConditionalBuilder(
                      condition: _target != 'no-target',
                      builder: (context) => ConditionalBuilder(
                        condition: _trainingPlace != 'both',
                        builder: (context) => ConditionalBuilder(
                          condition: _trainingPlace == 'home',
                          builder: (context) => StreamBuilder(
                              stream: exerciseProvider
                                  .fetchExercisesAsStreamWithCondition(
                                      'training_place', 'home'),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  _exercises = snapshot.data.documents
                                      .map((doc) => Exercise.fromMap(
                                          doc.data, doc.documentID))
                                      .toList();

                                  return Expanded(
                                    child: ConditionalBuilder(
                                      condition: _exercises.isEmpty,
                                      builder: (context) => LayoutBuilder(
                                        builder: (ctx, constraints) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'No exercises added yet!',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                              SizedBox(
                                                height: mediaQuery.size.height *
                                                    0.1,
                                              ),
                                              Container(
                                                height: mediaQuery.size.height *
                                                    0.5,
                                                child: Image.asset(
                                                  'assets/images/waiting.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      fallback: (context) => ListView.builder(
                                        itemCount: _exercises.length,
                                        itemBuilder: (buildContext, index) =>
                                            ConditionalBuilder(
                                          condition: _exercises[index]
                                                  .getCategory
                                                  .toJson()['name'] ==
                                              name,
                                          builder: (context) => ExerciseItem(
                                            name: _exercises[index].getName,
                                            description: _exercises[index]
                                                .getDescription,
                                            animatedPhotoUrl: _exercises[index]
                                                .getAnimatedPhotoUrl,
                                            videoUrl:
                                                _exercises[index].getVideoUrl,
                                            rate: _exercises[index].getRate,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SpinKitChasingDots(
                                    color: Theme.of(context).accentColor,
                                    size: 60.0,
                                  );
                                }
                              }),

                          // Text('home'),
                          fallback: (context) => StreamBuilder(
                              stream: exerciseProvider
                                  .fetchExercisesAsStreamWithCondition(
                                      'training_place', 'gym'),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  _exercises = snapshot.data.documents
                                      .map((doc) => Exercise.fromMap(
                                          doc.data, doc.documentID))
                                      .toList();

                                  return Expanded(
                                    child: ConditionalBuilder(
                                      condition: _exercises.isEmpty,
                                      builder: (context) => LayoutBuilder(
                                        builder: (ctx, constraints) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'No exercises added yet!',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                              SizedBox(
                                                height: mediaQuery.size.height *
                                                    0.1,
                                              ),
                                              Container(
                                                height: mediaQuery.size.height *
                                                    0.5,
                                                child: Image.asset(
                                                  'assets/images/waiting.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      fallback: (context) => ListView.builder(
                                        itemCount: _exercises.length,
                                        itemBuilder: (buildContext, index) =>
                                            ConditionalBuilder(
                                          condition: _exercises[index]
                                                  .getCategory
                                                  .toJson()['name'] ==
                                              name,
                                          builder: (context) => ExerciseItem(
                                            name: _exercises[index].getName,
                                            description: _exercises[index]
                                                .getDescription,
                                            animatedPhotoUrl: _exercises[index]
                                                .getAnimatedPhotoUrl,
                                            videoUrl:
                                                _exercises[index].getVideoUrl,
                                            rate: _exercises[index].getRate,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SpinKitChasingDots(
                                    color: Theme.of(context).accentColor,
                                    size: 60.0,
                                  );
                                }
                              }),
                          //  Text('gym'),
                        ),
                        fallback: (context) => StreamBuilder(
                            stream: exerciseProvider.fetchExercisesAsStream(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                _exercises = snapshot.data.documents
                                    .map((doc) => Exercise.fromMap(
                                        doc.data, doc.documentID))
                                    .toList();

                                return Expanded(
                                  child: ConditionalBuilder(
                                    condition: _exercises.isEmpty,
                                    builder: (context) => LayoutBuilder(
                                      builder: (ctx, constraints) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'No exercises added yet!',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            ),
                                            SizedBox(
                                              height:
                                                  mediaQuery.size.height * 0.1,
                                            ),
                                            Container(
                                              height:
                                                  mediaQuery.size.height * 0.5,
                                              child: Image.asset(
                                                'assets/images/waiting.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    fallback: (context) => ListView.builder(
                                      itemCount: _exercises.length,
                                      itemBuilder: (buildContext, index) =>
                                          ConditionalBuilder(
                                        condition: _exercises[index]
                                                .getCategory
                                                .toJson()['name'] ==
                                            name,
                                        builder: (context) => ExerciseItem(
                                          name: _exercises[index].getName,
                                          description:
                                              _exercises[index].getDescription,
                                          animatedPhotoUrl: _exercises[index]
                                              .getAnimatedPhotoUrl,
                                          videoUrl:
                                              _exercises[index].getVideoUrl,
                                          rate: _exercises[index].getRate,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return SpinKitChasingDots(
                                  color: Theme.of(context).accentColor,
                                  size: 60.0,
                                );
                              }
                            }),
                        // Text('both'),
                      ),

                      fallback: (context) => StreamBuilder(
                          stream: exerciseProvider.fetchExercisesAsStream(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              _exercises = snapshot.data.documents
                                  .map((doc) => Exercise.fromMap(
                                      doc.data, doc.documentID))
                                  .toList();

                              return Expanded(
                                child: ConditionalBuilder(
                                  condition: _exercises.isEmpty,
                                  builder: (context) => LayoutBuilder(
                                    builder: (ctx, constraints) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'No exercises added yet!',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                          SizedBox(
                                            height:
                                                mediaQuery.size.height * 0.1,
                                          ),
                                          Container(
                                            height:
                                                mediaQuery.size.height * 0.5,
                                            child: Image.asset(
                                              'assets/images/waiting.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  fallback: (context) => ListView.builder(
                                    itemCount: _exercises.length,
                                    itemBuilder: (buildContext, index) =>
                                        ConditionalBuilder(
                                      condition: _exercises[index]
                                              .getCategory
                                              .toJson()['name'] ==
                                          name,
                                      builder: (context) => ExerciseItem(
                                        name: _exercises[index].getName,
                                        description:
                                            _exercises[index].getDescription,
                                        animatedPhotoUrl: _exercises[index]
                                            .getAnimatedPhotoUrl,
                                        videoUrl: _exercises[index].getVideoUrl,
                                        rate: _exercises[index].getRate,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SpinKitChasingDots(
                                color: Theme.of(context).accentColor,
                                size: 60.0,
                              );
                            }
                          }),
                      // Text('both'),
                    ),
                    fallback: (context) => SpinKitChasingDots(
                      color: Theme.of(context).accentColor,
                      size: 60.0,
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
            //               // Text('data'),

            //               //  ExerciseItem(
            //               //   name: _exercises[index].getName,
            //               //   description: _exercises[index].getDescription,
            //               //   animatedPhotoUrl:
            //               //       _exercises[index].getAnimatedPhotoUrl,
            //               //   videoUrl: _exercises[index].getVideoUrl,
            //               //   rate: _exercises[index].getRate,
            //               // ),
            //               fallback: (context) => SpinKitChasingDots(
            //                 color: Theme.of(context).accentColor,
            //                 size: 60.0,
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     } else {
            //       return SpinKitChasingDots(
            //         color: Theme.of(context).accentColor,
            //         size: 60.0,
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
