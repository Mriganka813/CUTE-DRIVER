import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:delivery_boy/constant/constant.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final notificationList = [
    {
      'title': 'Order Completed!',
      'description': 'Hurrey! You have successfully delivered order!'
    },
    {
      'title': 'You Payout Approved!',
      'description': 'Congratulation! Your payout has been approved!'
    },
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
        title: Text('Notifications', style: bigHeadingStyle),
      ),
      body: Center(
          child: Text(
        "Comming Soon",
        style: TextStyle(fontSize: 20),
      )),
    );
    //   body: (notificationList.length == 0)
    //       ? Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //               Icon(
    //                 FontAwesomeIcons.bellSlash,
    //                 color: Colors.grey,
    //                 size: 60.0,
    //               ),
    //               SizedBox(
    //                 height: 20.0,
    //               ),
    //               Text(
    //                 'No Notifications',
    //                 style: greyHeadingStyle,
    //               )
    //             ],
    //           ),
    //         )
    //       : ListView.builder(
    //           physics: BouncingScrollPhysics(),
    //           itemCount: notificationList.length,
    //           itemBuilder: (context, index) {
    //             final item = notificationList[index];
    //             return Dismissible(
    //               key: Key('$item'),
    //               onDismissed: (direction) {
    //                 setState(() {
    //                   notificationList.removeAt(index);
    //                 });

    //                 // Then show a snackbar.
    //                 ScaffoldMessenger.of(context).showSnackBar(
    //                     SnackBar(content: Text("${item['title']} dismissed")));
    //               },
    //               // Show a red background as the item is swiped away.
    //               background: Container(color: Colors.red),
    //               child: Center(
    //                 child: Container(
    //                   width: width - 20.0,
    //                   margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
    //                   child: Card(
    //                     elevation: 2.0,
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       children: <Widget>[
    //                         Container(
    //                           alignment: Alignment.topLeft,
    //                           padding: EdgeInsets.all(10.0),
    //                           child: CircleAvatar(
    //                             child: Icon(
    //                               FontAwesomeIcons.bell,
    //                               size: 30.0,
    //                             ),
    //                             radius: 40.0,
    //                           ),
    //                         ),
    //                         Container(
    //                           width: width - 130.0,
    //                           child: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: <Widget>[
    //                               Padding(
    //                                 padding: EdgeInsets.only(
    //                                     top: 8.0, right: 8.0, left: 8.0),
    //                                 child: Text(
    //                                   '${item['title']}',
    //                                   style: headingStyle,
    //                                 ),
    //                               ),
    //                               Padding(
    //                                 padding: EdgeInsets.all(8.0),
    //                                 child: Text(
    //                                   '${item['description']}',
    //                                   style: lightGreyStyle,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    // );
  }
}
