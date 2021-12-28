import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_lifestyle_app/core/models/calculation_model.dart';
import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:healthy_lifestyle_app/ui/screens/targets_screen.dart';
// import 'package:android_alarm_manager/android_alarm_manager.dart';
class AddItemToMealDialog extends StatefulWidget {
  final hasTarget;
  final targetService;
  final userService;
  final calculationService;
  final currentUserId;
  final name;
  final email;
  final password;
  final photo;
  final role;
  final bmr;
  final dailyCalories;
  final neededCaloriesForTarget;
  final consumedCalories;
  final unit;
  final target;
  final calculation;
  final gender;
  final activity;
  final age;
  final weight;
  final height;
  final quantity;
  final calories;
  AddItemToMealDialog({
    Key key,
    this.hasTarget,
    this.targetService,
    this.userService,
    this.calculationService,
    this.currentUserId,
    this.name,
    this.email,
    this.password,
    this.photo,
    this.role,
    this.bmr,
    this.dailyCalories,
    this.neededCaloriesForTarget,
    this.consumedCalories,
    this.unit,
    this.target,
    this.calculation,
    this.gender,
    this.activity,
    this.age,
    this.weight,
    this.height,
    this.quantity,
    this.calories,
  }) : super(key: key);

  @override
  _AddItemToMealDialogState createState() => _AddItemToMealDialogState();
}

class _AddItemToMealDialogState extends State<AddItemToMealDialog> {
  final formKey = GlobalKey<FormState>();
  int _userEnteredQuantity,
      _totalConsumedCalories,
      // ignore: unused_field
      _selectedItemCalories,
      // ignore: unused_field
      _remainingCalories;

  String numberValidator(String value) {
    if (value.isEmpty) {
      return 'Enter a value';
    }
    final n = num.tryParse(value);
    if (n < 0 || n == 0) {
      return '"$value" is not valid';
    }
    return null;
  }

  int numberCasting(String value) {
    final n = num.tryParse(value);
    return n;
  }

  String stringCasting(int value) {
    final s = value.toString();
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return ConditionalBuilder(
      condition: widget.hasTarget == 1,
      builder: (context) => AlertDialog(
        title: FittedBox(child: Text('Add Item To A Meal')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        content: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              right: -40.0,
              top: -90.0,
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
            Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(mediaQuery.size.width / 90),
                    ),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            hintText: 'Quantity in ${widget.unit}'),
                        validator: numberValidator,
                        onSaved: (val) {
                          _userEnteredQuantity = numberCasting(val);
                        }),
                    Padding(
                      padding: EdgeInsets.all(mediaQuery.size.width / 90),
                    ),
                    RaisedButton(
                      child: Text(
                        "Add",
                      ),
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();

                          _selectedItemCalories = widget.calculationService
                              .calculateSelectedItemCalories(
                            widget.quantity,
                            widget.calories,
                            _userEnteredQuantity,
                          );
                          _totalConsumedCalories = widget.calculationService
                              .calculateConsumedCalories(
                            widget.consumedCalories,
                            widget.quantity,
                            widget.calories,
                            _userEnteredQuantity,
                          );
                          _remainingCalories = widget.calculationService
                              .calculateRemainingCalories(
                            widget.neededCaloriesForTarget,
                            widget.consumedCalories,
                            widget.quantity,
                            widget.calories,
                            _userEnteredQuantity,
                          );

                          var newCalculation = await widget.calculationService
                              .addCalculationWithCustomId(
                            Calculation.fromCalculation(
                              cId: widget.currentUserId,
                              bmr: widget.bmr,
                              dailyCalories: widget.dailyCalories,
                              neededCaloriesForTarget:
                                  widget.neededCaloriesForTarget,
                              consumedCalories: _totalConsumedCalories,
                            ),
                            widget.currentUserId,
                          );

                          await widget.userService.updateUser(
                            User.fromUser(
                              uId: widget.currentUserId,
                              email: widget.email,
                              password: widget.password,
                              name: widget.name,
                              photo: widget.photo,
                              role: widget.role,
                              target: widget.target,
                              gender: widget.gender,
                              calculation: newCalculation,
                              age: widget.age,
                              weight: widget.weight,
                              height: widget.height,
                              activity: widget.activity,
                            ),
                            widget.currentUserId,
                          );

                          Navigator.pop(context);
                        }
                        // }

                        // }
                        // }
                      },
                    ),
                  ],
                ),
              ),
            ),
            // SingleChildScrollView(
            //   child: Center(
            //     child:

            //     // Text(
            //     //   'Coming Soon... 😃',
            //     //   style: Theme.of(context).textTheme.bodyText2,
            //     // ),
            //   ),
            // ),
          ],
        ),
      ),
      fallback: (context) => AlertDialog(
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
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      ' Don\'t Have A Target Yet! 🤔 ',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  SizedBox(
                    height: mediaQuery.size.height / 30,
                  ),
                  RaisedButton(
                    onPressed: () {
                      // showDialog(
                      //     context: context,
                      //     builder: (_) {
                      Navigator.of(context)
                          .pushReplacementNamed(TargetsScreen.routeName);
                      // return SelectTargetDialog(
                      //   currentUserId: widget.currentUserId,
                      //   email: widget.email,
                      //   name: widget.name,
                      //   password: widget.password,
                      //   photo: widget.photo,
                      //   role: widget.role,
                      //   userService: widget.userService,
                      //   targetService: widget.targetService,
                      //   calculationService: widget.calculationService,
                      // );
                      // });
                    },
                    child: FittedBox(
                      child: Text('Let\'s Start A Challenge! 😃'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
