import 'package:delivery_boy/constant/constant.dart';
import 'package:delivery_boy/pages/splashScreen.dart';
import 'package:delivery_boy/services/global.dart';
import 'package:delivery_boy/services/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      // Specify the initialization settings for Android and iOS
      android: AndroidInitializationSettings(
          '@mipmap/launcher_icon'), // Replace with your app's launcher icon
    ),
    onDidReceiveNotificationResponse: (details) {
      print(details.payload);
      print(details.notificationResponseType.name);
    },
  );

  locator.registerLazySingleton(() => GlobalServices());
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cute Partner',
      theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: Colors.transparent,

              // Status bar brightness (optional)
              statusBarIconBrightness:
                  Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
          )),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
