import 'package:flutter/cupertino.dart';
import 'package:harvest/customer/models/products.dart';

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
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get items {
    return {..._cartItems};
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

  void removeFav(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void clearFav() {
    _cartItems = {};
    notifyListeners();
  }
}
