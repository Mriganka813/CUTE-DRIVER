// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:delivery_boy/constant/constant.dart';
import 'package:delivery_boy/pages/home.dart';

import '../../constant/custom_snackbar.dart';
import '../../services/auth.dart';
import '../../services/global.dart';
import '../../services/locator.dart';
import '../profile/signup_profile.dart';

class OTPScreen extends StatefulWidget {
  String phonenumber;
  OTPScreen({
    Key? key,
    required this.phonenumber,
  }) : super(key: key);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var firstController = TextEditingController();
  var secondController = TextEditingController();
  var thirdController = TextEditingController();
  var fourthController = TextEditingController();
  FocusNode secondFocusNode = FocusNode();
  FocusNode thirdFocusNode = FocusNode();
  FocusNode fourthFocusNode = FocusNode();

  // My_Changes

  final _authInstace = FirebaseAuth.instance;
  String _verificationId = "";
  String code = "";
  String smsotp = "";
  String name = "";
  String address = "";
  bool isverified = false;
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    getotp(widget.phonenumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(fixPadding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Verification',
                  style: bigHeadingStyle,
                ),
                heightSpace,
                Text(
                  'Enter the OTP code from the phone we just sent you.',
                  style: lightGreyStyle,
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                // OTP Box Start
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    code == ""
                        ? otpfild("")
                        : otpfild(code.characters.elementAt(0)),
                    code == ""
                        ? otpfild("")
                        : otpfild(code.characters.elementAt(1)),
                    code == ""
                        ? otpfild("")
                        : otpfild(code.characters.elementAt(2)),
                    code == ""
                        ? otpfild("")
                        : otpfild(code.characters.elementAt(3)),
                    code == ""
                        ? otpfild("")
                        : otpfild(code.characters.elementAt(4)),
                    code == ""
                        ? otpfild("")
                        : otpfild(code.characters.elementAt(5)),
                  ],
                ),
                // OTP Box End
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                heightSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Didn\'t receive OTP Code!', style: lightGreyStyle),
                    widthSpace,
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Resend',
                        style: listItemTitleStyle,
                      ),
                    ),
                  ],
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: fixPadding),
                  child: InkWell(
                    onTap: () async {
                      if (smsotp == "" && code == "") {
                        locator<GlobalServices>()
                            .errorSnackBar("Verification Failed");
                        SnackBarWidget.showErrorBar(
                            context, "Verification Failed");

                        return;
                      }
                      await verifyOtp();
                      isverified
                          ? await auth
                              .signInRequest(int.parse(widget.phonenumber))
                              .then((value) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                  (route) => false);
                            }).catchError((e) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          SignupProfile(
                                              phone: widget.phonenumber)),
                                  (route) => false);
                            })
                          : Navigator.pop(context);
                    },
                    // onTap: () {
                    //   print(widget.phonenumber);
                    //   print(code);
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) => Home()));
                    // },
                    child: Container(
                      height: 50.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: primaryColor,
                      ),
                      child: Text(
                        'Submit',
                        style: wbuttonWhiteTextStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  getotp(String phone) async {
    await _authInstace.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("Yaha aaya h kya ?");
        setState(() {
          code = credential.smsCode!;
          // continueButtonColor = primaryColor;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        locator<GlobalServices>().errorSnackBar("Verification Failed");
        SnackBarWidget.showErrorBar(context, "Verification Failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        locator<GlobalServices>().successSnackBar("Code sent");
        SnackBarWidget.showInfoBar(context, "Code sent");
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  ///
  verifyOtp() async {
    locator<GlobalServices>().infoSnackBar("Verifying...");
    SnackBarWidget.showInfoBar(context, "Please wait verifying...");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: code != "" ? code : smsotp);

    try {
      await _authInstace.signInWithCredential(credential).then((value) {
        locator<GlobalServices>().successSnackBar("Verified ✓");
        SnackBarWidget.showSuccessBar(context, "Verified ✓");

        setState(() {
          isverified = true;
        });
      });
    } catch (e) {
      locator<GlobalServices>().errorSnackBar("Verificastion falied");
      SnackBarWidget.showErrorBar(context, "Verification Failed");

      setState(() {
        code = "";
        smsotp = "";
        // isverified = true;
      });
    }
  }

  Widget otpfild(digit) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width / 7;

    return Container(
      width: width / 1.2,
      height: height / 13,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(width: 0.2, color: primaryColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 1.5,
            spreadRadius: 1.5,
            color: Colors.grey.shade300,
          ),
        ],
      ),
      child: TextFormField(
        key: Key(digit),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        keyboardType: TextInputType.number,
        initialValue: digit,
        onChanged: (value) {
          if (value.length == 1) {
            smsotp = smsotp + value;
            FocusScope.of(context).nextFocus();
          }
        },
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: height / 30,
            // color: notifier.getblackcolor,
            fontFamily: 'Gilroy Bold'),
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 150.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitPulse(
                  color: primaryColor,
                  size: 50.0,
                ),
                heightSpace,
                heightSpace,
                Text('Please Wait..', style: lightGreyStyle),
              ],
            ),
          ),
        );
      },
    );
    Timer(
        Duration(seconds: 3),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            ));
  }
}
