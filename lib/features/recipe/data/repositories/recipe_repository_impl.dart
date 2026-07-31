import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_local_data_source.dart';
import '../datasources/recipe_remote_data_source.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final cached = await localDataSource.getCachedCategories();
      if (cached.isNotEmpty) {
        _refreshCategories(); // تحديث في الخلفية من غير ما نستنى
        return right(cached.map((e) => e.toEntity()).toList());
      }
      final remote = await remoteDataSource.getCategories();
      await localDataSource.cacheCategories(remote);
      return right(remote.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return left(HandleError.handle(e));
    } catch (e) {
      return left(Failure("Something went wrong. Please try again."));
    }
  }

  @override
  Future<Either<Failure, List<MealEntity>>> getMeals(String category) async {
    try {
      final cached = await localDataSource.getCachedMeals(category);
      if (cached.isNotEmpty) {
        _refreshMeals(category);
        return right(cached.map((e) => e.toEntity()).toList());
      }
      final remote = await remoteDataSource.getMeals(category);
      await localDataSource.cacheMeals(category, remote);
      return right(remote.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return left(HandleError.handle(e));
    } catch (e) {
      return left(Failure("Something went wrong. Please try again."));
    }
  }

  Future<void> _refreshCategories() async {
    try {
      final remote = await remoteDataSource.getCategories();
      await localDataSource.cacheCategories(remote);
    } catch (_) {
      // تجاهل أي خطأ في التحديث الصامت، اليوزر شايف الكاش أصلاً
    }
  }

  Future<void> _refreshMeals(String category) async {
    try {
      final remote = await remoteDataSource.getMeals(category);
      await localDataSource.cacheMeals(category, remote);
    } catch (_) {}
  }
}