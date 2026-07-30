import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/meal_entity.dart';
import '../repositories/recipe_repository.dart';

class GetMealsUseCase {
  final RecipeRepository repository;
  GetMealsUseCase(this.repository);

  Future<Either<Failure, List<MealEntity>>> call(String category) {
    return repository.getMeals(category);
  }
}