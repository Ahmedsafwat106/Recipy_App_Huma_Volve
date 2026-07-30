import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/category_entity.dart';
import '../entities/meal_entity.dart';

abstract class RecipeRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<MealEntity>>> getMeals(String category);
}