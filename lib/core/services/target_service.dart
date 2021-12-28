import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:healthy_lifestyle_app/core/models/target_model.dart';
import 'package:healthy_lifestyle_app/core/services/database_service.dart';

class TargetService extends ChangeNotifier {
  DatabaseService _db = DatabaseService(path: 'targets');
  List<Target> targets;

  Future addTargetWithCustomId(Target data, String id) async {
    await _db.updateDocument(data.toJson(), id);
    return data.toJson();
  }

  Future updateTarget(Target data, String id) async {
    await _db.updateDocument(data.toJson(), id);
    return data.toJson();
  }

  Future deleteTarget(String id) async {
    await _db.deleteDocument(id);
    return;
  }

  Future<List<Target>> fetchTargets() async {
    var result = await _db.getDataCollection();
    targets = result.documents
        .map((doc) => Target.fromMap(doc.data, doc.documentID))
        .toList();
    return targets;
  }

  Future<List<Target>> fetchTargetsWithCondition(
      String field, String val) async {
    var result = await _db.getDocumentsWithCondition(field, val);
    targets = result.documents
        .map((doc) => Target.fromMap(doc.data, doc.documentID))
        .toList();
    return targets;
  }

  Stream<QuerySnapshot> fetchTargetsAsStream() {
    return _db.streamDataCollection();
  }

  Stream<QuerySnapshot> fetchTargetsAsStreamWithCondition(
      String field, String val) {
    return _db.streamDataCollectionWithCondition(field, val);
  }

  Future<Target> getTargetById(String id) async {
    var doc = await _db.getDocumentById(id);
    return Target.fromMap(doc.data, doc.documentID);
  }
}
