class City {
  int id;
  double deliveryCost;
  int minOrder;
  String createdAt;
  String name;

  City({this.id, this.deliveryCost, this.minOrder, this.createdAt, this.name});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveryCost = double.parse(json["deliveryCost"].toString());
    minOrder = json['min_order'];
    createdAt = json['created_at'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deliveryCost'] = this.deliveryCost;
    data['min_order'] = this.minOrder;
    data['created_at'] = this.createdAt;
    data['name'] = this.name;
    return data;
  }
}
