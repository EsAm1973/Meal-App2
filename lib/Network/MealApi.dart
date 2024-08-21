import 'dart:convert';
import 'package:http/http.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/models/mealDetails.dart';

class API {
  static const String _apiKey = '3a50d11f005c409cb1c5dae246c67020';

  //return all meals from network
  static Future<List<Meal>> getAllMeals() async {
    const String baseUrlAllMeals =
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=$_apiKey';
    try {
      final Response response = await get(Uri.parse(baseUrlAllMeals));
      if (response.statusCode == 200) {
        final List<dynamic> parsed = json.decode(response.body)['results'];

        return parsed.map<Meal>((item) => Meal.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      throw Exception('Failed to load meals: $e');
    }
  }

  //return meal details from network
  static Future<Meal_Details> getMealDetails(int id) async {
    String baseUrlMealDetails =
        'https://api.spoonacular.com/recipes/$id/information?apiKey=$_apiKey&includeNutrition=false';
    try {
      final Response response = await get(Uri.parse(baseUrlMealDetails));
      if (response.statusCode == 200) {
        final Map<String, dynamic> parsed = json.decode(response.body);
        return Meal_Details.fromJson(parsed);
      } else {
        throw Exception('Failed to load meal details');
      }
    } catch (e) {
      throw Exception('Failed to load meal details: $e');
    }
  }
}
