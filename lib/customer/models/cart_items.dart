import 'package:flutter/cupertino.dart';
import 'package:harvest/customer/models/products.dart';

import 'delivery-data.dart';
import 'delivery_time_avaiable.dart';

class CartItem {
  int id;
  int userId;
  String fcmToken;
  int quantity;
  int productId;
  String createdAt;
  Products product;

  CartItem(
      {this.id,
      this.userId,
      this.fcmToken,
      this.quantity,
      this.productId,
      this.createdAt,
      this.product});

  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fcmToken = json['fcm_token'];
    quantity = json['quantity'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    product =
        json['product'] != null ? new Products.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['fcm_token'] = this.fcmToken;
    data['quantity'] = this.quantity;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class Cart with ChangeNotifier {
  List<int> _errors = [];
  double total;
  double totalPrice;
  String additionalNote;
  String promo;
  DeliveryAddresses deliveryAddresses;
  AvailableDates availableDates;
  Times time;

  void setDate(AvailableDates date) {
    availableDates = date;
    notifyListeners();
  }

  void setTime(Times times) {
    time = times;
    notifyListeners();
  }

  void setAddress(DeliveryAddresses addresses) {
    deliveryAddresses = addresses;
    notifyListeners();
  }

  void setTotal(double tot) {
    total = tot;
    notifyListeners();
  }
  void setTotalPrice(double tot) {
    totalPrice = tot;
    notifyListeners();
  }

  void setAdditional(String note) {
    additionalNote = note;
    notifyListeners();
  }

  void setPromo(String code) {
    promo = code;
    notifyListeners();
  }

  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get items {
    return {..._cartItems};
  }

  List<int> get errors{
    return _errors;
  }

  int get itemCount {
    return _cartItems.length;
  }

  void addItem(CartItem item) {
    if (_cartItems.containsKey(item.id)) {
      _cartItems.update(item.id.toString(), (existing) => item);
    } else {
      _cartItems.putIfAbsent(item.id.toString(), () => item);
    }
    notifyListeners();
  }

  void addError(int index){
    _errors.add(index);
  }

  void removeFav(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void clearFav() {
    _cartItems = {};
    notifyListeners();
  }
}
