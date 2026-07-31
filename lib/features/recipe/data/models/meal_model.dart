import 'package:hive/hive.dart';
import '../../domain/entities/meal_entity.dart';

part 'meal_model.g.dart';

@HiveType(typeId: 1)
class MealModel extends HiveObject {
  @HiveField(0)
  final String idMeal;
  @HiveField(1)
  final String strMeal;
  @HiveField(2)
  final String strMealThumb;

  MealModel({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
    );
  }

  MealEntity toEntity() {
    return MealEntity(
      idMeal: idMeal,
      strMeal: strMeal,
      strMealThumb: strMealThumb,
    );
  }
}