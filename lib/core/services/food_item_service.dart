import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:healthy_lifestyle_app/core/models/food_item_model.dart';
import 'package:healthy_lifestyle_app/core/services/database_service.dart';

class FoodItemService extends ChangeNotifier {
  DatabaseService _db = DatabaseService(path: 'food_items');
  List<FoodItem> foodItems;

  Future addFoodItem(FoodItem data) async {
    var result = await _db.addDocument(data.toJson());
    print(result.toString());
    return;
  }

  Future updateFoodItem(FoodItem data, String id) async {
    await _db.updateDocument(data.toJson(), id);
    return;
  }

  Future deleteFoodItem(String id) async {
    await _db.deleteDocument(id);
    return;
  }

  Future<List<FoodItem>> fetchFoodItems() async {
    var result = await _db.getDataCollection();
    foodItems = result.documents
        .map((doc) => FoodItem.fromMap(doc.data, doc.documentID))
        .toList();
    return foodItems;
  }

  Future<List<FoodItem>> fetchFoodItemsWithCondition(
      String field, String val) async {
    var result = await _db.getDocumentsWithCondition(field, val);
    foodItems = result.documents
        .map((doc) => FoodItem.fromMap(doc.data, doc.documentID))
        .toList();
    return foodItems;
  }

  Stream<QuerySnapshot> fetchFoodItemsAsStream() {
    return _db.streamDataCollection();
  }

  Stream<QuerySnapshot> fetchFoodItemsAsStreamWithCondition(
      String field, String val) {
    return _db.streamDataCollectionWithCondition(field, val);
  }

  Future<FoodItem> getFoodItemById(String id) async {
    var doc = await _db.getDocumentById(id);
    return FoodItem.fromMap(doc.data, doc.documentID);
  }
}
