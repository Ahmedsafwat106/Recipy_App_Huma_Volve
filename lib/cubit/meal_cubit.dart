import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reciepe_app/models/meal_model.dart';
import 'package:reciepe_app/services/api_service.dart';

part 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  final ApiService apiService;
  MealCubit(this.apiService) : super(MealInitial());

  Future<void> getMeals(String category) async {
    emit(MealLoading());
    final result = await apiService.getMeals(category);
    result.fold(
      (failure) => emit(MealError(failure.errorMessage)),
      (meals) => emit(MealLoaded(meals)),
    );
  }
}