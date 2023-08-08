import 'package:delivery_boy/services/global.dart';

import 'api_v1.dart';

class NotificationService {
  getSilentTrips(String tripId, String token) async {
    final response = await ApiV1Service.getRequest(
        '/trips/confirmed/silent/$tripId',
        token: token);
    if ((response.statusCode ?? 400) > 300) {
      return [];
    }
    print(response.data);
    if (response.data['success'] == false) {
      GlobalServices()
          .showSnackBar(message: 'trip id has already added', time: 2);
    }
  }
}
