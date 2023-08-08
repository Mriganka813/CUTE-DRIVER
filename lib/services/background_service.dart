import 'dart:async';
import 'dart:ui';

import 'package:delivery_boy/services/auth.dart';
import 'package:delivery_boy/services/page_services/trip_info.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Input/order.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
        onStart: onStart, isForegroundMode: true, autoStart: true),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsBackgroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: 'Cute Partner', content: 'Tap to view more');
      }
    }
    AuthService authService = AuthService();
    List<double> value = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    Timer.periodic(Duration(minutes: 20), (timer) async {
      await authService.getNewToken();
    });

    double lat = prefs.getDouble('lat')!;
    double long = prefs.getDouble('lng')!;
    String driverId = prefs.getString('driverId') ?? '';
    value.add(lat);
    value.add(long);

    final TripInfo tripInfo = TripInfo();
    List<Order> response = await tripInfo.getTripInfo(
      token,
      value,
    );

    int count = 0;

    // print(response[0].silent);
    for (int i = 0; i < response.length; i++) {
      if (!(response[i].silent!.contains(driverId))) {
        count++;
      }
    }

    if (count > 0) {
      await showNotification();
    }

    print(response);
    print('background service running');
  });
}

Future<void> showNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id', // Replace with your channel ID
    'your_channel_name', // Replace with your channel name

    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    sound: RawResourceAndroidNotificationSound('ring_ring'),
  );

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID (optional)
    'Cute Partner', // Notification title
    'you have new orders', // Notification body
    platformChannelSpecifics,

    payload: 'Custom_Payload', // Custom payload (optional)
  );
}
