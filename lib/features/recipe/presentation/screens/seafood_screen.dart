import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/category_cubit.dart';
import '../cubit/meal_cubit.dart';
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
  late CategoryCubit categoryCubit;
  late MealCubit mealCubit;
  int _currentNavIndex = 1;

  @override
  void initState() {
    super.initState();
    categoryCubit = sl<CategoryCubit>()..getCategories();
    mealCubit = sl<MealCubit>()..getMeals("Seafood");
  }

  @override
  void dispose() {
    categoryCubit.close();
    mealCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: categoryCubit),
        BlocProvider.value(value: mealCubit),
      ],
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 226, 227, 227),
        appBar: CustomAppBar(
          title: 'Seafood',
          onMenuPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menu tapped')));
          },
          onProfilePressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile tapped')));
          },
        ),
        body: Column(
          children: [
            CustomSearchBar(hintText: 'Search in Seafood', onChanged: (query) {}),
            BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading || state is CategoryInitial) {
                  return const SizedBox(height: 50, child: Center(child: CircularProgressIndicator()));
                } else if (state is CategoryError) {
                  return SizedBox(
                    height: 50,
                    child: Center(child: Text(state.message, style: const TextStyle(color: Colors.red))),
                  );
                } else if (state is CategoryLoaded) {
                  final categories = state.categories;
                  return SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = categories[index];
                        return GestureDetector(
                          onTap: () => context.read<MealCubit>().getMeals(item.strCategory!),
                          child: Chip(label: Text(item.strCategory!)),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      itemCount: categories.length,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(
              child: BlocBuilder<MealCubit, MealState>(
                builder: (context, state) {
                  if (state is MealLoading || state is MealInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MealError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                  } else if (state is MealLoaded) {
                    final meals = state.meals;
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        return RecipeCard(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Selected: ${meals[index].strMeal}')),
                            );
                          },
                          meal: meals[index],
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _currentNavIndex,
          onItemTapped: (index) => setState(() => _currentNavIndex = index),
        ),
      ),
    );
  }
}