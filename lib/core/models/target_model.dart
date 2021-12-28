import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Target extends ChangeNotifier {
  String _tId;
  String _objective;
  Timestamp _startDate;
  Timestamp _endDate;
  String _trainingPlace;
  double _activityFactor;

  Target();

  Target.fromTarget({
    String tId,
    String objective,
    Timestamp startDate,
    Timestamp endDate,
    String trainingPlace,
    double activityFactor,
  }) {
    this._tId = tId;
    this._objective = objective;
    this._startDate = startDate;
    this._endDate = endDate;
    this._trainingPlace = trainingPlace;
    this._activityFactor = activityFactor;
  }

  Target.fromMap(Map snapshot, String id)
      : _tId = id ?? '',
        _objective = snapshot['objective'] ?? '',
        _startDate = snapshot['start_date'] ?? '',
        _endDate = snapshot['end_date'] ?? '',
        _trainingPlace = snapshot['training_place'] ?? '',
        _activityFactor = snapshot['activity_factor'] ?? '';

  toJson() {
    return {
      "tId": _tId,
      "objective": _objective,
      "start_date": _startDate,
      "end_date": _endDate,
      "training_place": _trainingPlace,
      "activity_factor": _activityFactor,
    };
  }

  String get gettId {
    return _tId;
  }

  set setobjective(String objective) {
    this._objective = objective;
  }

  String get getobjective {
    return _objective;
  }

  set setStartDate(Timestamp startDate) {
    this._startDate = startDate;
  }

  Timestamp get getStartDate {
    return _startDate;
  }

  set setEndDate(Timestamp endDate) {
    this._endDate = endDate;
  }

  Timestamp get getEndDate {
    return _endDate;
  }

  set setTrainingPlace(String trainingPlace) {
    this._trainingPlace = trainingPlace;
  }

  String get getTrainingPlace {
    return _trainingPlace;
  }

  set setActivityFactor(double activityFactor) {
    this._activityFactor = activityFactor;
  }

  double get getActivityFactor{
    return _activityFactor;
  }
}
