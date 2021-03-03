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
