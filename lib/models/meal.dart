class Meal {
  final int? id;
  final String? title;
  final String? image;
  final String? imageType;

  Meal({
    this.id,
    this.title,
    this.image,
    this.imageType,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      imageType: json['imageType'],
    );
  }
}
