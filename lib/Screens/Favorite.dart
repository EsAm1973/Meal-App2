import 'package:flutter/material.dart';
import 'package:meals_app/Database/MealDatabase.dart';
import 'package:meals_app/Screens/Meal_Details.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/models/mealDb.dart';
import 'package:transparent_image/transparent_image.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Favorite Recipe',
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
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: Db_Helper().getFavMeals(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No favorite meals yet.'));
            } else {
              final meals = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                ),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  MealDb meal = MealDb.fromMap(meals[index]);
                  Meal itemToNavigate = Meal(
                    id: meal.id,
                    title: meal.title,
                    image: meal.image,
                    imageType: meal.imageType,
                  );
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MealDetails(
                          meal: itemToNavigate,
                        ),
                      ));
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
                                  image: meal.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Expanded(
                            child: Text(
                              '${meal.title}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
