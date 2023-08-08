import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Input/signupinput.dart';

import '../model/Input/user.dart' as uusr;
import 'api_v1.dart';
import 'const.dart';
// import 'package:shopos/src/models/input/sign_up_input.dart';
// import 'package:shopos/src/models/user.dart';

class AuthService {
  const AuthService();

  ///
  /// Send verification code
  Future<bool> sendVerificationCode(String phoneNumber) async {
    final response = await ApiV1Service.postRequest('/api/v1/sendOtp');
    if ((response.statusCode ?? 400) < 300) {
      return true;
    }
    return false;
  }

  /// Send login request
  Future<SignUpInput?> signUpRequest(SignUpInput input, String license) async {
    print(input.toMap());
    final prefs = await SharedPreferences.getInstance();

    double lat = prefs.getDouble('lat')!;
    double lng = prefs.getDouble('lng')!;

    final response = await ApiV1Service.postRequest(
      '/auth/signup',
      data: input.toMap(),
    );

    if ((response.statusCode ?? 400) > 300) {
      return null;
    }
    // // print(response.statusCode);
    print(response.toString());
    String userId = response.data['user_id'];

    print(lat);
    print(lng);
    print(userId);
    try {
      await ApiV1Service.postRequest(
        '/auth/signup/verify?lat=$lat&long=$lng',
        data: {"user_id": userId, "otp": "nhi2oo", "licenseNum": license},
      );
    } catch (e) {
      print(e);
      print("error in verification");
    }

    await signInRequest(input.phoneNumber!);
    // await saveCookie(response);
    return SignUpInput.fromMap(response.data);
  }

  /// Save cookies after sign in/up
  // Future<void> saveCookie(Response response) async {
  //   List<Cookie> cookies = [Cookie("token", response.data['token'])];
  //   final cj = await ApiV1Service.getCookieJar();
  //   await cj.saveFromResponse(Uri.parse(Const.apiUrl), cookies);
  // }

  ///
  Future<void> signOut() async {
    // await clearCookies();
    await SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });
    await fb.FirebaseAuth.instance.signOut();
  }

  /// Clear cookies before log out
  // Future<void> clearCookies() async {
  //   final cj = await ApiV1Service.getCookieJar();
  //   await cj.deleteAll();
  // }

  /// Send sign in request
  ///
  Future<uusr.UserModel?> signInRequest(int phoneNum) async {
    final prefs = await SharedPreferences.getInstance();

    final response = await ApiV1Service.postRequest(
      '/auth/login',
      data: {
        'phoneNum': phoneNum,
        'password': "qwertyuiop",
      },
    );
    if ((response.statusCode ?? 400) > 300) {
      return null;
    }
    var token = response.data['tokens'];
    final String accessToken = token['access'];
    final driverId = response.data['user']['_id'];
    print(accessToken);
    print(driverId);
    final String refresh_token = token['refresh'];
    await prefs.setString('access_token', accessToken);
    await prefs.setString('driverId', driverId);
    await prefs.setString('refresh_token', refresh_token);
    print("toekn saved succesfully");
    return null;
    // return uusr.UserModel.fromJson(response.data);
  }

  /// get token from server
  Future<uusr.UserModel> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? "";
    uusr.UserModel usr = uusr.UserModel();
    try {
      await ApiV1Service.getRequest('/auth', token: accessToken).then((value) {
        print(value.data);
        usr = uusr.UserModel.fromJson(value.data);
        return uusr.UserModel.fromJson(value.data);
      });
    } catch (e) {
      print("token expired");
      await getNewToken();
    }

    // .catchError((e) async {
    //   print("token expired");
    //   getNewToken();
    // });
    return usr;
  }

  /// get new token from server
  getNewToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String refresh_token = prefs.getString('refresh_token') ?? "";
    final response =
        await ApiV1Service.getRequest('/auth/newtoken', token: refresh_token);
    if ((response.statusCode ?? 400) > 300) {
      return null;
    }

    final String access_token = response.data['token'];
    await prefs.setString('access_token', access_token);
    prefs.reload();
    getUser();
  }

  ///password change request
  ///
  Future<bool> PasswordChangeRequest(
      String oldPassword, String newPassword, String confirmPassword) async {
    final response = await ApiV1Service.putRequest(
      '/password/update',
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
    if ((response.statusCode ?? 400) > 300) {
      return false;
    }
    return true;
  }

  ///password change request
  ///
  Future<bool> ForgotPasswordChangeRequest(
      String newPassword, String confirmPassword, String phoneNumber) async {
    // print(newPassword + " " + confirmPassword + " " + phoneNumber);
    final response = await ApiV1Service.putRequest(
      '/password/reset',
      data: {
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
        'phoneNumber': phoneNumber,
      },
    );
    if ((response.statusCode ?? 400) > 300) {
      return false;
    }
    return true;
  }
}
