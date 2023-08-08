import 'package:delivery_boy/model/Input/driverMap.dart';

import '../../model/Input/order.dart';
import '../api_v1.dart';
import '../auth.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../const.dart';

class TripInfo {
  TripInfo();
  AuthService auth = new AuthService();

  // Get "WAITING" trip info
  Future<List<Order>> getTripInfo(token, value) async {
    final response = await ApiV1Service.getRequest(
        '/trips/confirmed/?lat=${value[0]}&long=${value[1]}',
        token: token);
    if ((response.statusCode ?? 400) > 300) {
      return [];
    }
    print(response.data);
    print(response.data['trips']);
    var _order = List.generate(
      response.data['trips'].length,
      (int index) => Order.fromMap(
        response.data['trips'][index],
      ),
    );
    _order = _order.reversed.toList();
    print(_order);
    return _order;
  }

  // Accept Trip
  confirmTrip(token, tripId, List<double> location) async {
    final response = await ApiV1Service.patchRequest(
        '/trips/confirmed/accepttrip/$tripId?lat=${location[0]}&long=${location[1]}',
        token: token);
    if ((response.statusCode ?? 400) > 300) {
      return {};
    }
    print('accept=${response.data}');

    // start socket for very first time to update socket id to database
    IO.Socket socket;
    socket = IO.io(Const.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'query': {'accessToken': '$token', 'role': 'DRIVER'}
    });

    // success
    socket.on('success', (data) {
      print(data);
    });
    return response.data;
  }

  // index 0 = lat, index 1 = long
  decodelocation(location, int index) {
    Map<String, dynamic> loc = location;
    return loc.values.elementAt(index);
  }

  /// ALL TRIPS OF USER
  Future<List<DriverMap>> getAllorders(String token) async {
    List<DriverMap> orderhistory = [];
    await ApiV1Service.getRequest('/trips/info', token: token).then((value) {
      // print(value);
      // print(value.data['trips'][0]['subTrips'][0]['start']['lat']);

      final _order = List.generate(
        value.data['trips'].length,
        (int index) => DriverMap.fromMap(
          value.data['trips'][index],
        ),
      );

      orderhistory = _order.reversed.toList();
      // print(_order[0].driver_lat);
      // print(_order[0].date);
      // print(_order[0].drop_lat);
      // print(_order[0].drop_long);
      // print(_order[0].pickup_lat);
      // print(_order[0].pickup_long);
      // print(_order[0].price);
      // print(_order[0].serviceAreaID);
      // print(_order[0].status);
      // print(_order[0].tripID);
      // print(_order[0].vehicleID);
    }).onError((error, stackTrace) {
      throw "No trips Available";
    });
    return orderhistory;
  }

  // PING Customer that driver arrived at location
  pingCustomer(token, tripId) async {
    final response = await ApiV1Service.patchRequest(
        '/trips/confirmed/$tripId/driveratpickup',
        token: token);
    if ((response.statusCode ?? 400) > 300) {
      return {};
    }
    // print(response.data);
    return response.data;
  }

  // Enter otp to start ride
  startRide(token, tripId, otp) async {
    try {
      final response = await ApiV1Service.patchRequest(
          '/trips/confirmed/$tripId/start',
          token: token,
          data: {'otp': otp});
      if ((response.statusCode ?? 400) > 300) {
        return {};
      }
      // print(response.data);
      return response.data;
    } catch (e) {
      throw "invalid OTP";
    }
  }

  // Finish ride
  Future<bool> finishRide(token, tripId, List<double> location) async {
    // print(token);
    // print(tripId);
    // print(location);
    final response = await ApiV1Service.patchRequest(
        '/trips/confirmed/$tripId/complete/driver?lat=${location[0]}&long=${location[1]}',
        token: token);
    if ((response.statusCode ?? 400) > 300) {
      return false;
    }
    // print(response.data);
    return true;
  }
}
