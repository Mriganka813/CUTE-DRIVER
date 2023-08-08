class Order {
  Order({
    this.customerID,
    this.date,
    this.price,
    this.serviceAreaID,
    this.status,
    this.tripID,
    this.vehicleID,
    this.silent,
    this.pickupLat,
    this.pickupLong,
    this.dropLat,
    this.dropLong,
  });

  String? pickupLat;
  String? pickupLong;
  String? dropLat;
  String? dropLong;

  String? tripID;
  String? customerID;
  String? vehicleID;
  String? date;
  String? status;
  double? price;
  String? serviceAreaID;
  List? silent;

  factory Order.fromMap(Map<String, dynamic> json) => Order(
      price: double.parse(json["price"].toString()), //
      vehicleID: json["vehicleId"], //
      pickupLat: json["pickup"].values.elementAt(0).toString(), //
      pickupLong: json["pickup"].values.elementAt(1).toString(), //
      dropLat: json["drop"].values.elementAt(0).toString(), //
      dropLong: json["drop"].values.elementAt(1).toString(), //
      silent: json['silent'] as List,
      tripID: json["_id"], //
      customerID: json["customerId"],
      date: json["createdAt"], //
      status: json["status"], //
      serviceAreaID: json["serviceAreaId"]); //
}
