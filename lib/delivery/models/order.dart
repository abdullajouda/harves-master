class Order{
  int id;
  String date;
  String time;
  String status;
  int statusId;
  String billNo;
  String price;
  String mapLocation;
  String building;
  String buyer;

  Order(
      {this.date,
        this.id,
      this.time,
      this.status,
      this.statusId,
      this.billNo,
      this.price,
      this.mapLocation,
      this.building,
      this.buyer});
}