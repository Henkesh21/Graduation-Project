import 'package:flutter/foundation.dart';

import 'package:healthy_lifestyle_app/core/models/role_model.dart';

class User extends ChangeNotifier {
  String _uId;
  String _name;
  String _email;
  String _password;
  String _photo;
  var _role;
  var _target;
  var _calculation;
  String _gender;
  String _activity;
  int _age, _weight, _height;

  User();

  User.fromUser({
    String uId,
    String name,
    String email,
    String password,
    String photo,
    var role,
    var target,
    var calculation,
    String gender,
    String activity,
    int age,
    int weight,
    int height,
  }) {
    this._uId = uId;
    this._name = name;
    this._email = email;
    this._password = password;
    this._photo = photo;
    this._role = role;
    this._target = target;
    this._calculation = calculation;
    this._gender = gender;
    this._activity = activity;
    this._age = age;
    this._weight = weight;
    this._height = height;
  }

  User.fromMap(Map snapshot, String id)
      : _uId = id ?? '',
        _name = snapshot['name'] ?? '',
        _email = snapshot['email'] ?? '',
        _password = snapshot['password'] ?? '',
        _photo = snapshot['photo'] ?? '',
        _role = Role.fromMap(snapshot['role'], id) ?? '',
        _target = snapshot['target'] ?? '',
        _calculation = snapshot['calculation'] ?? '',
        _gender = snapshot['gender'] ?? '',
        _activity = snapshot['activity'] ?? '',
        _age = snapshot['age'] ?? 0,
        _weight = snapshot['weight'] ?? 0,
        _height = snapshot['height'] ?? 0;

  toJson() {
    return {
      "uId": _uId,
      "name": _name,
      "email": _email,
      "password": _password,
      "photo": _photo,
      "role": _role,
      "target": _target,
      "calculation": _calculation,
      "gender": _gender,
      "activity": _activity,
      "age": _age,
      "weight": _weight,
      "height": _height,
    };
  }

  String get getUId {
    return _uId;
  }

  set setName(String name) {
    this._name = name;
  }

  String get getName {
    return _name;
  }

  set setEmail(String email) {
    this._email = email;
  }

  String get getEmail {
    return _email;
  }

  set setPassword(String password) {
    this._password = password;
  }

  String get getPassword {
    return _password;
  }

  set setPhoto(String photo) {
    this._photo = photo;
  }

  String get getPhoto {
    return _photo;
  }

  set setRole(var role) {
    this._role = role;
  }

  get getRole {
    return _role;
  }

  set setTarget(var target) {
    this._target = target;
  }

  get getTarget {
    return _target;
  }

  set setCalculation(var calculation) {
    this._calculation = calculation;
  }

  get getCalculation {
    return _calculation;
  }

  set setGender(String gender) {
    this._gender = gender;
  }

  String get getGender {
    return _gender;
  }

  set setAge(int age) {
    this._age = age;
  }

  int get getAge {
    return _age;
  }

  set setWeight(int weight) {
    this._weight = weight;
  }

  int get getWeight {
    return _weight;
  }

  set setHeight(int height) {
    this._height = height;
  }

  int get getHeight {
    return _height;
  }

  set setActivity(String activity) {
    this._activity = activity;
  }

  String get getActivity {
    return _activity;
  }
}
