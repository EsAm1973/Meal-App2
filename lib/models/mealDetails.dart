class Meal_Details {
  final int cookingMinutes;
  final List<ExtendedIngredient> extendedIngredients;
  final int id;
  final String title;
  final int servings;
  final String image;

  Meal_Details({
    required this.cookingMinutes,
    required this.extendedIngredients,
    required this.id,
    required this.title,
    required this.servings,
    required this.image,
  });

  factory Meal_Details.fromJson(Map<String, dynamic> json) {
    return Meal_Details(
      cookingMinutes: json['cookingMinutes'] ?? 0,
      extendedIngredients: (json['extendedIngredients'] as List<dynamic>?)
              ?.map((x) => ExtendedIngredient.fromJson(x))
              .toList() ??
          [],
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No title available',
      servings: json['servings'] ?? 0,
      image: json['image'] ?? '',
    );
  }
}

class ExtendedIngredient {
  final int id;
  final String name;
  final double amount;
  final String unit;

  ExtendedIngredient({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory ExtendedIngredient.fromJson(Map<String, dynamic> json) {
    return ExtendedIngredient(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      amount: (json['amount'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}
