import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:healthy_lifestyle_app/core/models/exercise_model.dart';
import 'package:healthy_lifestyle_app/core/services/database_service.dart';

class ExerciseService extends ChangeNotifier {
  DatabaseService _db = DatabaseService(path: 'exercises');
  List<Exercise> exercises;

  Future addExercise(Exercise data) async {
    var result = await _db.addDocument(data.toJson());
    print(result.toString());
    return;
  }

  Future updateExercise(Exercise data, String id) async {
    await _db.updateDocument(data.toJson(), id);
    return;
  }

  Future deleteExercise(String id) async {
    await _db.deleteDocument(id);
    return;
  }

  Future<List<Exercise>> fetchExercises() async {
    var result = await _db.getDataCollection();
    exercises = result.documents
        .map((doc) => Exercise.fromMap(doc.data, doc.documentID))
        .toList();
    return exercises;
  }

  Future<List<Exercise>> fetchExercisesWithCondition(
      String field, String val) async {
    var result = await _db.getDocumentsWithCondition(field, val);
    exercises = result.documents
        .map((doc) => Exercise.fromMap(doc.data, doc.documentID))
        .toList();
    return exercises;
  }

  Stream<QuerySnapshot> fetchExercisesAsStream() {
    return _db.streamDataCollection();
  }

  Stream<QuerySnapshot> fetchExercisesAsStreamWithCondition(
      String field, String val) {
    return _db.streamDataCollectionWithCondition(field, val);
  }

  //   Stream<QuerySnapshot> fetchExercisesAsStreamWithNestedCondition(
  //     String field, String val) {
  //   return _db.streamDataCollectionWithCondition(field, val);
  // }

  Future<Exercise> getExerciseById(String id) async {
    var doc = await _db.getDocumentById(id);
    return Exercise.fromMap(doc.data, doc.documentID);
  }
}
