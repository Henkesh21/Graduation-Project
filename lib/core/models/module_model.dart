class Module {
  String _mId;
  String _name;
  bool _active;
  String _description;

  Module();

  Module.fromModule({
    String mId,
    String name,
    bool active,
    String description,
  }) {
    this._mId = mId;
    this._name = name;
    this._active = active;
    this._description = description;
  }

  Module.fromMap(Map snapshot, String id)
      : _mId = id ?? '',
        _name = snapshot['name'] ?? '',
        _active = snapshot['active'] ?? '',
        _description = snapshot['description'] ?? '';

  toJson() {
    return {
      "name": _name,
      "active": _active,
      "description": _description,
    };
  }

  String get getMId {
    return _mId;
  }

  set setName(String name) {
    this._name = name;
  }

  String get getName {
    return _name;
  }

  set setActive(bool active) {
    this._active = active;
  }

  bool get getActive {
    return _active;
  }

  set setDescription(String description) {
    this._description = description;
  }

  String get getDescription {
    return _description;
  }
}
