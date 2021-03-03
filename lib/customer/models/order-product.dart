import 'package:harvest/customer/models/products.dart';

class OrderProduct {
  int id;
  int orderId;
  int productId;
  int quantity;
  int price;
  String createdAt;
  Null updatedAt;
  Null deletedAt;
  Products product;

  OrderProduct(
      {this.id,
        this.orderId,
        this.productId,
        this.quantity,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.product});

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    product =
    json['product'] != null ? new Products.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}