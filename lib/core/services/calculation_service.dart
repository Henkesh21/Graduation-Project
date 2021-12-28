import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:healthy_lifestyle_app/core/models/calculation_model.dart';
import 'package:healthy_lifestyle_app/core/services/database_service.dart';

class CalculationService extends ChangeNotifier {
  DatabaseService _db = DatabaseService(path: 'calculations');
  List<Calculation> calculations;

  Future addCalculationWithCustomId(Calculation data, String id) async {
    await _db.updateDocument(data.toJson(), id);
    return data.toJson();
  }

  Future updateCalculation(Calculation data, String id) async {
    await _db.updateDocument(data.toJson(), id);
    return;
  }

  Future deleteCalculation(String id) async {
    await _db.deleteDocument(id);
    return;
  }

  Future<List<Calculation>> fetchCalculations() async {
    var result = await _db.getDataCollection();
    calculations = result.documents
        .map((doc) => Calculation.fromMap(doc.data, doc.documentID))
        .toList();
    return calculations;
  }

  Future<List<Calculation>> fetchCalculationsWithCondition(
      String field, String val) async {
    var result = await _db.getDocumentsWithCondition(field, val);
    calculations = result.documents
        .map((doc) => Calculation.fromMap(doc.data, doc.documentID))
        .toList();
    return calculations;
  }

  Stream<QuerySnapshot> fetchCalculationsAsStream() {
    return _db.streamDataCollection();
  }

  Stream<QuerySnapshot> fetchCalculationsAsStreamWithCondition(
      String field, String val) {
    return _db.streamDataCollectionWithCondition(field, val);
  }

  Future<Calculation> getCalculationById(String id) async {
    var doc = await _db.getDocumentById(id);
    return Calculation.fromMap(doc.data, doc.documentID);
  }

  double calculateBMR(
    String gender,
    int age,
    int weight,
    int height,
  ) {
    double bmr;
    if (gender == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else if (gender == 'female') {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }
    return bmr;
  }

  int calculateDailyCalories(
    String gender,
    int age,
    int weight,
    int height,
    double activityFactor,
  ) {
    double bmr = this.calculateBMR(gender, age, weight, height);
    var dailyCalories;
    dailyCalories = bmr * activityFactor;

    return dailyCalories.floor();
  }

  int calculateNeededCaloriesForTarget(
    String gender,
    int age,
    int weight,
    int height,
    double activityFactor,
    String objective,
  ) {
    int dailyCalories = this
        .calculateDailyCalories(gender, age, weight, height, activityFactor);
    int neededCaloriesForTarget;
    if (objective == 'cut') {
      neededCaloriesForTarget = dailyCalories - 500;
    } else if (objective == 'bulk') {
      neededCaloriesForTarget = dailyCalories + 500;
    }

    return neededCaloriesForTarget;
  }

  int calculateSelectedItemCalories(
    int itemQuantity,
    int itemCalories,
    int userEnteredQuantity,
  ) {
    double selectedItemCalories;

    selectedItemCalories = userEnteredQuantity / itemQuantity * itemCalories;

    return selectedItemCalories.floor();
  }

  int calculateConsumedCalories(
    int userConsumedCalories,
    int itemQuantity,
    int itemCalories,
    int userEnteredQuantity,
  ) {
    int selectedItemCalories, totalConsumedCalories;

    selectedItemCalories = this.calculateSelectedItemCalories(
        itemQuantity, itemCalories, userEnteredQuantity);

    totalConsumedCalories = userConsumedCalories + selectedItemCalories;

    return totalConsumedCalories;
  }

  int calculateRemainingCalories(
    int neededCaloriesForTarget,
    int userConsumedCalories,
    int itemQuantity,
    int itemCalories,
    int userEnteredQuantity,
  ) {
    int totalConsumedCalories, remainingCalories;

    totalConsumedCalories = this.calculateConsumedCalories(
        userConsumedCalories, itemQuantity, itemCalories, userEnteredQuantity);

    remainingCalories = neededCaloriesForTarget - totalConsumedCalories;

    return remainingCalories;
  }
}
