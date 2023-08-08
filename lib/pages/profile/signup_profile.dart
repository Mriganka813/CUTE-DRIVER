// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:delivery_boy/constant/custom_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:delivery_boy/constant/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/Input/signupinput.dart';
import '../../model/Input/user.dart';
import '../../services/auth.dart';
import '../splashScreen.dart';

class SignupProfile extends StatefulWidget {
  String phone;
  SignupProfile({
    Key? key,
    required this.phone,
  }) : super(key: key);
  @override
  _SignupProfileState createState() => _SignupProfileState();
}

class _SignupProfileState extends State<SignupProfile> {
  String name = '';
  String address = '';
  String license = '';
  String phone = '';
  String email = '';
  String vehicleType = 'Bike';
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var licenseController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();

  var vehicles = [
    'Bike',
    'Car',
    'Pickup truck',
  ];

  SignUpInput input = new SignUpInput();
  AuthService auth = AuthService();
  User user = User();

  @override
  void initState() {
    super.initState();
    nameController.text = name;
    phoneController.text = phone;
    emailController.text = email;
    licenseController.text = license;
  }

  askForPermission() async {
    await Geolocator.requestPermission().then((value) => getLoc());
  }

  getLoc() async {
    // LocationPermission permission;

    // permission = await Geolocator.requestPermission();
    await Geolocator.checkPermission().then((value) {
      if (value.index == 0) {
        SnackBarWidget.showWarningBar(context, "Enable location manually");
        askForPermission();
      }
    });
    Position position = await Geolocator.getCurrentPosition();
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lat', position.latitude);
    prefs.setDouble('lng', position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    changeFullName() {
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
              height: 200.0,
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Change Full Name",
                    style: headingStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: nameController,
                    style: buttonBlackTextStyle,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Full Name',
                      hintStyle: greyHeadingStyle,
                    ),
                  ),
                  SizedBox(height: 20.0),
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
                          setState(() {
                            name = nameController.text;
                            Navigator.pop(context);
                          });
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
                            'Okay',
                            style: wbuttonWhiteTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    changeAddress() {
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
              height: 200.0,
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Change Address",
                    style: headingStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: addressController,
                    style: buttonBlackTextStyle,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Full Address',
                      hintStyle: greyHeadingStyle,
                    ),
                  ),
                  SizedBox(height: 20.0),
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
                          setState(() {
                            address = addressController.text;
                            Navigator.pop(context);
                          });
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
                            'Okay',
                            style: wbuttonWhiteTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    changeLicense() {
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
              height: 200.0,
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Change License",
                    style: headingStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: licenseController,
                    style: buttonBlackTextStyle,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter Your License Number',
                      hintStyle: greyHeadingStyle,
                    ),
                  ),
                  SizedBox(height: 20.0),
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
                          setState(() {
                            license = licenseController.text;
                            Navigator.pop(context);
                          });
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
                            'Okay',
                            style: wbuttonWhiteTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    // changePassword() {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       // return object of type Dialog
    //       return Dialog(
    //         elevation: 0.0,
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0)),
    //         child: Container(
    //           height: 295.0,
    //           padding: EdgeInsets.all(20.0),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //               Text(
    //                 "Change Your Password",
    //                 style: headingStyle,
    //               ),
    //               SizedBox(
    //                 height: 20.0,
    //               ),
    //               TextField(
    //                 obscureText: true,
    //                 style: TextStyle(
    //                   fontSize: 16.0,
    //                   fontWeight: FontWeight.w700,
    //                   fontFamily: 'Signika Negative',
    //                 ),
    //                 decoration: InputDecoration(
    //                   hintText: 'Old Password',
    //                   hintStyle: greyHeadingStyle,
    //                 ),
    //               ),
    //               TextField(
    //                 obscureText: true,
    //                 style: TextStyle(
    //                   fontSize: 16.0,
    //                   fontWeight: FontWeight.w700,
    //                   fontFamily: 'Signika Negative',
    //                 ),
    //                 decoration: InputDecoration(
    //                   hintText: 'New Password',
    //                   hintStyle: greyHeadingStyle,
    //                 ),
    //               ),
    //               TextField(
    //                 obscureText: true,
    //                 style: TextStyle(
    //                   fontSize: 16.0,
    //                   fontWeight: FontWeight.w700,
    //                   fontFamily: 'Signika Negative',
    //                 ),
    //                 decoration: InputDecoration(
    //                   hintText: 'Confirm New Password',
    //                   hintStyle: greyHeadingStyle,
    //                 ),
    //               ),
    //               SizedBox(height: 20.0),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: <Widget>[
    //                   InkWell(
    //                     onTap: () {
    //                       Navigator.pop(context);
    //                     },
    //                     child: Container(
    //                       width: (width / 3.5),
    //                       alignment: Alignment.center,
    //                       padding: EdgeInsets.all(10.0),
    //                       decoration: BoxDecoration(
    //                         color: Colors.grey[300],
    //                         borderRadius: BorderRadius.circular(5.0),
    //                       ),
    //                       child: Text(
    //                         'Cancel',
    //                         style: buttonBlackTextStyle,
    //                       ),
    //                     ),
    //                   ),
    //                   InkWell(
    //                     onTap: () {
    //                       Navigator.pop(context);
    //                     },
    //                     child: Container(
    //                       width: (width / 3.5),
    //                       alignment: Alignment.center,
    //                       padding: EdgeInsets.all(10.0),
    //                       decoration: BoxDecoration(
    //                         color: primaryColor,
    //                         borderRadius: BorderRadius.circular(5.0),
    //                       ),
    //                       child: Text(
    //                         'Okay',
    //                         style: wbuttonWhiteTextStyle,
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }

    // changePhoneNumber() {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       // return object of type Dialog
    //       return Dialog(
    //         elevation: 0.0,
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0)),
    //         child: Container(
    //           height: 200.0,
    //           padding: EdgeInsets.all(20.0),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //               Text(
    //                 "Change Phone Number",
    //                 style: headingStyle,
    //               ),
    //               SizedBox(
    //                 height: 20.0,
    //               ),
    //               TextField(
    //                 controller: phoneController,
    //                 style: buttonBlackTextStyle,
    //                 keyboardType: TextInputType.number,
    //                 decoration: InputDecoration(
    //                   hintText: 'Enter Phone Number',
    //                   hintStyle: greyHeadingStyle,
    //                 ),
    //               ),
    //               SizedBox(height: 20.0),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: <Widget>[
    //                   InkWell(
    //                     onTap: () {
    //                       Navigator.pop(context);
    //                     },
    //                     child: Container(
    //                       width: (width / 3.5),
    //                       alignment: Alignment.center,
    //                       padding: EdgeInsets.all(10.0),
    //                       decoration: BoxDecoration(
    //                         color: Colors.grey[300],
    //                         borderRadius: BorderRadius.circular(5.0),
    //                       ),
    //                       child: Text(
    //                         'Cancel',
    //                         style: buttonBlackTextStyle,
    //                       ),
    //                     ),
    //                   ),
    //                   InkWell(
    //                     onTap: () {
    //                       setState(() {
    //                         phone = phoneController.text;
    //                         Navigator.pop(context);
    //                       });
    //                     },
    //                     child: Container(
    //                       width: (width / 3.5),
    //                       alignment: Alignment.center,
    //                       padding: EdgeInsets.all(10.0),
    //                       decoration: BoxDecoration(
    //                         color: primaryColor,
    //                         borderRadius: BorderRadius.circular(5.0),
    //                       ),
    //                       child: Text(
    //                         'Okay',
    //                         style: wbuttonWhiteTextStyle,
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }

    // changeEmail() {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       // return object of type Dialog
    //       return Dialog(
    //         elevation: 0.0,
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0)),
    //         child: Container(
    //           height: 200.0,
    //           padding: EdgeInsets.all(20.0),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //               Text(
    //                 "Change Email",
    //                 style: headingStyle,
    //               ),
    //               SizedBox(
    //                 height: 20.0,
    //               ),
    //               TextField(
    //                 controller: emailController,
    //                 style: buttonBlackTextStyle,
    //                 keyboardType: TextInputType.emailAddress,
    //                 decoration: InputDecoration(
    //                   hintText: 'Enter Your Email Address',
    //                   hintStyle: greyHeadingStyle,
    //                 ),
    //               ),
    //               SizedBox(height: 20.0),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: <Widget>[
    //                   InkWell(
    //                     onTap: () {
    //                       Navigator.pop(context);
    //                     },
    //                     child: Container(
    //                       width: (width / 3.5),
    //                       alignment: Alignment.center,
    //                       padding: EdgeInsets.all(10.0),
    //                       decoration: BoxDecoration(
    //                         color: Colors.grey[300],
    //                         borderRadius: BorderRadius.circular(5.0),
    //                       ),
    //                       child: Text(
    //                         'Cancel',
    //                         style: buttonBlackTextStyle,
    //                       ),
    //                     ),
    //                   ),
    //                   InkWell(
    //                     onTap: () {
    //                       setState(() {
    //                         email = emailController.text;
    //                         Navigator.pop(context);
    //                       });
    //                     },
    //                     child: Container(
    //                       width: (width / 3.5),
    //                       alignment: Alignment.center,
    //                       padding: EdgeInsets.all(10.0),
    //                       decoration: BoxDecoration(
    //                         color: primaryColor,
    //                         borderRadius: BorderRadius.circular(5.0),
    //                       ),
    //                       child: Text(
    //                         'Okay',
    //                         style: wbuttonWhiteTextStyle,
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }

    Widget changeVehicle() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButton(
            dropdownColor: Colors.white,
            underline: const SizedBox(),
            value: vehicleType,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: greyColor,
            ),
            items: vehicles.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items, style: greyHeadingStyle),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                vehicleType = newValue!;
              });
            }),
      );
    }

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          InkWell(
            onTap: () async {
              SnackBarWidget.showInfoBar(
                  context, "Creating account in progress...");
              input.address = addressController.text;
              input.phoneNumber = int.parse(widget.phone);
              input.name = nameController.text;
              await getLoc();
              await auth
                  .signUpRequest(input, licenseController.text)
                  .then((value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                      (route) => false))
                  .onError((error, stackTrace) async {
                print(error);
                if (nameController.text.isEmpty ||
                    addressController.text.isEmpty ||
                    phoneController.text.isEmpty ||
                    licenseController.text.isEmpty)
                  SnackBarWidget.showErrorBar(
                      context, "All details are compulsory");
                else {
                  // check location permission
                  await Geolocator.checkPermission().then((value) {
                    if (value.index == 0) {
                      SnackBarWidget.showErrorBar(
                          context, "Location is not enabled");
                    } else
                      SnackBarWidget.showInfoBar(
                          context, "Something went wrong");
                  });
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(fixPadding),
              alignment: Alignment.center,
              child: Text(
                'Save',
                style: blueTextStyle,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Profile Image Start
              InkWell(
                onTap: _selectOptionBottomSheet,
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  margin: EdgeInsets.all(fixPadding * 4.0),
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(width: 2.0, color: whiteColor),
                    image: DecorationImage(
                      image: AssetImage('assets/delivery_boy.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    height: 22.0,
                    width: 22.0,
                    margin: EdgeInsets.all(fixPadding / 2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.0),
                      border: Border.all(
                          width: 1.0, color: whiteColor.withOpacity(0.7)),
                      color: Colors.orange,
                    ),
                    child: Icon(Icons.add, color: whiteColor, size: 15.0),
                  ),
                ),
              ),
              // Profile Image End
              // Full Name Start
              InkWell(
                onTap: changeFullName,
                child: getTile('Full Name', name),
              ),
              // Full Name End
              // Password Start
              // InkWell(
              //   onTap: changePassword,
              //   child: getTile('Password', '******'),
              // ),
              // Password End
              // Phone Start
              InkWell(
                // onTap: changePhoneNumber,
                child: getTile('Phone', widget.phone),
              ),
              InkWell(
                onTap: changeLicense,
                child: getTile('License ID', license),
              ),
              InkWell(
                onTap: changeAddress,
                child: getTile('Address', address),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.07,
                margin: EdgeInsets.only(
                    right: fixPadding,
                    left: fixPadding,
                    bottom: fixPadding * 1.5),
                padding: EdgeInsets.only(
                  right: fixPadding,
                  left: fixPadding,
                  top: fixPadding * 2.0,
                  bottom: fixPadding * 2.0,
                ),
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
                child: changeVehicle(),
              ),
              // Phone End
              // Email Start
              // InkWell(
              //   onTap: changeEmail,
              //   child: getTile('Email', email),
              // ),
              // Email End
            ],
          ),
        ],
      ),
    );
  }

  getTile(String title, String value) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
          right: fixPadding, left: fixPadding, bottom: fixPadding * 1.5),
      padding: EdgeInsets.only(
        right: fixPadding,
        left: fixPadding,
        top: fixPadding * 2.0,
        bottom: fixPadding * 2.0,
      ),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: width - 80.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: (width - 80.0) / 2.4,
                  child: Text(
                    title,
                    style: greyHeadingStyle,
                  ),
                ),
                Container(
                  width: (width - 80.0) / 2.0,
                  child: Text(
                    value,
                    style: headingStyle,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16.0,
            color: Colors.grey.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  // Bottom Sheet for Select Options (Camera or Gallery) Start Here
  void _selectOptionBottomSheet() {
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: whiteColor,
            child: new Wrap(
              children: <Widget>[
                Container(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: width,
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Choose Option',
                            textAlign: TextAlign.center,
                            style: headingStyle,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: width,
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.black.withOpacity(0.7),
                                  size: 18.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Camera',
                                  style: listItemTitleStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: width,
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.photo_album,
                                  color: Colors.black.withOpacity(0.7),
                                  size: 18.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Upload from Gallery',
                                  style: listItemTitleStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
  // Bottom Sheet for Select Options (Camera or Gallery) Ends Here
}
