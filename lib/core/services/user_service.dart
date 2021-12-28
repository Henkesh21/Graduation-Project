import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:healthy_lifestyle_app/core/models/user_model.dart';
import 'package:healthy_lifestyle_app/core/services/database_service.dart';

class UserService extends ChangeNotifier {
  // ModelsInterface data;
  // CrudService crud = new CrudService(model: ModelsInterface, path: User);
  // User user;

  // updateUser2(this.user, String id) async {
  //   await crud.updateById(user, id);
  // }

  DatabaseService _db = DatabaseService(path: 'users');
  List<User> users;

  Future addUser(User data) async {
    var result = await _db.addDocument(data.toJson());
    print(result);
    return;
  }

  Future updateUser(User data, String id) async {
    await _db.updateDocument(data.toJson(), id);
    return;
  }

  Future deleteUser(String id) async {
    await _db.deleteDocument(id);
    return;
  }

  Future<List<User>> fetchUsers() async {
    var result = await _db.getDataCollection();
    users = result.documents
        .map((doc) => User.fromMap(doc.data, doc.documentID))
        .toList();
    return users;
  }

  Future<List<User>> fetchUsersWithCondition(String field, String val) async {
    var result = await _db.getDocumentsWithCondition(field, val);
    users = result.documents
        .map(
          (doc) => User.fromMap(doc.data, doc.documentID),
        )
        .toList();
    return users;
  }

  Stream<QuerySnapshot> fetchUsersAsStream() {
    return _db.streamDataCollection();
  }

  Stream<QuerySnapshot> fetchUsersAsStreamWithCondition(
      String field, String val) {
    return _db.streamDataCollectionWithCondition(field, val);
  }

  Future<User> getUserById(String id) async {
    var doc = await _db.getDocumentById(id);
    return User.fromMap(doc.data, doc.documentID);
  }
}
