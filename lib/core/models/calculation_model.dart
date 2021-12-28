import 'package:flutter/foundation.dart';

class Calculation extends ChangeNotifier {
  String _cId;
  double _bmr;
  int _dailyCalories;
  int _neededCaloriesForTarget;
  int _consumedCalories;

  Calculation();

  Calculation.fromCalculation({
    String cId,
    double bmr,
    int dailyCalories,
    int neededCaloriesForTarget,
    int consumedCalories,
  }) {
    this._cId = cId;
    this._bmr = bmr;
    this._dailyCalories = dailyCalories;
    this._neededCaloriesForTarget = neededCaloriesForTarget;
    this._consumedCalories = consumedCalories;
  }

  Calculation.fromMap(Map snapshot, String id)
      : _cId = id ?? '',
        _bmr = snapshot['bmr'] ?? 0,
        _dailyCalories = snapshot['daily_Calories'] ?? 0,
        _neededCaloriesForTarget = snapshot['needed_calories_for_target'] ?? 0,
        _consumedCalories= snapshot['consumed_calories'] ?? 0;

  toJson() {
    return {
      "cId": _cId,
      "bmr": _bmr,
      "daily_calories": _dailyCalories,
      "needed_calories_for_target": _neededCaloriesForTarget,
      "consumed_calories": _consumedCalories,
    };
  }

  String get getcId {
    return _cId;
  }

  set setBmr(double bmr) {
    this._bmr = bmr;
  }

  double get getBmr {
    return _bmr;
  }

  set setDailyCalories(int dailyCalories) {
    this._dailyCalories = dailyCalories;
  }

  int get getdailyCalories {
    return _dailyCalories;
  }

  set setNeededCaloriesForTarget(int neededCaloriesForTarget) {
    this._neededCaloriesForTarget = neededCaloriesForTarget;
  }

  int get getNeededCaloriesForTarget {
    return _neededCaloriesForTarget;
  }

    set setConsumedCalories(int consumedCalories) {
    this._consumedCalories = consumedCalories;
  }

  int get getConsumedCalories {
    return _consumedCalories;
  }
}
