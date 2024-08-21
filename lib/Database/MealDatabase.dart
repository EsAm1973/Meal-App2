import 'package:meals_app/models/mealDb.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Db_Helper {
  static final Db_Helper _instance = Db_Helper._internal();
  factory Db_Helper() => _instance;
  Db_Helper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'Favorite.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('Creating Database and Tables');
        await db.execute(
            'CREATE TABLE Fav(id INTEGER PRIMARY KEY, isChecked INTEGER, title TEXT, image TEXT, imageType TEXT)');
      },
    );
  }

  Future<int> insertFavMeal(MealDb meal) async {
    Database db = await database;
    print('Inserting Fav Meal: $meal');
    int result = await db.insert('Fav', meal.toMap());
    print('Meal inserted with id: $result');

    return result;
  }

  Future<List<Map<String, dynamic>>> getFavMeals() async {
    Database db = await database;
    print('Fetching Favorite Meals from the database.');
    List<Map<String, dynamic>> meals = await db.query('Fav');
    print('Fetched ${meals.length} Meals from the database.');
    return meals;
  }

  Future<int> deleteFavMeal(int? id) async {
    Database db = await database;
    print('Deleting Meal with id: $id');
    int result = await db.delete('Fav', where: 'id = ?', whereArgs: [id]);
    print('Meal deleted successfully. Deleted $result record(s).');

    return result;
  }

  //return all IDs in Favorite (database)
  Future<List<int>> getAllFavMealIds() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Fav');
    return List.generate(maps.length, (index) => maps[index]['id']);
  }
}
