import 'package:healthy_lifestyle_app/core/models/category_model.dart';

class Exercise {
  String _eId;
  String _name;
  var _category;
  String _description;
  String _animatedPhotoUrl;
  String _videoUrl;
  var _rate;
  String _trainingPlace;


  Exercise();

  Exercise.fromExercise({
    String eId,
    String name,
    var category,
    String description,
    String animatedPhotoUrl,
    String videoUrl,
    String trainingPlace,
    var rate,
  }) {
    this._eId = eId;
    this._name = name;
    this._category = category;
    this._description = description;
    this._animatedPhotoUrl = animatedPhotoUrl;
    this._videoUrl = videoUrl;
    this._rate = rate;
    this._trainingPlace = trainingPlace;
  }

  Exercise.fromMap(Map snapshot, String id)
      : _eId = id ?? '',
        _name = snapshot['name'] ?? '',
        _category = MyCategory.fromMap(snapshot['category'], id) ?? '',
        _description = snapshot['description'] ?? '',
        _animatedPhotoUrl = snapshot['animated_photo_url'] ?? '',
        _videoUrl = snapshot['video_url'] ?? '',
        _rate = snapshot['rate'] ?? '',
        _trainingPlace = snapshot['training_place'] ?? '';

  toJson() {
    return {
      "name": _name,
      "category": _category,
      "description": _description,
      "animated_photo_url": _animatedPhotoUrl,
      "video_url": _videoUrl,
      "rate": _rate,
      "training_place": _trainingPlace,
    };
  }

  String get geteId {
    return _eId;
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

  set setDescription(String description) {
    this._description = description;
  }

  String get getDescription {
    return _description;
  }

  set setAnimatedPhotoUrl(String animatedPhotoUrl) {
    this._animatedPhotoUrl = animatedPhotoUrl;
  }

  String get getAnimatedPhotoUrl {
    return _animatedPhotoUrl;
  }

  set setVideoUrl(String videoUrl) {
    this._videoUrl = videoUrl;
  }

  String get getVideoUrl {
    return _videoUrl;
  }

  set setRate(var rate) {
    this._rate = rate;
  }

  get getRate {
    return _rate;
  }

  set setTrainingPlace(String trainingPlace) {
    this._trainingPlace = trainingPlace;
  }

  String get getTrainingPlace {
    return _trainingPlace;
  }
}
