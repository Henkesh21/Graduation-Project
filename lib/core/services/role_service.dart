import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:healthy_lifestyle_app/core/models/role_model.dart';
import 'package:healthy_lifestyle_app/core/services/database_service.dart';

class RoleService extends ChangeNotifier {
 
  DatabaseService _db = DatabaseService(path: 'roles');
  List<Role> roles;

  Future addRole(Role data) async {
    var result = await _db.addDocument(data.toJson());
    print(result.toString());
    return;
  }

  Future updateRole(Role data, String id) async {
    await _db.updateDocument(data.toJson(), id);
    return;
  }

  Future deleteRole(String id) async {
    await _db.deleteDocument(id);
    return;
  }

  Future<List<Role>> fetchRoles() async {
    var result = await _db.getDataCollection();
    roles = result.documents
        .map((doc) => Role.fromMap(doc.data, doc.documentID))
        .toList();
    return roles;
  }

  Future<List<Role>> fetchRolesWithCondition(String field, String val) async {
    var result = await _db.getDocumentsWithCondition(field, val);
    roles = result.documents
        .map((doc) => Role.fromMap(doc.data, doc.documentID))
        .toList();
    return roles;
  }

  Stream<QuerySnapshot> fetchRolesAsStream() {
    return _db.streamDataCollection();
  }

  Stream<QuerySnapshot> fetchRolesAsStreamWithCondition(
      String field, String val) {
    return _db.streamDataCollectionWithCondition(field, val);
  }

  Future<Role> getRoleById(String id) async {
    var doc = await _db.getDocumentById(id);
    return Role.fromMap(doc.data, doc.documentID);
  }
}
