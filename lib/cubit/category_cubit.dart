import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reciepe_app/models/category_model.dart';
import 'package:reciepe_app/services/api_service.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final ApiService apiService;
  CategoryCubit(this.apiService) : super(CategoryInitial());

  Future<void> getCategories() async {
    emit(CategoryLoading());
    final result = await apiService.getCategories();
    result.fold(
      (failure) => emit(CategoryError(failure.errorMessage)),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }
}