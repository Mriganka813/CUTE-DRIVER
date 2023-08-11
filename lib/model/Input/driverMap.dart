// ignore_for_file: non_constant_identifier_names

class DriverMap {
  DriverMap({
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
    this.customerSocketID,
    this.driverSocketID,
    this.otp,
    this.driver_lat,
    this.driver_long,
    this.driverId,
    this.isPaid,
    this.upi,
    this.businessName,
    this.amount,
    this.orderId,
  });

  String? pickup_lat;
  String? pickup_long;
  String? drop_lat;
  String? drop_long;

  String? driver_lat;
  String? driver_long;

  String? tripID;
  String? customerID;
  String? vehicleID;
  String? date;
  String? status;
  double? price;
  String? serviceAreaID;

  String? customerSocketID;
  String? driverSocketID;
  String? otp;
  String? driverId;
  bool? isPaid;
  String? upi;
  String? businessName;
  int? amount;
  String? orderId;

  factory DriverMap.fromMap(Map<String, dynamic> json) => DriverMap(
        price: double.parse(json["price"].toString()),
        vehicleID: json["vehicleId"],
        pickup_lat: json["pickup"].values.elementAt(0).toString(),
        pickup_long: json["pickup"].values.elementAt(1).toString(),
        drop_lat: json["drop"].values.elementAt(0).toString(),
        drop_long: json["drop"].values.elementAt(1).toString(),
        status: json["status"],
        driver_lat: json["subTrips"][0]["start"]["lat"].toString(),
        driver_long: json["subTrips"][0]["start"]["long"].toString(),
        tripID: json["_id"],
        customerID: json["customerId"],
        date: json["createdAt"],
        serviceAreaID: json["serviceAreaId"],
        driverSocketID: json["driverSocket"],
        otp: json["otp"],
        customerSocketID: json['customerSocket'],
        driverId: json['driverId'],
        isPaid: json['isPaid'],
        upi: json['upi'],
        businessName: json['businessName'],
        amount: json['amount'],
        orderId: json['orderId'],
      );
}
