import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_datetime_formfield/flutter_datetime_formfield.dart';
import 'package:healthy_lifestyle_app/core/models/calculation_model.dart';
import 'package:healthy_lifestyle_app/core/models/target_model.dart';
import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:intl/intl.dart';

class EditTargetDialog extends StatefulWidget {
  final targetService;
  final userService;
  final calculationService;
  final currentUserId;
  final name;
  final email;
  final password;
  final photo;
  final role;
  final objective;
  final gender;
  final activity;
  final age;
  final weight;
  final height;
  final trainingPlace;
  // final bmr;
  // final dailyCalories;
  // final neededCaloriesForTarget;

  const EditTargetDialog({
    Key key,
    this.targetService,
    this.currentUserId,
    this.name,
    this.email,
    this.password,
    this.photo,
    this.role,
    this.userService,
    this.gender,
    this.activity,
    this.age,
    this.weight,
    this.height,
    this.trainingPlace,
    this.calculationService,
    this.objective,
    // this.bmr,
    // this.dailyCalories,
    // this.neededCaloriesForTarget,
  }) : super(key: key);

  @override
  _EditTargetDialogState createState() => _EditTargetDialogState();
}

class _EditTargetDialogState extends State<EditTargetDialog> {
  final formKey = GlobalKey<FormState>();

  var _objectivesList = [
    'Bulk',
    'Cut',
  ];
  var _genderList = [
    'Male',
    'Female',
  ];
  var _activitiesList = [
    'Little Activity (no exercise)',
    'Light Activity (ex: 1-3 days per week)',
    'Moderate Activity (ex: 3-5 days per week)',
    'Heavy Activity (ex: 6-7 days per week)',
    'Very Heavy Activity',
  ];
  var _placesList = [
    'Home',
    'Gym',
    'Both',
  ];

  String _gender;
  double _activityFactor;
  String _activity;

  int _age, _weight, _height;
  String _trainingPlace;
  double _bmr;
  int _dailyCalories;
  int _neededCaloriesForTarget;

  var _currentTargetSelected;

  void _onDropDownTargetSelected(String newValueSelected) {
    setState(() {
      this._currentTargetSelected = newValueSelected;
    });
  }

  var _currentGenderSelected;

  void _onDropDownGenderSelected(String newValueSelected) {
    setState(() {
      this._currentGenderSelected = newValueSelected;
    });
  }

  var _currentActivitySelected;

  void _onDropDownActivitySelected(String newValueSelected) {
    setState(() {
      this._currentActivitySelected = newValueSelected;
    });
  }

  var _currentPlaceSelected;

  void _onDropDownPlaceSelected(String newValueSelected) {
    setState(() {
      this._currentPlaceSelected = newValueSelected;
    });
  }

  double _selectedActivityValue(String activity) {
    double value;
    if (activity == 'Little Activity (no exercise)') {
      value = 1.2;
    } else if (activity == 'Light Activity (ex: 1-3 days per week)') {
      value = 1.3;
    } else if (activity == 'Moderate Activity (ex: 3-5 days per week)') {
      value = 1.5;
    } else if (activity == 'Heavy Activity (ex: 6-7 days per week') {
      value = 1.7;
    } else if (activity == 'Very Heavy Activity') {
      value = 1.9;
    }
    return value;
  }

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

  String _objective;
  DateTime _startDate;
  DateTime _endDate;
  String _error;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

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

          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ConditionalBuilder(
                    condition: _error == 'Invalid Dates',
                    builder: (context) => Text(
                      _error,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  TextFormField(
                      initialValue: stringCasting(widget.age),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(hintText: 'Age'),
                      validator: numberValidator,
                      onSaved: (val) {
                        _age = numberCasting(val);
                      }),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  TextFormField(
                      initialValue: stringCasting(widget.weight),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(hintText: 'Weight (kg)'),
                      validator: numberValidator,
                      onSaved: (val) {
                        _weight = numberCasting(val);
                      }),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  TextFormField(
                      initialValue: stringCasting(widget.height),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(hintText: 'Height (cm)'),
                      validator: numberValidator,
                      onSaved: (val) {
                        _height = numberCasting(val);
                      }),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  Center(
                    child: Container(
                      width: mediaQuery.size.width,
                      child: DropdownButtonFormField<dynamic>(
                        icon: ConditionalBuilder(
                          condition: _currentGenderSelected == null,
                          builder: (context) => Icon(
                            FontAwesomeIcons.genderless,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          fallback: (context) => ConditionalBuilder(
                            condition: _currentGenderSelected == 'Male',
                            builder: (context) => Icon(
                              FontAwesomeIcons.mars,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                            fallback: (context) => Icon(
                              FontAwesomeIcons.venus,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ),
                        items: _genderList.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          _onDropDownGenderSelected(val);
                          setState(() {
                            _gender = _currentGenderSelected;
                          });
                        },
                        value: _currentGenderSelected,
                        isExpanded: false,
                        hint: new Text(
                          "${widget.gender}",
                        ),
                        validator: (val) =>
                            val == null ? 'Select your gender' : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  Center(
                    child: Container(
                      width: mediaQuery.size.width,
                      child: DropdownButtonFormField<dynamic>(
                        icon: Icon(
                          FontAwesomeIcons.running,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        items: _activitiesList.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: 7,
                                  ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          _onDropDownActivitySelected(val);
                          setState(() {
                            _activity = _currentActivitySelected;
                          });
                        },
                        value: _currentActivitySelected,
                        isExpanded: false,
                        hint: new Text(
                          "${widget.activity}",
                          style: TextStyle(fontSize: 7),
                        ),
                        validator: (val) =>
                            val == null ? 'Select a Level' : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  Center(
                    child: Container(
                      width: mediaQuery.size.width,
                      child: DropdownButtonFormField<dynamic>(
                        icon: ConditionalBuilder(
                          condition: _currentPlaceSelected == null,
                          builder: (context) => Icon(
                            Icons.place,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          fallback: (context) => ConditionalBuilder(
                            condition: _currentPlaceSelected == 'Home',
                            builder: (context) => Icon(
                              FontAwesomeIcons.home,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                            fallback: (context) => ConditionalBuilder(
                              condition: _currentPlaceSelected == null,
                              builder: (context) => Icon(
                                Icons.place,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                              fallback: (context) => ConditionalBuilder(
                                condition: _currentPlaceSelected == 'Gym',
                                builder: (context) => Icon(
                                  Icons.fitness_center,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                                fallback: (context) => Icon(
                                  Icons.place,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        items: _placesList.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          _onDropDownPlaceSelected(val);
                          setState(() {
                            _trainingPlace = _currentPlaceSelected;
                          });
                        },
                        value: _currentPlaceSelected,
                        isExpanded: false,
                        hint: new Text(
                          "${widget.trainingPlace}",
                        ),
                        validator: (val) =>
                            val == null ? 'Select a place' : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  Center(
                    child: Container(
                      width: mediaQuery.size.width,
                      child: DropdownButtonFormField<dynamic>(
                        icon: Icon(
                          FontAwesomeIcons.tasks,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        items: _objectivesList.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(
                              dropDownStringItem,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          _onDropDownTargetSelected(val);
                          setState(() {
                            _objective = _currentTargetSelected;
                          });
                        },
                        value: _currentTargetSelected,
                        isExpanded: false,
                        hint: new Text(
                          "${widget.objective}",
                        ),
                        validator: (val) =>
                            val == null ? 'Select a target' : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  DateTimeFormField(
                    onlyDate: true,
                    formatter: DateFormat.yMMMEd(),
                    initialValue: _startDate ?? DateTime.now().toLocal(),
                    label: "Start Date",
                    validator: (DateTime dateTime) {
                      if (dateTime == null) {
                        return "Start Date Required";
                      }
                      // if (dateTime.year < DateTime.now().year ||
                      //     dateTime.month < DateTime.now().month ||
                      //     dateTime.day < DateTime.now().day) {
                      //   return "Invalid Date";
                      // }
                      return null;
                    },
                    onSaved: (DateTime dateTime) {
                      setState(() {
                        _startDate = dateTime.toLocal();
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  /* 
                  //               Theme(
                  // data: Theme.of(context).copyWith(
                  //       primaryColor: Colors.amber,
                  //     ),
                  // child: new Builder(
                  //   builder: (context) =>
                  // StatefulBuilder(

                  //   builder: (context, snapshot) {
                  //     return
                   */
                  DateTimeFormField(
                    onlyDate: true,
                    formatter: DateFormat.yMMMEd(),
                    initialValue: _endDate ??
                        DateTime.now()
                            .add(
                              new Duration(days: 30),
                            )
                            .toLocal(),
                    label: "End Date",
                    validator: (DateTime dateTime) {
                      if (dateTime == null) {
                        return "End Date Required";
                      }
                      // if (dateTime.year < DateTime.now().year ||
                      //     dateTime.month < DateTime.now().month ||
                      //     dateTime.day < DateTime.now().day) {
                      //   return "Invalid Date";
                      // }
                      return null;
                    },
                    onSaved: (DateTime dateTime) {
                      setState(() {
                        _endDate = dateTime.toLocal();
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(mediaQuery.size.width / 90),
                  ),
                  RaisedButton(
                    child: Text(
                      "Submit",
                    ),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();

                        // var selectedActivity = _activity;

                        if (_endDate.isBefore(_startDate) ||
                                _startDate.isAfter(_endDate)
                            // _startDate.year > _endDate.year ||
                            // _startDate.month > _endDate.month ||
                            // _startDate.day > _endDate.day ||
                            // _endDate.year < _startDate.year ||
                            // _endDate.month < _startDate.month
                            // ||
                            // _endDate.day < _startDate.day
                            ) {
                          setState(() {
                            _error = 'Invalid Dates';
                          });
                        } else {
                          _activityFactor = _selectedActivityValue(_activity);

                          _bmr = widget.calculationService.calculateBMR(
                            _gender.toLowerCase().trim(),
                            _age,
                            _weight,
                            _height,
                          );
                          _dailyCalories =
                              widget.calculationService.calculateDailyCalories(
                            _gender.toLowerCase().trim(),
                            _age,
                            _weight,
                            _height,
                            _activityFactor,
                          );
                          _neededCaloriesForTarget = widget.calculationService
                              .calculateNeededCaloriesForTarget(
                            _gender.toLowerCase().trim(),
                            _age,
                            _weight,
                            _height,
                            _activityFactor,
                            _objective.toLowerCase().trim(),
                          );

                          // var selectedGender = _gender;

                          // var selectedTainingPlace = _trainingPlace;

                          var selectedTarget =
                              await widget.targetService.addTargetWithCustomId(
                            Target.fromTarget(
                              tId: widget.currentUserId,
                              objective: _objective.toLowerCase().trim(),
                              startDate: Timestamp.fromMicrosecondsSinceEpoch(
                                  _startDate.microsecondsSinceEpoch),
                              endDate: Timestamp.fromMicrosecondsSinceEpoch(
                                  _endDate.microsecondsSinceEpoch),
                              trainingPlace:
                                  _trainingPlace.toLowerCase().trim(),
                              activityFactor: _activityFactor,
                            ),
                            widget.currentUserId,
                          );

                          var selectedCalculation = await widget
                              .calculationService
                              .addCalculationWithCustomId(
                            Calculation.fromCalculation(
                              cId: widget.currentUserId,
                              bmr: _bmr,
                              dailyCalories: _dailyCalories,
                              neededCaloriesForTarget: _neededCaloriesForTarget,
                              consumedCalories: 0,
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
                              target: selectedTarget,
                              gender: _gender.toLowerCase().trim(),
                              calculation: selectedCalculation,
                              age: _age,
                              weight: _weight,
                              height: _height,
                              activity: _activity.toLowerCase().trim(),
                            ),
                            widget.currentUserId,
                          );

                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
