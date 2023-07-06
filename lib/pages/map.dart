// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_boy/constant/custom_snackbar.dart';
import 'package:delivery_boy/pages/route_map.dart';
import 'package:delivery_boy/services/page_services/trip_info.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:delivery_boy/constant/constant.dart';
import 'package:delivery_boy/model/Input/driverMap.dart';
import 'package:delivery_boy/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../services/const.dart';

class Map extends StatefulWidget {
  DriverMap driverMap;
  Map({
    Key? key,
    required this.driverMap,
  }) : super(key: key);
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  // late BitmapDescriptor customIcon;
  late Set<Marker> markers;
  late IO.Socket socket;
  TripInfo tripInfo = TripInfo();
  String otp = "";
  bool otpInvisibility = true;

  late bool isPing = false;
  late bool isOtp = false;
  late bool isEndRide = false;

  @override
  void initState() {
    super.initState();
    markers = Set.from([]);
    if (widget.driverMap.status == 'STARTED')
      isEndRide = true;
    else
      isPing = true;
    connect();
    // if (customIcon == null) {
    //   BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(100, 100)),
    //           'assets/custom_marker.png')
    //       .then((icon) {
    //     print(icon.toString());
    //     customIcon = icon;
    //   });
    // }
  }

  /// Socket.io connection
  ///
  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token')!;
    print(token);
    print(widget.driverMap.driverSocketID);

    final socket = IO.io(Const.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'query': {
        'accessToken': '$token',
        'isReconnect': false,
        'previousId': widget.driverMap.driverSocketID,
        'role': 'DRIVER'
      }
    });
    setState(() {
      this.socket = socket;
    });
    socket.on('success', (data) {
      print(data);
    });

    socket.onError((data) => print(data));
  }

  Future<String> getfromAddress(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark placemark = placemarks.first;
    String address =
        '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
    return address;
  }

  List<double> _currentLocation = [];
  getLoc() async {
    // loadingDialog();
    // LocationPermission permission;
    // permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    // Navigator.pop(context, true);
    double lat = position.latitude;
    double lng = position.longitude;

    setState(() {
      _currentLocation = [lat, lng];
    });
    return [lat, lng];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    viewOrderDetail() async {
      String pickupAddress = await getfromAddress(
          double.parse(widget.driverMap.pickup_lat!),
          double.parse(widget.driverMap.pickup_long!));
      String dropAddress = await getfromAddress(
          double.parse(widget.driverMap.drop_lat!),
          double.parse(widget.driverMap.drop_long!));

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
                  height: height / 1.5,
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
                          'Order Detail',
                          style: wbuttonWhiteTextStyle,
                        ),
                      ),

                      // Order Start
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
                                'Order',
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
                                  //     Text(
                                  //       'Deal 1',
                                  //       style: listItemTitleStyle,
                                  //     ),
                                  //     Text(
                                  //       '\$430',
                                  //       style: listItemTitleStyle,
                                  //     ),
                                  //   ],
                                  // ),
                                  // heightSpace,
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.center,
                                  //   children: <Widget>[
                                  //     Text(
                                  //       '7up Regular 250ml',
                                  //       style: listItemTitleStyle,
                                  //     ),
                                  //     Text(
                                  //       '\$80',
                                  //       style: listItemTitleStyle,
                                  //     ),
                                  //   ],
                                  // ),
                                  // heightSpace,
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.center,
                                  //   children: <Widget>[
                                  //     Text(
                                  //       'Delivery Charges',
                                  //       style: listItemTitleStyle,
                                  //     ),
                                  //     Text(
                                  //       '\$10',
                                  //       style: listItemTitleStyle,
                                  //     ),
                                  //   ],
                                  // ),
                                  // Divider(),
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
                                        '\₹${widget.driverMap.price!.toStringAsFixed(2)}',
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
                                          'Pickup Location',
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          'Payment',
                                          style: listItemTitleStyle,
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          'Pay on Delivery',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                      // Payment End
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: width,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(fixPadding),
                          padding: EdgeInsets.all(fixPadding),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Ok',
                            style: wbuttonWhiteTextStyle,
                          ),
                        ),
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

    deliveryFinishDialog() {
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
              height: 170.0,
              padding: EdgeInsets.all(fixPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.0),
                      border: Border.all(color: primaryColor, width: 1.0),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 40.0,
                      color: primaryColor,
                    ),
                  ),
                  heightSpace,
                  heightSpace,
                  Text(
                    "Congratulation! Ride Completed.",
                    textAlign: TextAlign.center,
                    style: greyHeadingStyle,
                  ),
                  heightSpace,
                ],
              ),
            ),
          );
        },
      );

      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      });
    }

    deliveryfinishErrorDialog() {
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
              height: 170.0,
              padding: EdgeInsets.all(fixPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.0),
                      border: Border.all(color: primaryColor, width: 1.0),
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 40.0,
                      color: primaryColor,
                    ),
                  ),
                  heightSpace,
                  heightSpace,
                  Text(
                    "You are not allowed to end ride.\nAsk customer to end ride.",
                    textAlign: TextAlign.center,
                    style: greyHeadingStyle,
                  ),
                  heightSpace,
                ],
              ),
            ),
          );
        },
      );

      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);
      });
    }

    customerinformedDialog() {
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
              height: 170.0,
              padding: EdgeInsets.all(fixPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.0),
                      border: Border.all(color: primaryColor, width: 1.0),
                    ),
                    child: Icon(
                      Icons.tap_and_play,
                      size: 40.0,
                      color: primaryColor,
                    ),
                  ),
                  heightSpace,
                  heightSpace,
                  Text(
                    "The customer has been informed.",
                    textAlign: TextAlign.center,
                    style: greyHeadingStyle,
                  ),
                  heightSpace,
                ],
              ),
            ),
          );
        },
      );

      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);
      });
    }

    otpsuccesDialog() {
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
              height: 170.0,
              padding: EdgeInsets.all(fixPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.0),
                      border: Border.all(color: primaryColor, width: 1.0),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 40.0,
                      color: primaryColor,
                    ),
                  ),
                  heightSpace,
                  heightSpace,
                  Text(
                    "Your trip has been started.",
                    textAlign: TextAlign.center,
                    style: greyHeadingStyle,
                  ),
                  heightSpace,
                ],
              ),
            ),
          );
        },
      );
      setState(() {
        otpInvisibility = false;
      });
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);
      });
    }

    otpfailedDialog() {
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
              height: 170.0,
              padding: EdgeInsets.all(fixPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.0),
                      border: Border.all(color: primaryColor, width: 1.0),
                    ),
                    child: Icon(
                      Icons.error_outline_sharp,
                      size: 40.0,
                      color: primaryColor,
                    ),
                  ),
                  heightSpace,
                  heightSpace,
                  Text(
                    "Your OTP is wrong.",
                    textAlign: TextAlign.center,
                    style: greyHeadingStyle,
                  ),
                  heightSpace,
                ],
              ),
            ),
          );
        },
      );
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Active Order',
          style: headingStyle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomSheet: Wrap(
        children: <Widget>[
          Material(
            elevation: 7.0,
            child: Container(
              padding: EdgeInsets.all(fixPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Visibility(
                    visible: isPing,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width,
                          child: Text(
                            "Notify customer that you arrived at the pickup location.",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: listItemSubTitleStyle,
                            textScaleFactor: 1.2,
                            maxLines: 2,
                          ),
                        ),
                        heightSpace,
                        Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () async {
                              tripInfo.pingCustomer(
                                  await SharedPreferences.getInstance().then(
                                      (value) =>
                                          value.getString('access_token')!),
                                  widget.driverMap.tripID);
                              customerinformedDialog();
                              setState(() {
                                isPing = false;
                                isOtp = true;
                              });
                            },
                            child: Container(
                              height: 40.0,
                              width: width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: primaryColor,
                              ),
                              child: Text(
                                'Arrived',
                                style: wbuttonWhiteTextStyle,
                                textScaleFactor: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  heightSpace,
                  //OTP filed
                  Visibility(
                    visible: isOtp,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                letterSpacing: 3.0,
                                decoration: TextDecoration.none),
                            decoration: InputDecoration(
                              hintText: "Enter OTP",
                              hintStyle: TextStyle(
                                  color: Colors.grey, letterSpacing: 1.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                otp = value;
                              });
                            },
                          ),
                        ),
                        heightSpace,
                        Container(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () async {
                              SnackBarWidget.showInfoBar(
                                  context, "Please wait...");
                              bool success = false;
                              try {
                                await tripInfo.startRide(
                                    await SharedPreferences.getInstance().then(
                                        (value) =>
                                            value.getString('access_token')!),
                                    widget.driverMap.tripID,
                                    otp);
                                success = true;
                              } catch (e) {
                                print("yes wrong it is");
                                success = false;
                              }
                              if (success) {
                                otpsuccesDialog();
                                setState(() {
                                  isOtp = false;
                                  isEndRide = true;
                                });
                              } else
                                otpfailedDialog();
                            },
                            child: Container(
                              height: 40.0,
                              width: width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: primaryColor,
                              ),
                              child: Text(
                                'START',
                                style: wbuttonWhiteTextStyle,
                                textScaleFactor: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  heightSpace,
                  // EndRide
                  Visibility(
                    visible: isEndRide,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width,
                          child: Text(
                            "Reached destination! Tap to end ride",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: listItemSubTitleStyle,
                            textScaleFactor: 1.2,
                            maxLines: 2,
                          ),
                        ),
                        heightSpace,
                        Container(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () async {
                              SnackBarWidget.showInfoBar(
                                  context, "Please wait...");
                              bool success = false;
                              try {
                                await getLoc();
                                await tripInfo.finishRide(
                                    await SharedPreferences.getInstance().then(
                                        (value) =>
                                            value.getString('access_token')!),
                                    widget.driverMap.tripID,
                                    _currentLocation);
                                success = true;
                              } catch (e) {
                                success = false;
                              }

                              if (success)
                                deliveryFinishDialog();
                              else
                                deliveryfinishErrorDialog();
                            },
                            child: Container(
                              height: 40.0,
                              width: width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: primaryColor,
                              ),
                              child: Text(
                                'End',
                                style: wbuttonWhiteTextStyle,
                                textScaleFactor: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 150.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                viewOrderDetail();
              },
              backgroundColor: whiteColor,
              child: Icon(
                Icons.assignment,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: RouteMap(
          sourceLat: double.parse(widget.driverMap.pickup_lat!),
          sourceLang: double.parse(widget.driverMap.pickup_long!),
          destinationLat: double.parse(widget.driverMap.drop_lat!),
          destinationLang: double.parse(widget.driverMap.drop_long!),
          driverLat: double.parse(widget.driverMap.driver_lat!),
          driverLang: double.parse(widget.driverMap.driver_long!),
          socket: socket),
    );
  }
}
