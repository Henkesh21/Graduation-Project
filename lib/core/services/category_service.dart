import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:healthy_lifestyle_app/core/models/category_model.dart';
import 'package:healthy_lifestyle_app/core/services/database_service.dart';

class CategoryService extends ChangeNotifier {
  DatabaseService _db = DatabaseService(path: 'categories');
  List<MyCategory> categories;

  Future addCategory(MyCategory data) async {
    var result = await _db.addDocument(data.toJson());
    print(result.toString());
    return;
  }

  Future updateCategory(MyCategory data, String id) async {
    await _db.updateDocument(data.toJson(), id);
    return;
  }

  Future deleteCategory(String id) async {
    await _db.deleteDocument(id);
    return;
  }

  Future<List<MyCategory>> fetchCategories() async {
    var result = await _db.getDataCollection();
    categories = result.documents
        .map((doc) => MyCategory.fromMap(doc.data, doc.documentID))
        .toList();
    return categories;
  }

  Future<List<MyCategory>> fetchCategoriesWithCondition(
      String field, String val) async {
    var result = await _db.getDocumentsWithCondition(field, val);
    categories = result.documents
        .map((doc) => MyCategory.fromMap(doc.data, doc.documentID))
        .toList();
    return categories;
  }

  Stream<QuerySnapshot> fetchCategoriesAsStream() {
    return _db.streamDataCollection();
  }

  Stream<QuerySnapshot> fetchCategoriesAsStreamWithCondition(
      String field, String val) {
    return _db.streamDataCollectionWithCondition(field, val);
  }

  Future<MyCategory> getCategoryById(String id) async {
    var doc = await _db.getDocumentById(id);
    return MyCategory.fromMap(doc.data, doc.documentID);
  }
}
