// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_boy/services/page_services/trip_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';

import 'package:delivery_boy/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/Input/order.dart';
import '../home.dart';

class NewOrder extends StatefulWidget {
  List<Order> order;
  List<double> currentLocation;
  NewOrder({
    Key? key,
    required this.order,
    required this.currentLocation,
  }) : super(key: key);
  @override
  _NewOrderState createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  TripInfo trip = TripInfo();
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

  Future<String> getCompleteAddress(String latitude, String longitude) async {
    double lat = double.parse(latitude);
    double long = double.parse(longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    Placemark placemark = placemarks.first;
    String address =
        '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
    return address;
  }

  // get list of order
  Stream<Future<List<Order>>> getOrders() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token')!;
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      yield trip.getTripInfo(token, widget.currentLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    rejectreasonDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Wrap(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: width,
                      padding: EdgeInsets.all(fixPadding),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Reason to Reject',
                        style: wbuttonWhiteTextStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(fixPadding),
                      alignment: Alignment.center,
                      child: Text('Write a specific reason to reject order'),
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.all(fixPadding),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Enter Reason Here',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          fillColor: Colors.grey.withOpacity(0.1),
                          filled: true,
                        ),
                      ),
                    ),
                    heightSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: (width / 3.5),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              'Cancel',
                              style: buttonBlackTextStyle,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: (width / 3.5),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              'Send',
                              style: wbuttonWhiteTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    heightSpace,
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    loadingDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 150.0,
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SpinKitRing(
                    color: primaryColor,
                    lineWidth: 1.5,
                    size: 35.0,
                  ),
                  heightSpace,
                  heightSpace,
                  Text('Please Wait..'),
                ],
              ),
            ),
          );
        },
      );
    }

    orderAcceptDialog(Order order) async {
      String pickupAddress =
          await getCompleteAddress(order.pickup_lat!, order.pickup_long!);
      String dropAddress =
          await getCompleteAddress(order.drop_lat!, order.drop_long!);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Wrap(
              children: <Widget>[
                Container(
                  width: width,
                  height: height / 1.75,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        width: width,
                        padding: EdgeInsets.all(fixPadding),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "Order",
                          style: wbuttonWhiteTextStyle,
                        ),
                      ),

                      // Order Start
                      // Container(
                      //   margin: EdgeInsets.all(fixPadding),
                      //   decoration: BoxDecoration(
                      //     color: whiteColor,
                      //     borderRadius: BorderRadius.circular(5.0),
                      //     boxShadow: <BoxShadow>[
                      //       BoxShadow(
                      //         blurRadius: 1.5,
                      //         spreadRadius: 1.5,
                      //         color: Colors.grey.shade200,
                      //       ),
                      //     ],
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Container(
                      //         alignment: Alignment.center,
                      //         padding: EdgeInsets.all(fixPadding),
                      //         decoration: BoxDecoration(
                      //             color: lightGreyColor,
                      //             borderRadius: BorderRadius.only(
                      //               topRight: Radius.circular(5.0),
                      //               topLeft: Radius.circular(5.0),
                      //             )),
                      //         child: Text(
                      //           'Order',
                      //           style: buttonBlackTextStyle,
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: EdgeInsets.all(fixPadding),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           children: <Widget>[
                      //             Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: <Widget>[
                      //                 Text(
                      //                   'Deal 1',
                      //                   style: listItemTitleStyle,
                      //                 ),
                      //                 Text(
                      //                   '\$430',
                      //                   style: listItemTitleStyle,
                      //                 ),
                      //               ],
                      //             ),
                      //             heightSpace,
                      //             Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: <Widget>[
                      //                 Text(
                      //                   '7up Regular 250ml',
                      //                   style: listItemTitleStyle,
                      //                 ),
                      //                 Text(
                      //                   '\$80',
                      //                   style: listItemTitleStyle,
                      //                 ),
                      //               ],
                      //             ),
                      //             heightSpace,
                      //             Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: <Widget>[
                      //                 Text(
                      //                   'Delivery Charges',
                      //                   style: listItemTitleStyle,
                      //                 ),
                      //                 Text(
                      //                   '\$10',
                      //                   style: listItemTitleStyle,
                      //                 ),
                      //               ],
                      //             ),
                      //             Divider(),
                      //             Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: <Widget>[
                      //                 Text(
                      //                   'Total',
                      //                   style: headingStyle,
                      //                 ),
                      //                 Text(
                      //                   '\$520',
                      //                   style: priceStyle,
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      //Order End
                      // Location Start
                      Container(
                        margin: EdgeInsets.all(fixPadding),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(fixPadding),
                              decoration: BoxDecoration(
                                  color: lightGreyColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5.0),
                                    topLeft: Radius.circular(5.0),
                                  )),
                              child: Text(
                                'Location',
                                style: buttonBlackTextStyle,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(fixPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            ((width - fixPadding * 13) / 2.0),
                                        child: Text(
                                          'Pickup \nLocation',
                                          style: listItemTitleStyle,
                                        ),
                                      ),
                                      widthSpace,
                                      Container(
                                        width:
                                            ((width - fixPadding * 13) / 2.0),
                                        child: Text(
                                          pickupAddress,
                                          // maxLines: 1,
                                          // overflow: TextOverflow.ellipsis,
                                          style: listItemTitleStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  heightSpace,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            ((width - fixPadding * 13) / 2.0),
                                        child: Text(
                                          'Delivery Location',
                                          style: listItemTitleStyle,
                                        ),
                                      ),
                                      widthSpace,
                                      Container(
                                        width:
                                            ((width - fixPadding * 13) / 2.0),
                                        child: Text(
                                          dropAddress,
                                          // maxLines: 2,
                                          // overflow: TextOverflow.ellipsis,
                                          style: listItemTitleStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Location End

                      // Customer Start
                      // Container(
                      //   margin: EdgeInsets.all(fixPadding),
                      //   decoration: BoxDecoration(
                      //     color: whiteColor,
                      //     borderRadius: BorderRadius.circular(5.0),
                      //     boxShadow: <BoxShadow>[
                      //       BoxShadow(
                      //         blurRadius: 1.5,
                      //         spreadRadius: 1.5,
                      //         color: Colors.grey.shade200,
                      //       ),
                      //     ],
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Container(
                      //         alignment: Alignment.center,
                      //         padding: EdgeInsets.all(fixPadding),
                      //         decoration: BoxDecoration(
                      //             color: lightGreyColor,
                      //             borderRadius: BorderRadius.only(
                      //               topRight: Radius.circular(5.0),
                      //               topLeft: Radius.circular(5.0),
                      //             )),
                      //         child: Text(
                      //           'Customer',
                      //           style: buttonBlackTextStyle,
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: EdgeInsets.all(fixPadding),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           children: <Widget>[
                      //             Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: <Widget>[
                      //                 Text(
                      //                   'Name',
                      //                   style: listItemTitleStyle,
                      //                 ),
                      //                 Text(
                      //                   'Allison Perry',
                      //                   style: listItemTitleStyle,
                      //                 ),
                      //               ],
                      //             ),
                      //             heightSpace,
                      //             Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: <Widget>[
                      //                 Text(
                      //                   'Phone',
                      //                   style: listItemTitleStyle,
                      //                 ),
                      //                 Text(
                      //                   '123456789',
                      //                   style: listItemTitleStyle,
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      //Customer End

                      // Payment Start
                      Container(
                        margin: EdgeInsets.all(fixPadding),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(fixPadding),
                              decoration: BoxDecoration(
                                  color: lightGreyColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5.0),
                                    topLeft: Radius.circular(5.0),
                                  )),
                              child: Text(
                                'Payment',
                                style: buttonBlackTextStyle,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(fixPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.center,
                                  //   children: <Widget>[
                                  //     Container(
                                  //       child: Text(
                                  //         'Payment',
                                  //         style: listItemTitleStyle,
                                  //       ),
                                  //     ),
                                  //     Container(
                                  //       child: Text(
                                  //         'Pay on Delivery',
                                  //         maxLines: 1,
                                  //         overflow: TextOverflow.ellipsis,
                                  //         style: listItemTitleStyle,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Total',
                                        style: headingStyle,
                                      ),
                                      Text(
                                        '₹ ' + order.price!.toStringAsFixed(2),
                                        style: priceStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Payment End
                      heightSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              // setState(() {
                              //   // deliveryList.removeAt(index);
                              // });
                              Navigator.pop(context);
                              // rejectreasonDialog();
                            },
                            child: Container(
                              width: (width / 3.5),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                'Close',
                                style: buttonBlackTextStyle,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String token = prefs.getString('access_token')!;
                              try {
                                await trip.confirmTrip(token, order.tripID,
                                    widget.currentLocation);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            Home()),
                                    (route) => false);
                              } catch (e) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            Home()),
                                    (route) => false);
                              }
                            },
                            child: Container(
                              width: (width / 3.5),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                'Accept',
                                style: wbuttonWhiteTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      heightSpace,
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return ListView.builder(
      itemCount: widget.order.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final item = widget.order[index];
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.local_taxi_outlined,
                                  color: primaryColor, size: 25.0),
                              widthSpace,
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("₹ ${item.price!.toStringAsFixed(2)}",
                                      style: headingStyle),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onTap: () =>
                                    orderAcceptDialog(widget.order[index]),
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 40.0,
                                  width: 100.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: primaryColor,
                                  ),
                                  child: Text(
                                    'Details',
                                    style: wbuttonWhiteTextStyle,
                                  ),
                                ),
                              ),
                              heightSpace,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: (width - fixPadding * 4.0) / 3.2,
                            child: FutureBuilder(
                              future: getCompleteAddress(
                                  item.pickup_lat!, item.pickup_long!),
                              initialData: "Loading...",
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                return Text(
                                  snapshot.data.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: buttonBlackTextStyle,
                                );
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                            child: FutureBuilder(
                              future: getCompleteAddress(
                                  item.drop_lat!, item.drop_long!),
                              initialData: "Loading...",
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                return Text(
                                  snapshot.data.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: buttonBlackTextStyle,
                                );
                              },
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
