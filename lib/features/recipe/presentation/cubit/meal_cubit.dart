import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/usecases/get_meals_usecase.dart';

part 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  final GetMealsUseCase getMealsUseCase;
  MealCubit(this.getMealsUseCase) : super(MealInitial());

  Future<void> getMeals(String category) async {
    emit(MealLoading());
    final result = await getMealsUseCase(category);
    result.fold(
      (failure) => emit(MealError(failure.errorMessage)),
      (meals) => emit(MealLoaded(meals)),
    );
  }
}