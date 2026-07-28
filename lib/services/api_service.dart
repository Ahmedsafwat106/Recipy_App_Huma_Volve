import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:reciepe_app/error/error_handler.dart';
import 'package:reciepe_app/error/failure.dart';
import 'package:reciepe_app/models/category_model.dart';

class ApiService {
  final dio = Dio(
    BaseOptions(
      // connectTimeout: ,
      // receiveTimeout: Duration(milliseconds: 1),
      baseUrl: "https://www.themealdb.com/api/json/v1/1",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    ),
  );
  ApiService() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("=======================Request=====================");
          print(options.method);
          print(options.baseUrl);
          print(options.path);
          print(options.queryParameters);
          print(options.data);
          print("==================================================");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("=====================Response======================");
          print(response.statusCode);
          print(response.statusMessage);
          print(response.headers);
          print(response.requestOptions);
          print(response.isRedirect);
          print(response.redirects);
          print(response.data);
          print("==================================================");
          return handler.next(response);
        },
        onError: (error, handler) {
          print("=====================Error======================");
          print(error.response?.statusCode);
          print(error.response?.statusMessage);
          print(error.response?.headers);
          print(error.response?.requestOptions);
          print("==================================================");
          return handler.next(error);
        },
      ),
    );
  }

  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final response = await dio.get("/categories.php");
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final jsonRes = response.data["categories"] as List;
        final modelRes = jsonRes
            .map(((e) => CategoryModel.fromJson(e)))
            .toList();
        return right(modelRes);
      } else {
        throw Exception("Something went wrong");
      }
    } on DioException catch (e) {
      final failure = HandleError.handle(e);
      return left(failure);
    }
  }
  //https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood
}
