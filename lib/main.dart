import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di/service_locator.dart';
import 'features/recipe/data/models/category_model.dart';
import 'features/recipe/data/models/meal_model.dart';
import 'features/recipe/presentation/screens/seafood_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(MealModelAdapter());

  await setupServiceLocator();
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 226, 227, 227),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 148, 76, 17),
          surface: const Color.fromARGB(255, 226, 227, 227),
        ),
        fontFamily: 'Roboto',
      ),
      home: const SeafoodScreen(),
    );
  }
}