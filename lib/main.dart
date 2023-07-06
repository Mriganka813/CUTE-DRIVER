import 'package:delivery_boy/constant/constant.dart';
import 'package:delivery_boy/pages/splashScreen.dart';
import 'package:delivery_boy/services/global.dart';
import 'package:delivery_boy/services/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
