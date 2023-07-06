import 'dart:io';

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:delivery_boy/constant/constant.dart';
import 'package:delivery_boy/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivery_boy/pages/home/home_main.dart';
import 'package:delivery_boy/pages/wallet.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int currentIndex;
  late DateTime currentBackPressTime;
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: whiteColor,
        hasNotch: false,
        opacity: 0.2,
        currentIndex: currentIndex,
        // onTap: changePage,
        onTap: (value) {
          changePage(value!);
        },
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(
                16)), //border radius doesn't work when the notch is enabled.
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: primaryColor,
            icon: Icon(
              Icons.local_mall,
              color: greyColor,
            ),
            activeIcon: Icon(
              Icons.local_mall,
              color: primaryColor,
            ),
            title: Text(
              'Order',
              style: bottomBarItemStyle,
            ),
          ),
          // BubbleBottomBarItem(
          //   backgroundColor: primaryColor,
          //   icon: Icon(
          //     Icons.account_balance_wallet,
          //     color: greyColor,
          //   ),
          //   activeIcon: Icon(
          //     Icons.account_balance_wallet,
          //     color: primaryColor,
          //   ),
          //   title: Text(
          //     'Wallet',
          //     style: bottomBarItemStyle,
          //   ),
          // ),
          BubbleBottomBarItem(
            backgroundColor: primaryColor,
            icon: Icon(
              Icons.person,
              color: greyColor,
            ),
            activeIcon: Icon(
              Icons.person,
              color: primaryColor,
            ),
            title: Text(
              'Profile',
              style: bottomBarItemStyle,
            ),
          ),
        ],
      ),
      body: WillPopScope(
        child: (currentIndex == 0)
            ? HomeMain()
            // : (currentIndex == 1)
            //     ? Wallet()
            : Profile(),
        onWillPop: () async {
          bool backStatus = onWillPop();
          if (backStatus) {
            exit(0);
          }
          return false;
        },
      ),
    );
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'Press Back Once Again to Exit.',
        backgroundColor: Colors.black,
        textColor: whiteColor,
      );
      return false;
    } else {
      return true;
    }
  }
}
