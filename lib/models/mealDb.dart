class MealDb {
  int? _id;
  String? _title;
  String? _image;
  String? _imageType;
  
  MealDb(dynamic obj) {
    _id = obj['id'];
    _title = obj['title'];
    _image = obj['image'];
    _imageType = obj['imageType'];
  }

  toMap() {
    var map = {
      'id': _id,
      'title': _title,
      'image': _image,
      'imageType': _imageType,
    };
    return map;
  }

  MealDb.fromMap(Map map) {
    _id = map['id'];
    _title = map['title'];
    _image = map['image'];
    _imageType = map['imageType'];
  }

  get id => _id;
  get title => _title;
  get image => _image;
  get imageType => _imageType;
}
