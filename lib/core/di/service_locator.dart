import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/recipe/data/datasources/recipe_local_data_source.dart';
import '../../features/recipe/data/datasources/recipe_remote_data_source.dart';
import '../../features/recipe/data/repositories/recipe_repository_impl.dart';
import '../../features/recipe/domain/repositories/recipe_repository.dart';
import '../../features/recipe/domain/usecases/get_categories_usecase.dart';
import '../../features/recipe/domain/usecases/get_meals_usecase.dart';
import '../../features/recipe/presentation/cubit/category_cubit.dart';
import '../../features/recipe/presentation/cubit/meal_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {

  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: "https://www.themealdb.com/api/json/v1/1",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    ),
  );

  sl.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RecipeLocalDataSource>(
    () => RecipeLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetMealsUseCase(sl()));

  sl.registerFactory(() => CategoryCubit(sl()));
  sl.registerFactory(() => MealCubit(sl()));
}