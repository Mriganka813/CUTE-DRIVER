import 'package:shared_preferences/shared_preferences.dart';

import 'api_v1.dart';
import 'package:http/http.dart' as http;

class StatusChangeService {
  statusChange(String orderId, String status) async {
    final response = await http.get(
      Uri.parse('http://65.0.7.20:8001/api/v1/update/order/$orderId/$status'),
    );

    print(response.body);
  }
}
