import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:harvest/customer/models/category.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:http/http.dart';

class ApiHelper with ChangeNotifier {
  static const String api = 'https://control.harvest.qa/api/';

  static const Map<String, String> headers = {
    'Accept': 'application/json',
    'Accept-Language': 'en',
  };

  static const Map<String, String> headersWithAuth = {
    'Accept': 'application/json',
    'Accept-Language': 'en',
    'Authorization':'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImMzMDZlNjE3Y2QwYjM4OGQyOTU2ODc1ZWNlN2VhYTllOGYxZTBhMDg4ZTI2YjYzMjA4OTUxMjI4NzkwMTNkMWEwMzY2Y2YzZGMyZjg3MGM4In0.eyJhdWQiOiIxIiwianRpIjoiYzMwNmU2MTdjZDBiMzg4ZDI5NTY4NzVlY2U3ZWFhOWU4ZjFlMGEwODhlMjZiNjMyMDg5NTEyMjg3OTAxM2QxYTAzNjZjZjNkYzJmODcwYzgiLCJpYXQiOjE1OTkzNDEwOTUsIm5iZiI6MTU5OTM0MTA5NSwiZXhwIjoxNjMwODc3MDk1LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.ntX-amCRR3Yk9ORuvspYZrqsTdE6B2ulbDfYxA4a6UAPPQLnP9wZ5zmFeydLBWOublefUu7OnQtff_E7_YkOkdOVbVFvfsZfVRuntYQWQzmaRk0QMdrZ-2klr6HVfO5IBYuQFwkDtnv3So_V4baxput20CindGTkvIuuzZxFG4NWLL4V2av0rHPRsbw9shrihQQAOZHuUCDqq53edHUBgwRbAs-BNkBa0YIyiqQv2GnBknxbAleUnoapbpcP9YCEgG0NB-c6hN9QOpha5dvE7Du6QPguOwj5FqPouH98YLPLS2LgUtr_cbjLkTaUGH5_QH15UeJpS49i7SSQk5DC_Ine_6xCmpfhCIxhPOKed39Gng0utgHKMwehW8iByVQbzwfA72n1ELhePjx6KZFqU0kpsRQ51LBCIkFqvmmSsi5VQo3071RO05D0k5baz_Q8Otclk03tpSu_JqNHDIRy0-88x-MphYEk-s5VckkBYwu7tNXK-dHMUZmoEEHa2qlS9f7ehEJ6MBODzMT5QGAr-qRr2sfaAXeMVEKxCIywq3PpQnFHbwUsK6isZDqKeEU820cN3yHuqzpNiMJZ0kAJkrMtSCKRT4C3mZ6leloQQE1LoSH-Rz99ueNAlTJoW3IZ_nQHUIYQntZFOZhkaAl8WcANEb2xUZlUIz4_XOIDdh0'
  };

  Category selectedCategory;

  setCat(Category cat){
    selectedCategory = cat;
  }

  Future<List<Category>> getCategories() async {
    var request = await get(api + 'getCategories', headers: headers);
    var response = json.decode(request.body);
    List values = response['items'];
    List<Category> _category = [];
    values.forEach((element) {
      Category category = Category.fromJson(element);
      _category.add(category);
    });
    notifyListeners();
    return _category;
  }

// Future<List<Products>> getProductsByCategories(Category category) async {
//   var request = await get(api + 'getProductsByCategoryId/${category.id??1}', headers: headers);
//   var response = json.decode(request.body);
//   List values = response['items'];
//   List<Products> _products = [];
//   values.forEach((element) {
//     Products products = Products.fromJson(element);
//     _products.add(products);
//   });
//   return _products;
// }
}
