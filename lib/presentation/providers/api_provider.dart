import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:market/data/api_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider with ChangeNotifier {
  final ApiRepository _repository = ApiRepository();

  bool isLoading = false;
  dynamic users;
  List<dynamic> categories = [];

  List<dynamic> notifications = [];
  List<dynamic> newsChannelList = [];
  List<dynamic> samcharList = [];
  List<dynamic> branchList = [];
  List<dynamic> bankList = [];
  List<dynamic> productList = [];
  List<dynamic> pdfList = [];
  List<dynamic> numberList = [];
  List<dynamic> bannerList = [];


  dynamic categoriesResponse;
  dynamic notificationResponse;
  dynamic newsChannelResponse;
  dynamic samacharResponse;
  dynamic branchResponse;
  dynamic productResponse;
  dynamic pdfResponse;
  dynamic numberResponse;
  dynamic bannerResponse;

  dynamic bankResponse;

  dynamic loginResponse;
  String? error;









  /// ✅ Get FCM Token
  static Future<String?> getFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(); // iOS के लिए permission

    String? token = await messaging.getToken();

    return token;
  }

  /// ✅ Get Device ID
  static Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // unique Android ID
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // unique iOS ID
    }
    return null;
  }


  Future<void> registerDevice() async {
    isLoading = true;
    notifyListeners();
    try {
      final fcmToken = await getFcmToken();
      final deviceId = await getDeviceId();
      print("FCMToken" + " Token : " + fcmToken.toString() + " Device-ID : " +  deviceId.toString());
      final response = await _repository.sendFcmToken(
        fcmToken.toString(),
        deviceId.toString(),
      );
      print("Response: $response");
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> registerUser(Map<String, String> formData,{bool enableBiometric = false}) async {
    isLoading = true;
    notifyListeners();

    try {
      final fcmToken = await getFcmToken();
      final deviceId = await getDeviceId();
      formData.addAll(
          {
            "fcm_token":fcmToken.toString(),
            "device_id":deviceId.toString()
          }
      );
      print("RequestPARAMREGISTER" + formData.toString());
      final res = await _repository.registerUserApi(formData);

      if (res['success'] == true) {
        Map<String, dynamic>? _user = Map<String, dynamic>.from(
            res['user'] ?? {});
        final tok = _user['fcm_token']?.toString() ?? 'dummy_token';
        // _user = Map<String, dynamic>.from(res['user'] ?? {});
        //final tok =  'dummy_token_signup';
        print("TokenResponse" + tok.toString());

        print("TOKFGKFGKFG" + res['message']!.toString());
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("token", tok.toString());

        notifyListeners();
        return true;
      }
      else
        {
          error = res['message']?.toString() ?? 'Signup failed';
          notifyListeners();
          return false;
        }

    } catch (e) {
      error = e.toString();

    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> getUsers() async {
    isLoading = true;
    notifyListeners();
    try {
      users = await _repository.fetchUsers();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getCategories() async {
    isLoading = true;

    try {
      categoriesResponse = await _repository.fetchCategory();

      if (categoriesResponse != null && categoriesResponse["success"] == true) {
        categories = categoriesResponse["categories"];
      } else {
        error = "Failed to load categories";
      }
    } catch (e) {
      error = e.toString();
      print("Error" + error.toString());
    }
    isLoading = false;

  }

  Future<void> getNotifications() async {
    isLoading = true;

    try {
      notificationResponse = await _repository.fetchNotifications();

      if (notificationResponse != null && notificationResponse["success"] == true) {
        notifications = notificationResponse["notifications"];
      } else {
        error = "Failed to load categories";
      }
    } catch (e) {
      error = e.toString();
      print("Error" + error.toString());
    }
    isLoading = false;
  }

  Future<void> getBranchList() async {
    isLoading = true;
    try {
      branchResponse = await _repository.fetchBranchListApi();
      if (branchResponse != null && branchResponse["success"] == true) {
        branchList = branchResponse["branches"];
      } else {
        error = "Failed to load categories";
      }
    } catch (e) {
      error = e.toString();
      print("Error" + error.toString());
    }
    isLoading = false;
  }

  Future<void> getBankList() async {
    isLoading = true;
    try {
      bankResponse = await _repository.fetchBankList();
      if (bankResponse != null && bankResponse["success"] == true) {
        bankList = bankResponse["banks"];
      } else {
        error = "Failed to load categories";
      }
    } catch (e) {
      error = e.toString();
      print("Error" + error.toString());
    }
    isLoading = false;
  }

  Future<void> getNewsChannel() async {
    isLoading = true;

    try {
      newsChannelResponse = await _repository.fetchNewsChannel();

      if (newsChannelResponse != null && newsChannelResponse["success"] == true) {
        newsChannelList = newsChannelResponse["newsChannel"];
      } else {
        error = "Failed to load categories";
      }
    } catch (e) {
      error = e.toString();
      print("Error" + error.toString());
    }
    isLoading = false;
  }

  Future<void> getSamachar() async {
    isLoading = true;

    try {
      samacharResponse = await _repository.fetchSamachar();

      if (samacharResponse != null && samacharResponse["success"] == true) {
        samcharList = samacharResponse["samachar"];
      } else {
        error = "Failed to load categories";
      }
    } catch (e) {
      error = e.toString();
      print("Error" + error.toString());
    }
    isLoading = false;
  }


  Future<void> getPdfList() async {
    isLoading = true;

    try {
      pdfResponse = await _repository.fetchPdfList();

      if (pdfResponse != null && pdfResponse["success"] == true) {
        pdfList = pdfResponse["pdfs"];
      } else {
        error = "Failed to load categories";
      }
    } catch (e) {
      error = e.toString();
      print("Error" + error.toString());
    }
    isLoading = false;
  }

  Future<void> getNumberList() async {
    isLoading = true;

    try {
      numberResponse = await _repository.fetchNumberList();

      if (numberResponse != null && numberResponse["success"] == true) {
        numberList = numberResponse["numbers"];
      } else {
        error = "Failed to load categories";
      }
    } catch (e) {
      error = e.toString();
      print("Error" + error.toString());
    }
    isLoading = false;
  }



  Future<void> getBannerList() async {
    isLoading = true;

    try {
      bannerResponse = await _repository.fetchBanner();

      if (bannerResponse != null && bannerResponse["success"] == true) {
        bannerList = bannerResponse["banners"];
      } else {
        error = "Failed to load categories";
      }
    } catch (e) {
      error = e.toString();
      print("Error" + error.toString());
    }
    isLoading = false;
  }



  Future<void> getProduct(String id) async {
    isLoading = true;

    try {
      productResponse = await _repository.fetchProductById(id);

      if (productResponse != null && productResponse["success"] == true) {
        productList = productResponse["products"];
        isLoading = false;

        print("dfdsfd" + productList.toString());
      } else {
        error = "Failed to load categories";
      }
    } catch (e) {
      error = e.toString();
      print("Error" + error.toString());
    }
    isLoading = false;
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      loginResponse = await _repository.login(email, password);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
