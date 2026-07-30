import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_data_source.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  RecipeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
      return right(result);
    } on DioException catch (e) {
      return left(HandleError.handle(e));
    } catch (e) {
      return left(Failure("Something went wrong. Please try again."));
    }
  }

  @override
  Future<Either<Failure, List<MealEntity>>> getMeals(String category) async {
    try {
      final result = await remoteDataSource.getMeals(category);
      return right(result);
    } on DioException catch (e) {
      return left(HandleError.handle(e));
    } catch (e) {
      return left(Failure("Something went wrong. Please try again."));
    }
  }
}