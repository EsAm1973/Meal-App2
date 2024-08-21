import 'package:flutter/material.dart';
import 'package:meals_app/Database/MealDatabase.dart';
import 'package:meals_app/Network/MealApi.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/models/mealDb.dart';
import 'package:meals_app/models/mealDetails.dart';
import 'package:transparent_image/transparent_image.dart';

class MealDetails extends StatefulWidget {
  const MealDetails({super.key, required this.meal});
  final Meal meal;

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  // This future will hold the meal details fetched from the API
  late Future<Meal_Details> _mealDetailsFuture;

  // This list will hold the IDs of favorite meals fetched from the database
  late List<int> favoriteMeals;

  @override
  void initState() {
    super.initState();
    // Fetch meal details from the API by ID
    _mealDetailsFuture = API.getMealDetails(widget.meal.id!);
    // Initialize the list of favorite meals
    favoriteMeals = [];
    initializeFavorites();
  }

  // Method to retrieve favorite meal IDs from the database
  void initializeFavorites() async {
    Db_Helper db = Db_Helper();
    final favoriteMealIds = await db.getAllFavMealIds();

    // Update the favoriteMeals list without using setState
    if (mounted) {
      setState(() {
        favoriteMeals = favoriteMealIds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current meal is a favorite
    final isFavorite = favoriteMeals.contains(widget.meal.id);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () async {
              Db_Helper db = Db_Helper();
              if (isFavorite) {
                // Remove from favorites
                await db.deleteFavMeal(widget.meal.id!);
              } else {
                // Add to favorites
                MealDb favMeal = MealDb({
                  'id': widget.meal.id!,
                  'title': widget.meal.title ?? 'No title',
                  'image':
                      widget.meal.image ?? 'https://via.placeholder.com/150',
                  'imageType': widget.meal.imageType ?? '',
                });
                await db.insertFavMeal(favMeal);
              }

              // Re-initialize the favorites list after update
              initializeFavorites();
            },
          ),
        ],
      ),
      body: FutureBuilder<Meal_Details>(
        future: _mealDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final mealDetails = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: mealDetails.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        Text(
                          mealDetails.title,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.green.shade500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  color: Colors.green.shade500,
                                ),
                                Text('${mealDetails.cookingMinutes} mins'),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '${mealDetails.extendedIngredients.length}',
                                  style:
                                      TextStyle(color: Colors.green.shade500),
                                ),
                                const Text('Ingredients'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Text('${mealDetails.servings} Servings'),
                            const Spacer(),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.green.shade500),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.add),
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.green.shade500),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.remove),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Text(
                              'Ingredients',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade500,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: MaterialButton(
                                onPressed: () {},
                                child: const Text('Add to Grocery list'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: mealDetails.extendedIngredients.length,
                          itemBuilder: (context, index) {
                            final ingredient =
                                mealDetails.extendedIngredients[index];
                            return Row(
                              children: [
                                Container(
                                  height: 7,
                                  width: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green.shade500,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${ingredient.amount} ${ingredient.unit} ${ingredient.name}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 50),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
