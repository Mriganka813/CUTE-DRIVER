// import 'dart:async';

import 'package:delivery_boy/constant/constant.dart';
import 'package:delivery_boy/constant/custom_snackbar.dart';
import 'package:delivery_boy/pages/login_signup/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthService auth = AuthService();
  @override
  void initState() {
    super.initState();
    _checkUpdate();
    // authStatus();

    // Future.delayed(Duration.zero, () async {
    //   final service = FlutterBackgroundService();
    //   final isRunning = await service.isRunning();

    //   if (isRunning) {
    //     service.invoke('stopService');
    //   } else {
    //     service.startService();
    //   }
    // });
    // FlutterBackgroundService().invoke('setAsForeground');
  }

  final newVersionPlus = NewVersionPlus();
  Future<void> _checkUpdate() async {
    final status = await newVersionPlus.getVersionStatus();
    if (status!.canUpdate) {
      newVersionPlus.showUpdateDialog(
          context: context, versionStatus: status, allowDismissal: false);
    } else {
      authStatus();
      getLoc();
    }
  }

  askForPermission() async {
    await Geolocator.requestPermission().then((value) => getLoc());
  }

  getLoc() async {
    // LocationPermission permission;

    // permission = await Geolocator.requestPermission();
    await Geolocator.checkPermission().then((value) {
      // print(value);
      // print(value.index);
      if (value.index == 0) {
        SnackBarWidget.showWarningBar(context, "Enable location");
        askForPermission();
      }
    });
    Position position = await Geolocator.getCurrentPosition();
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lat', position.latitude);
    prefs.setDouble('lng', position.longitude);
  }

  Future<void> authStatus() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    final prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? "";
    // final String refresh_token = prefs.getString('refresh_token') ?? "";

    final isAuthenticated = accessToken.isNotEmpty;

    if (isAuthenticated) {
      try {
        await auth.getUser();
      } catch (e) {
        print("error in getting user");
        await auth.getUser();
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(builder: (BuildContext context) => Home()),
          (route) => false);
      prefs.reload();
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(builder: (BuildContext context) => Login()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2647C),
      body: Padding(
        padding: EdgeInsets.all(fixPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/iconp.png',
                width: 200.0,
                fit: BoxFit.fitWidth,
              ),
              heightSpace,
              heightSpace,
              heightSpace,
              SpinKitPulse(
                color: scaffoldBgColor,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
