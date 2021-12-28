class MyCategory {
  String _cId;
  String _name;
  String _type;
  String _description;
  String _imageUrl;

  MyCategory();

  MyCategory.fromMyCategory({
    String cId,
    String name,
    String type,
    String description,
    String imageUrl,
  }) {
    this._cId = cId;
    this._name = name;
    this._type = type;
    this._description = description;
    this._imageUrl = imageUrl;
  }

  MyCategory.fromMap(Map snapshot, String id)
      : _cId = id ?? '',
        _name = snapshot['name'] ?? '',
        _type = snapshot['type'] ?? '',
        _description = snapshot['description'] ?? '',
        _imageUrl = snapshot['image_url'] ?? '';

  toJson() {
    return {
      "name": _name,
      "type": _type,
      "description": _description,
      "image_url": _imageUrl,
    };
  }

  String get getCId {
    return _cId;
  }

  set setName(String name) {
    this._name = name;
  }

  String get getName {
    return _name;
  }

  set setType(String type) {
    this._type = type;
  }

  String get getType {
    return _type;
  }

  set setDescription(String description) {
    this._description = description;
  }

  String get getDescription {
    return _description;
  }

  set setImageUrl(String imageUrl) {
    this._imageUrl = imageUrl;
  }

  String get getImageUrl {
    return _imageUrl;
  }
}
