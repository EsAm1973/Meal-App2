import 'package:flutter/material.dart';
import 'package:meals_app/Database/MealDatabase.dart';
import 'package:meals_app/Network/MealApi.dart';
import 'package:meals_app/Screens/Meal_Details.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/models/mealDb.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _initializeData();
  }

  Future<Map<String, dynamic>> _initializeData() async {
    final meals = await API.getAllMeals();
    final favMealIds = await Db_Helper().getAllFavMealIds();
    return {'meals': meals, 'favMealIds': favMealIds};
  }

  void _refreshData() {
    setState(() {
      _dataFuture = _initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.green.shade500,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 7),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Colors.green.shade500,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        drawer: const Drawer(
          width: 300,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final meals = snapshot.data!['meals'] as List<Meal>;
              final favoriteMeals = snapshot.data!['favMealIds'] as List<int>;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                ),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final isFavorite = favoriteMeals.contains(meals[index].id);

                  return InkWell(
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MealDetails(
                          meal: meals[index],
                        ),
                      ));
                      // Refresh the data when returning
                      _refreshData();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: '${meals[index].image}',
                                    fit: BoxFit.cover,
                                  )),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.50),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite ? Colors.red : null),
                                    onPressed: () async {
                                      Db_Helper db = Db_Helper();
                                      if (isFavorite) {
                                        await db.deleteFavMeal(meals[index].id);
                                      } else {
                                        MealDb favMeal = MealDb({
                                          'id': meals[index].id,
                                          'title': meals[index].title,
                                          'image': meals[index].image,
                                          'imageType': meals[index].imageType,
                                        });
                                        await db.insertFavMeal(favMeal);
                                      }
                                      _refreshData();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Expanded(
                            child: Text(
                              '${meals[index].title}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('There was an Error'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
