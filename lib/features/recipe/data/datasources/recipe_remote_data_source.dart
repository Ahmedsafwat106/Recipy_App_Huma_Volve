import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/meal_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<MealModel>> getMeals(String category);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio dio;
  RecipeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await dio.get("/categories.php");
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      final jsonRes = response.data["categories"] as List;
      return jsonRes.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      throw Exception("Something went wrong");
    }
  }

  @override
  Future<List<MealModel>> getMeals(String category) async {
    final response = await dio.get(
      "/filter.php",
      queryParameters: {"c": category},
    );
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      final jsonRes = response.data["meals"] as List;
      return jsonRes.map((e) => MealModel.fromJson(e)).toList();
    } else {
      throw Exception("Something went wrong");
    }
  }
}