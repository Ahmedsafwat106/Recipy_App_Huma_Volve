import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/category_entity.dart';
import '../repositories/recipe_repository.dart';

class GetCategoriesUseCase {
  final RecipeRepository repository;
  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}