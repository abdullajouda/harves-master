import 'package:harvest/customer/models/products.dart';

class FavoriteModel {
  int id;
  int userId;
  Null fcmToken;
  int productId;
  String createdAt;
  Products product;

  FavoriteModel(
      {this.id,
        this.userId,
        this.fcmToken,
        this.productId,
        this.createdAt,
        this.product});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fcmToken = json['fcm_token'];
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
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}