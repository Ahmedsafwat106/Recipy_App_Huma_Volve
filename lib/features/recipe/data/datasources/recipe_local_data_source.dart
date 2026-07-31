import 'package:hive/hive.dart';
import '../models/category_model.dart';
import '../models/meal_model.dart';

abstract class RecipeLocalDataSource {
  Future<List<CategoryModel>> getCachedCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);

  Future<List<MealModel>> getCachedMeals(String category);
  Future<void> cacheMeals(String category, List<MealModel> meals);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  static const String categoriesBoxName = 'categoriesBox';
  static const String mealsBoxName = 'mealsBox';

  @override
  Future<List<CategoryModel>> getCachedCategories() async {
    final box = await Hive.openBox<CategoryModel>(categoriesBoxName);
    return box.values.toList();
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final box = await Hive.openBox<CategoryModel>(categoriesBoxName);
    await box.clear();
    await box.addAll(categories);
  }

  @override
  Future<List<MealModel>> getCachedMeals(String category) async {
    final box = await Hive.openBox<MealModel>(_mealsBoxKey(category));
    return box.values.toList();
  }

  @override
  Future<void> cacheMeals(String category, List<MealModel> meals) async {
    final box = await Hive.openBox<MealModel>(_mealsBoxKey(category));
    await box.clear();
    await box.addAll(meals);
  }

  String _mealsBoxKey(String category) => '$mealsBoxName-$category';
}