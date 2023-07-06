
import 'package:dio/dio.dart';

import 'global.dart';
import 'locator.dart';

class CustomInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print(err.message);
    print("object");
    final errorMessage = err.response?.data is List
        ? err.response?.data['message']
        : err.message;
    const message = "Something went wrong";
    locator<GlobalServices>().errorSnackBar(errorMessage ?? message);
    return super.onError(err, handler);
  }
}
