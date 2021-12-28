import 'package:healthy_lifestyle_app/core/models/category_model.dart';

class FoodItem {
  String _fIId;
  String _name;
  var _category;
  String _imageUrl;
  int _quantity, _calories, _proteins, _fat, _carb;
  String _unit;
  
  FoodItem();

  FoodItem.fromFoodItem({
    String fIId,
    String name,
    var category,
    String imageUrl,
    int quantity,
    String unit,
    int calories,
    int proteins,
    int fat,
    int carb,
  }) {
    this._fIId = fIId;
    this._name = name;
    this._category = category;
    this._imageUrl = imageUrl;
    this._quantity = quantity;
    this._unit = unit;
    this._calories = calories;
    this._proteins = proteins;
    this._fat = fat;
    this._carb = carb;
  }

  FoodItem.fromMap(Map snapshot, String id)
      : _fIId = id ?? '',
        _name = snapshot['name'] ?? '',
        _category = MyCategory.fromMap(snapshot['category'], id) ?? '',
        _imageUrl = snapshot['image_url'] ?? '',
        _quantity = snapshot['quantity'] ?? '',
        _unit = snapshot['unit'] ?? '',
        _calories = snapshot['calories'] ?? '',
        _proteins = snapshot['proteins'] ?? '',
        _fat = snapshot['fat'] ?? '',
        _carb = snapshot['carb'] ?? '';

  toJson() {
    return {
      "name": _name,
      "category": _category,
      "image_url": _imageUrl,
      "quantity": _quantity,
      "unit": _unit,
      "calories": _calories,
      "proteins": _proteins,
      "fat": _fat,
      "carb": _carb,
    };
  }

  String get getfIId {
    return _fIId;
  }

  set setName(String name) {
    this._name = name;
  }

  String get getName {
    return _name;
  }

  set setCategory(var category) {
    this._category = category;
  }

  get getCategory {
    return _category;
  }

  set setImageUrl(String imageUrl) {
    this._imageUrl = imageUrl;
  }

  String get getImageUrl {
    return _imageUrl;
  }

  set setQuantity(int quantity) {
    this._quantity = quantity;
  }

  int get getQuantity {
    return _quantity;
  }

  set setUnit(String unit) {
    this._unit = unit;
  }

  String get getUnit {
    return _unit;
  }

  set setCalories(int calories) {
    this._calories = calories;
  }

  int get getCalories {
    return _calories;
  }

  set setProteins(int proteins) {
    this._proteins = proteins;
  }

  int get getProteins {
    return _proteins;
  }

  set setFat(int fat) {
    this._fat = fat;
  }

  int get getFat {
    return _fat;
  }

  set setCarb(int carb) {
    this._carb = carb;
  }

  int get getCarb {
    return _carb;
  }
}
