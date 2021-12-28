class Role {
  String _rId;
  String _name;
  int _value;

  Role();

  Role.fromRole({
    String rId,
    String name,
    int value,
  }) {
    this._rId = rId;
    this._name = name;
    this._value = value;
  }

  Role.fromMap(Map snapshot, String id)
      : _rId = id ?? '',
        _name = snapshot['name'] ?? '',
        _value = snapshot['value'] ?? '';

  toJson() {
    return {
      "name": _name,
      "value": _value,
    };
  }

  String get getRId {
    return _rId;
  }

  set setName(String name) {
    this._name = name;
  }

  String get getName {
    return _name;
  }

  set setvalue(int value) {
    this._value = value;
  }

  int get getValue {
    return _value;
  }
}
