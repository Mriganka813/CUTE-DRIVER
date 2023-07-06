import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivery_boy/constant/constant.dart';
import 'package:delivery_boy/pages/login_signup/otp_screen.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../constant/custom_snackbar.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String phoneNumber;
  late String phoneIsoCode;
  late DateTime currentBackPressTime;

  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  final TextEditingController controller = TextEditingController();
  Color continueButtonColor = Colors.grey;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: WillPopScope(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(fixPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  Image.asset(
                    'assets/delivery.png',
                    width: 200.0,
                    fit: BoxFit.fitWidth,
                  ),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  Text('Verify Phone Number', style: greyHeadingStyle),
                  heightSpace,
                  heightSpace,
                  Container(
                    padding: EdgeInsets.only(left: fixPadding),
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
                    child:
                        // Container()
                        // InternationalPhoneInput(
                        //   onPhoneNumberChange: onPhoneNumberChange,
                        //   initialPhoneNumber: phoneNumber,
                        //   initialSelection: phoneIsoCode,
                        //   enabledCountries: [
                        //     '+233',
                        //     '+1',
                        //     '+91',
                        //     '+596',
                        //     '+689',
                        //     '+262',
                        //     '+241',
                        //     '+220',
                        //     '+995',
                        //     '+49',
                        //     '+350'
                        //   ],
                        //   decoration: InputDecoration(
                        //     contentPadding: EdgeInsets.all(15.0),
                        //     hintText: 'Phone Number',
                        //     hintStyle: greyHeadingStyle,
                        //     border: InputBorder.none,
                        //   ),
                        // ),

                        InternationalPhoneNumberInput(
                      textStyle: TextStyle(
                        color: blackColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(
                        color: blackColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      initialValue: number,
                      textFieldController: controller,
                      // inputBorder: InputBorder.none,
                      inputDecoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 20.0, bottom: 12.0),
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(
                          color: greyColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        // border: InputBorder.none,
                      ),
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                      ),
                      onInputChanged: (v) {
                        if (controller.text != '') {
                          setState(() {
                            continueButtonColor = primaryColor;
                          });
                        } else {
                          setState(() {
                            continueButtonColor = Colors.grey;
                          });
                        }
                      },
                    ),
                  ),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: fixPadding),
                    child: InkWell(
                      onTap: () {
                        String phone = controller.text.replaceAll(' ', '');
                        if (phone.length == 10) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OTPScreen(phonenumber: phone)));
                        } else {
                          SnackBarWidget.showErrorBar(
                            context,
                            "Please enter valid mobile number",
                          );
                        }
                      },
                      child: Container(
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: primaryColor,
                        ),
                        child: Text(
                          'Continue',
                          style: wbuttonWhiteTextStyle,
                        ),
                      ),
                    ),
                  ),
                  heightSpace,
                  Text('We\'ll send OTP for Verification.',
                      style: lightGreyStyle),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  // InkWell(
                  //   onTap: () {},
                  //   child: Container(
                  //     padding: EdgeInsets.all(15.0),
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(5.0),
                  //       color: Color(0xFF3B5998),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: <Widget>[
                  //         Image.asset(
                  //           'assets/facebook.png',
                  //           height: 25.0,
                  //           fit: BoxFit.fitHeight,
                  //         ),
                  //         widthSpace,
                  //         Text(
                  //           'Log in with Facebook',
                  //           style: wbuttonWhiteTextStyle,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  heightSpace,
                  heightSpace,
                  // InkWell(
                  //   onTap: () {},
                  //   child: Container(
                  //     padding: EdgeInsets.all(15.0),
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(5.0),
                  //       color: Colors.white,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: <Widget>[
                  //         Image.asset(
                  //           'assets/google.png',
                  //           height: 25.0,
                  //           fit: BoxFit.fitHeight,
                  //         ),
                  //         widthSpace,
                  //         Text(
                  //           'Log in with Google',
                  //           style: buttonBlackTextStyle,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
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
