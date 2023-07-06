class Order {
  Order({
    this.customerID,
    this.date,
    this.price,
    this.serviceAreaID,
    this.status,
    this.tripID,
    this.vehicleID,
    this.pickup_lat,
    this.pickup_long,
    this.drop_lat,
    this.drop_long,
  });

  String? pickup_lat;
  String? pickup_long;
  String? drop_lat;
  String? drop_long;

  String? tripID;
  String? customerID;
  String? vehicleID;
  String? date;
  String? status;
  double? price;
  String? serviceAreaID;

  factory Order.fromMap(Map<String, dynamic> json) => Order(
      price: json["price"], //
      vehicleID: json["vehicleId"], //
      pickup_lat: json["pickup"].values.elementAt(0).toString(), //
      pickup_long: json["pickup"].values.elementAt(1).toString(), //
      drop_lat: json["drop"].values.elementAt(0).toString(), //
      drop_long: json["drop"].values.elementAt(1).toString(), //
      tripID: json["_id"], //
      customerID: json["customerId"],
      date: json["createdAt"], //
      status: json["status"], //
      serviceAreaID: json["serviceAreaId"]); //
}
