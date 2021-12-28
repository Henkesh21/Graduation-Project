import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/core/models/exercise_model.dart';
// import 'package:healthy_lifestyle_app/core/services/category_service.dart';
import 'package:healthy_lifestyle_app/core/services/exercise_service.dart';
import 'package:healthy_lifestyle_app/ui/widgets/add_exercise_dialog.dart';
import 'package:healthy_lifestyle_app/ui/widgets/edit_exercise_dialog.dart';
import 'package:healthy_lifestyle_app/ui/widgets/video_player_dialog.dart';
import 'package:provider/provider.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ExercisesScreen extends StatefulWidget {
  static const routeName = '/exercises';
  ExercisesScreen({Key key}) : super(key: key);

  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<Exercise> _exercises;

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseService>(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return AddExerciseDialog(
                  exerciseProvider: exerciseProvider,
                );
              });
        },
      ),
      appBar: AppBar(
        title: Text(
          'Exercises',
          style: Theme.of(context).textTheme.headline6,
        ),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: exerciseProvider.fetchExercisesAsStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  _exercises = snapshot.data.documents
                      .map((doc) => Exercise.fromMap(doc.data, doc.documentID))
                      .toList();

                  return Expanded(
                    child: ConditionalBuilder(
                      condition: _exercises.isEmpty,
                      builder: (context) => LayoutBuilder(
                        builder: (ctx, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'No exercises added yet!',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(
                                height: mediaQuery.size.height * 0.1,
                              ),
                              Container(
                                height: mediaQuery.size.height * 0.5,
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
                        itemBuilder: (buildContext, index) => Card(
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
                                caption: 'View video',
                                color: Theme.of(context).secondaryHeaderColor,
                                icon: Icons.video_label,
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return VideoPlayerDialog(
                                            videoUrl:
                                                _exercises[index].getVideoUrl);
                                      });
                                },
                              ),
                            ],
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Edit',
                                color: Theme.of(context).secondaryHeaderColor,
                                icon: Icons.edit,
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return EditExerciseDialog(
                                          exerciseProvider: exerciseProvider,
                                          name: _exercises[index].getName,
                                          description:
                                              _exercises[index].getDescription,
                                          category: _exercises[index]
                                                  .getCategory
                                                  .toJson()['name'] ??
                                              '',
                                          animatedPhotoUrl: _exercises[index]
                                              .getAnimatedPhotoUrl,
                                          id: _exercises[index].geteId,
                                          videoUrl:
                                              _exercises[index].getVideoUrl,
                                          trainingPlace: _exercises[index]
                                              .getTrainingPlace,
                                        );
                                      });
                                },
                              ),
                              IconSlideAction(
                                caption: 'Delete',
                                color: Theme.of(context).errorColor,
                                icon: Icons.delete,
                                onTap: () async => await exerciseProvider
                                    .deleteExercise(_exercises[index].geteId),
                              ),
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
                                  mediaQuery.size.height / 60,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                  radius: 30,
                                  child: ConditionalBuilder(
                                    condition:
                                        _exercises[index].getAnimatedPhotoUrl ==
                                            '',
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
                                              _exercises[index]
                                                  .getAnimatedPhotoUrl,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // ),
                                ),
                                // ),
                                title: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: mediaQuery.size.width / 90,
                                  ),
                                  child: Text(
                                    '${_exercises[index].getName}',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    FittedBox(
                                      child: Text(
                                        'Category : ${_exercises[index].getCategory.toJson()['name'] ?? ''}',
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
                                        vertical: mediaQuery.size.width / 90,
                                      ),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        'Training Place : ${_exercises[index].getTrainingPlace}',
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
                                        vertical: mediaQuery.size.width / 90,
                                      ),
                                    ),
                                    ConditionalBuilder(
                                      condition:
                                          _exercises[index].getDescription ==
                                              '',
                                      builder: (context) {
                                        return FittedBox(
                                          child: Text(
                                            'No description added yet',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                          ),
                                        );
                                      },
                                      fallback: (context) {
                                        return 
                                        // FittedBox(
                                        //   child: 
                                          Text(
                                            '${_exercises[index].getDescription}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                          // ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
              },
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
