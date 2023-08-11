import 'package:delivery_boy/constant/constant.dart';

import 'package:flutter/material.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

class QRScreen extends StatefulWidget {
  QRScreen({this.upiID, this.payeeName, this.amount});

  final String? upiID;
  final String? payeeName;
  final int? amount;

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  var myupiDetails;

  @override
  void initState() {
    super.initState();
    myupiDetails = UPIDetails(
        upiID: widget.upiID!,
        payeeName: widget.payeeName!,
        amount: widget.amount!.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios,
              color: Colors.white, size: height / 50),
        ),
        centerTitle: true,
        title: Text(
          'QR Code',
          style: TextStyle(
            color: Colors.white,
            fontSize: height / 40,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 20,
            ),
            UPIPaymentQRCode(
              upiDetails: myupiDetails,
              size: 300,
              embeddedImagePath: 'assets/iconp.png',
              embeddedImageSize: const Size(60, 60),
              upiQRErrorCorrectLevel: UPIQRErrorCorrectLevel.high,
              qrCodeLoader: Center(child: CircularProgressIndicator()),
            ),
            SizedBox(
              height: height / 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Upi id: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: height / 50,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  '${myupiDetails.upiID}',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: height / 50,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
