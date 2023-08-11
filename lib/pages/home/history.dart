import 'dart:async';

import 'package:delivery_boy/constant/constant.dart';
import 'package:delivery_boy/model/Input/driverMap.dart';
import 'package:delivery_boy/pages/qr.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/page_services/trip_info.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  TripInfo trip = new TripInfo();
  List<DriverMap> ride = [];

  late var timer;
  final deliveryList = [
    {
      'orderId': 'OID123456789',
      'paymentMode': 'Cash on Delivery',
      'payment': '8.50',
      'restaurantAddress': '28 Mott Stret',
      'deliveryAddress': '56 Andheri East'
    },
    {
      'orderId': 'OID123789654',
      'paymentMode': 'Payed',
      'payment': '12.50',
      'restaurantAddress': '91 Opera Street',
      'deliveryAddress': '231 Abc Circle'
    },
    {
      'orderId': 'OID957546521',
      'paymentMode': 'Payed',
      'payment': '15.00',
      'restaurantAddress': '28 Mott Stret',
      'deliveryAddress': '91 Yogi Circle'
    },
    {
      'orderId': 'OID652347952',
      'paymentMode': 'Cash on Delivery',
      'payment': '7.90',
      'restaurantAddress': '28 Mott Stret',
      'deliveryAddress': '54 Xyz Residency'
    },
    {
      'orderId': 'OID658246972',
      'paymentMode': 'Cash on Delivery',
      'payment': '19.50',
      'restaurantAddress': '29 Bar Street',
      'deliveryAddress': '56 Andheri East'
    }
  ];
  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchOrder();
      timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
        fetchOrder();
      });
    } else {
      timer.cancel();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  fetchOrder() async {
    List<DriverMap> fetchride = [];
    fetchride = await trip.getAllorders(await SharedPreferences.getInstance()
        .then((value) => value.getString('access_token')!));

    // filter out the status : COMPLETED order
    if (mounted)
      setState(() {
        ride = fetchride
            .where((element) => element.status == 'COMPLETED')
            .toList();
      });
  }

  Future<String> getCompleteAddress(String latitude, String longitude) async {
    double lat = double.parse(latitude);
    double long = double.parse(longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    Placemark placemark = placemarks.first;
    String address =
        '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
    return address;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ride.length == 0
        ? Center(
            child: Text(
              'No History',
              style: greyHeadingStyle,
            ),
          )
        : Scaffold(
            body: ListView.builder(
              itemCount: ride.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = ride[index];
                return Container(
                  padding: EdgeInsets.all(fixPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              blurRadius: 1.5,
                              spreadRadius: 1.5,
                              color: Colors.grey.shade200,
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(fixPadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.local_taxi,
                                          color: primaryColor, size: 25.0),
                                      widthSpace,
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              '\₹${item.price!.toStringAsFixed(2)}',
                                              style: headingStyle),
                                          heightSpace,
                                          heightSpace,
                                          Text('Payment Mode',
                                              style: lightGreyStyle),
                                          Text("Cash on Delivery",
                                              style: headingStyle),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {},
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: Container(
                                          height: 40.0,
                                          width: 100.0,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            color: primaryColor,
                                          ),
                                          child: Text(
                                            'Delivered',
                                            style: wbuttonWhiteTextStyle,
                                          ),
                                        ),
                                      ),
                                      heightSpace,

                                      !(ride[index].isPaid!)
                                          ? InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          QRScreen(
                                                        upiID: ride[index].upi,
                                                        payeeName: ride[index]
                                                            .businessName,
                                                        amount:
                                                            ride[index].amount,
                                                      ),
                                                    ));
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              child: Container(
                                                height: 40.0,
                                                width: 100.0,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color: primaryColor,
                                                ),
                                                child: Text(
                                                  'Show QR',
                                                  style: wbuttonWhiteTextStyle,
                                                ),
                                              ),
                                            )
                                          : Container()

                                      // heightSpace,
                                      // Text('Payment', style: lightGreyStyle),
                                      // Text(
                                      //     '\$ ${item.price!.toStringAsFixed(2)}',
                                      //     style: headingStyle),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(fixPadding),
                              decoration: BoxDecoration(
                                color: lightGreyColor,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5.0),
                                  bottomLeft: Radius.circular(5.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: (width - fixPadding * 4.0) / 3.2,
                                    child:
                                        // FUTUREBUILDER FOR ADDRESS
                                        FutureBuilder<String>(
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            snapshot.data.toString(),
                                            style: buttonBlackTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        } else {
                                          return Text(
                                            "Loading",
                                            style: buttonBlackTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }
                                      },
                                      future: getCompleteAddress(
                                          ride[index].pickup_lat!,
                                          ride[index].pickup_long!),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: primaryColor,
                                        size: 20.0,
                                      ),
                                      getDot(),
                                      getDot(),
                                      getDot(),
                                      getDot(),
                                      getDot(),
                                      Icon(
                                        Icons.navigation,
                                        color: primaryColor,
                                        size: 20.0,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: (width - fixPadding * 4.0) / 3.2,
                                    child:
                                        // FUTUREBUILDER FOR ADDRESS
                                        FutureBuilder<String>(
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            snapshot.data.toString(),
                                            style: buttonBlackTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        } else {
                                          return Text(
                                            "Loading",
                                            style: buttonBlackTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }
                                      },
                                      future: getCompleteAddress(
                                          ride[index].drop_lat!,
                                          ride[index].drop_long!),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }

  getDot() {
    return Container(
      margin: EdgeInsets.only(left: 2.0, right: 2.0),
      width: 4.0,
      height: 4.0,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(2.0),
      ),
    );
  }
}
