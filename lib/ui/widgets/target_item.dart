// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:healthy_lifestyle_app/ui/widgets/edit_target_dialog.dart';

class TargetItem extends StatefulWidget {
  final targetService;
  final userService;
  // final tId;
  final objective;
  final startDate;
  final endDate;
  final currentUserId;
  final name;
  final email;
  final password;
  final photo;
  final role;
  final gender;
  final activity;
  final age;
  final weight;
  final height;
  final trainingPlace;
  final calculationService;
  final bmr;
  final dailyCalories;
  final neededCaloriesForTarget;

  const TargetItem({
    Key key,
    // this.tId,
    this.objective,
    this.startDate,
    this.endDate,
    this.targetService,
    this.userService,
    this.currentUserId,
    this.name,
    this.email,
    this.password,
    this.photo,
    this.role,
    this.gender,
    this.activity,
    this.age,
    this.weight,
    this.height,
    this.trainingPlace,
    this.bmr,
    this.dailyCalories,
    this.neededCaloriesForTarget,
    this.calculationService,
  }) : super(key: key);

  @override
  _TargetItemState createState() => _TargetItemState();
}

class _TargetItemState extends State<TargetItem> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Card(
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
            caption: 'Edit',
            color: Theme.of(context).secondaryHeaderColor,
            icon: Icons.edit,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return EditTargetDialog(
                      userService: widget.userService,
                      currentUserId: widget.currentUserId,
                      name: widget.name,
                      email: widget.email,
                      password: widget.password,
                      photo: widget.photo,
                      role: widget.role,
                      targetService: widget.targetService,
                      objective: widget.objective,
                      // startDate: widget.startDate,
                      // endDate: widget.endDate,
                      gender: widget.gender,
                      age: widget.age,
                      weight: widget.weight,
                      height: widget.height,
                      calculationService: widget.calculationService,
                      // bmr: widget.bmr,
                      // dailyCalories: widget.dailyCalories,
                      // neededCaloriesForTarget: widget.neededCaloriesForTarget,
                      activity: widget.activity,
                      trainingPlace: widget.trainingPlace,
                    );
                  });
            },
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
              caption: 'Cancel',
              color: Theme.of(context).secondaryHeaderColor,
              icon: Icons.cancel,
              onTap: () async {
                await widget.targetService.deleteTarget(widget.currentUserId);
                await widget.calculationService
                    .deleteCalculation(widget.currentUserId);
                await widget.userService.updateUser(
                  User.fromUser(
                    uId: widget.currentUserId,
                    email: widget.email,
                    password: widget.password,
                    name: widget.name,
                    photo: widget.photo,
                    role: widget.role,
                    target: 'no-target',
                    gender: 'no-gender',
                    calculation: 'no-calculation',
                    age: 0,
                    weight: 0,
                    height: 0,
                    activity: 'no-activity',
                  ),
                  widget.currentUserId,
                );
              }),
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
              child: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                radius: 30,
                child: Icon(
                  FontAwesomeIcons.tasks,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Padding(
              padding: EdgeInsets.only(
                bottom: mediaQuery.size.height / 50,
              ),
              child: ConditionalBuilder(
                condition: widget.objective == 'cut',
                builder: (context) => Text(
                  'Cut (Lose Fat)',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                fallback: (context) => Text(
                  'Bulk (Build Muscle)',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FittedBox(
                  child: Text(
                    'Start Date: ${widget.startDate}',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: mediaQuery.size.height / 50,
                  ),
                ),
                FittedBox(
                  child: Text(
                    'End Date: ${widget.endDate}',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: mediaQuery.size.height / 50,
                  ),
                ),
                FittedBox(
                  child: Text(
                    'Weight: ${widget.weight}',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: mediaQuery.size.height / 50,
                  ),
                ),
                FittedBox(
                  child: Text(
                    'Height: ${widget.height}',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: mediaQuery.size.height / 50,
                  ),
                ),
                FittedBox(
                  child: Text(
                    'Activity: ${widget.activity}',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: mediaQuery.size.height / 50,
                  ),
                ),
                FittedBox(
                  child: Text(
                    'Normal Calories: ${widget.dailyCalories} Kcal',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: mediaQuery.size.height / 50,
                  ),
                ),
                FittedBox(
                  child: Text(
                    'Target Calories: ${widget.neededCaloriesForTarget} Kcal',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: mediaQuery.size.height / 50,
                  ),
                ),
                // FittedBox(
                //   child:
                ConditionalBuilder(
                  condition: widget.objective == 'cut',
                  builder: (context) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hint:',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 12,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: mediaQuery.size.width / 90,
                        ),
                      ),
                      Text(
                        'You can subtract up to 500 : 1000 Kcal from your normal calories',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                  fallback: (context) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hint:',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 12,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: mediaQuery.size.width / 90,
                        ),
                      ),
                      Text(
                        'You can add up to 500 : 1000 Kcal from your normal calories',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
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
      ),
    );
  }
}
