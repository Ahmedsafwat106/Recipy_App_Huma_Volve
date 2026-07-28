import 'dart:math';

import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:reciepe_app/error/failure.dart';
import 'package:reciepe_app/models/category_model.dart';
import 'package:reciepe_app/services/api_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/recipe_card.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class SeafoodScreen extends StatefulWidget {
  const SeafoodScreen({super.key});

  @override
  State<SeafoodScreen> createState() => _SeafoodScreenState();
}

class _SeafoodScreenState extends State<SeafoodScreen> {
  final List<Meal> data = [
    Meal(
      idMeal: "1",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "2",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "1",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "2",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "1",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "2",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "1",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "2",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "1",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "2",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "1",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "2",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "1",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
    Meal(
      idMeal: "2",
      strMeal: "Seafood",
      strMealThumb: "https://www.themealdb.com/images/category/Seafood.png",
    ),
  ];
  late ApiService apiService;
  // String _searchQuery = '';
  int _currentNavIndex = 1;
  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 227, 227),
      appBar: CustomAppBar(
        title: 'Seafood',
        onMenuPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Menu tapped')));
        },
        onProfilePressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Profile tapped')));
        },
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hintText: 'Search in Seafood',
            onChanged: (query) {
              setState(() {
                // _searchQuery = query;
              });
            },
          ),
          FutureBuilder<Either<Failure, List<CategoryModel>>>(
            future: apiService.getCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                final result = snapshot.data;
                return result!.fold(
                  (failure) {
                    return Text(
                      failure.errorMessage,
                      style: TextStyle(color: Colors.red),
                    );
                  },
                  (categories) {
                    // final categorie = categories;
                    return SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final data = categories; //! List of Categories
                          final item = data[index]; //! One Category

                          return Chip(label: Text(item.strCategory!));
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(width: 10);
                        },
                        itemCount: data.length,
                      ),
                    );
                  },
                );
              } else {
                return Container(color: Colors.blueGrey);
              }
            },
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 14,
                mainAxisSpacing: 16,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return RecipeCard(
                  // meals: meals.meals![index],
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected: ${data[index].strMeal}'),
                      ),
                    );
                  },
                  meal: data[index],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentNavIndex,
        onItemTapped: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }
}

class RecipeData {
  String title;
  String imageUrl;
  RecipeData(this.title, this.imageUrl);
}
