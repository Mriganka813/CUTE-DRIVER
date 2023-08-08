import 'dart:async';

import 'package:delivery_boy/model/Input/driverMap.dart';
import 'package:delivery_boy/model/Input/order.dart';
import 'package:delivery_boy/services/page_services/trip_info.dart';
import 'package:flutter/material.dart';
import 'package:delivery_boy/constant/constant.dart';
import 'package:delivery_boy/pages/home/new_order.dart';

import 'package:delivery_boy/pages/home/history.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:delivery_boy/pages/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_boy/pages/map.dart';

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  bool _loading = false;
  bool _isVerified = true;

  TripInfo trip = new TripInfo();
  List<Order> _order = [];
  List<double> _currentLocation = [];
  getLoc() async {
    // loadingDialog();
    // LocationPermission permission;
    // permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    final prefs = await SharedPreferences.getInstance();
    // Navigator.pop(context, true);
    double lat = prefs.getDouble('lat') ?? position.latitude;
    double lng = prefs.getDouble('lng') ?? position.longitude;

    setState(() {
      _currentLocation = [lat, lng];
    });
    return [lat, lng];
  }

  loadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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

  late var timer;
  @override
  void initState() {
    super.initState();

    // get location
    // getLoc().then((value) async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String token = prefs.getString('access_token')!;

    //   try {
    //     List<Order> _initorder = await trip.getTripInfo(token, value);

    //     // populate with 'waiting for driver status'
    //     setState(() {
    //       _loading = true;
    //       _order = _initorder;
    //     });
    //   } catch (e) {
    //     setState(() {
    //       _isVerified = false;
    //     });
    //   }
    // });

    if (mounted) {
      getLoc().then((value) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('access_token')!;

        try {
          List<Order> _initorder = await trip.getTripInfo(token, value);
          print('init=$_initorder');

          // populate with 'waiting for driver status'
          setState(() {
            _loading = true;
            _order = _initorder;
          });
        } catch (e) {
          setState(() {
            _isVerified = false;
          });
        }
      });

      // refresh
      timer = new Timer.periodic(Duration(seconds: 5), (Timer t) {
        refreshdata();
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

  refreshdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token')!;
    List<Order> _initorder = await trip.getTripInfo(token, _currentLocation);
    setState(() {
      _loading = true;
      _order = _initorder;
    });
  }

  @override
  Widget build(BuildContext context) {
    errorActive() {
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
                      Icons.info_outline,
                      size: 40.0,
                      color: primaryColor,
                    ),
                  ),
                  heightSpace,
                  heightSpace,
                  Text(
                    "You have no active order yet.",
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: scaffoldBgColor,
        floatingActionButton: FloatingActionButton(
          tooltip: "Active Order",
          onPressed: () async {
            try {
              List<DriverMap> ride = [];
              ride = await trip.getAllorders(
                  await SharedPreferences.getInstance()
                      .then((value) => value.getString('access_token')!));

              // filter out the status : CONFIREMED/STARTED order
              ride = ride
                  .where((element) =>
                      element.status == 'CONFIRMED' ||
                      element.status == 'STARTED')
                  .toList();

              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: Map(
                        driverMap: ride[0],
                      )));
            } catch (e) {
              errorActive();
            }
          },
          child: Icon(Icons.online_prediction_rounded),
          backgroundColor: primaryColor,
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: whiteColor,
          title: Text(
            'Orders',
            style: bigHeadingStyle,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications, color: blackColor),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: Notifications()));
              },
            ),
          ],
          bottom: TabBar(
            unselectedLabelColor: Colors.grey.withOpacity(0.3),
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            tabs: [
              Tab(text: 'New'),
              // Tab(text: 'Active'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // _loading && _order.isNotEmpty
            //     ? NewOrder(order: _order, currentLocation: _currentLocation)
            //     : Center(child: CircularProgressIndicator()),
            _isVerified
                ? _loading
                    ? _order.isEmpty
                        ? Center(child: Text('No Active Orders'))
                        : NewOrder(
                            order: _order, currentLocation: _currentLocation)
                    : Center(child: CircularProgressIndicator())
                : Center(child: Text('You are not verified yet.')),
            // ActiveOrder(),
            History(),
          ],
        ),
      ),
    );
  }
}
