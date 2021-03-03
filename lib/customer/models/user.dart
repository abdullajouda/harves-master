import 'delivery-data.dart';

class User {
  int id;
  String name;
  String email;
  String mobile;
  int cityId;
  String imageProfile;
  List<DeliveryAddresses> deliveryAddresses;

  User(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.cityId,
        this.imageProfile,
        this.deliveryAddresses});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    cityId = json['city_id'];
    imageProfile = json['image_profile'];
    if (json['delivery_addresses'] != null) {
      deliveryAddresses = new List<DeliveryAddresses>();
      json['delivery_addresses'].forEach((v) {
        deliveryAddresses.add(new DeliveryAddresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['city_id'] = this.cityId;
    data['image_profile'] = this.imageProfile;
    if (this.deliveryAddresses != null) {
      data['delivery_addresses'] =
          this.deliveryAddresses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
