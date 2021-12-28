import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:healthy_lifestyle_app/core/models/module_model.dart';
import 'package:healthy_lifestyle_app/core/services/database_service.dart';

class ModuleService extends ChangeNotifier {
  DatabaseService _db = DatabaseService(path: 'modules');
  List<Module> modules;

  Future addModule(Module data) async {
    var result = await _db.addDocument(data.toJson());
    print(result.toString());
    return;
  }

  Future updateModule(Module data, String id) async {
    await _db.updateDocument(data.toJson(), id);
    return;
  }

  Future deleteModule(String id) async {
    await _db.deleteDocument(id);
    return;
  }

  Future<List<Module>> fetchModules() async {
    var result = await _db.getDataCollection();
    modules = result.documents
        .map((doc) => Module.fromMap(doc.data, doc.documentID))
        .toList();
    return modules;
  }

  Future<List<Module>> fetchModulesWithCondition(
      String field, String val) async {
    var result = await _db.getDocumentsWithCondition(field, val);
    modules = result.documents
        .map((doc) => Module.fromMap(doc.data, doc.documentID))
        .toList();
    return modules;
  }

  Stream<QuerySnapshot> fetchModulesAsStream() {
    return _db.streamDataCollection();
  }

  Stream<QuerySnapshot> fetchModulesAsStreamWithCondition(
      String field, String val) {
    return _db.streamDataCollectionWithCondition(field, val);
  }

  Future<Module> getModuleById(String id) async {
    var doc = await _db.getDocumentById(id);
    return Module.fromMap(doc.data, doc.documentID);
  }
}
