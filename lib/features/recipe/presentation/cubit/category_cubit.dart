import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  CategoryCubit(this.getCategoriesUseCase) : super(CategoryInitial());

  Future<void> getCategories() async {
    emit(CategoryLoading());
    final result = await getCategoriesUseCase();
    result.fold(
      (failure) => emit(CategoryError(failure.errorMessage)),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }
}