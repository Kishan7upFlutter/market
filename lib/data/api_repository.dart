import '../core/api_client.dart';

class ApiRepository {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> fetchUsers() async {
    return await _apiClient.get("users");
  }

  Future<dynamic> sendFcmToken(String fcmToken, String deviceId) async {
    return await _apiClient.post("user/create-user", {
      "fcm_token": fcmToken,
      "device_id": deviceId,
    });
  }

  Future<dynamic> registerUserApi(Map<String, String> formData) async {
   // return {"success": true, "user": formData, "token": "dummy_token_signup"};
    return await _apiClient.post("user/register",formData);
  }

  Future<dynamic> login(String email, String password) async {
    return await _apiClient.post("login", {
      "email": email,
      "password": password,
    });
  }
  Future<dynamic> fetchCategory() async {
    return await _apiClient.get("categories",  params: {
      "page": "1",
      "limit": "10",
      "search": "pan masala",
    },);
  }

  Future<dynamic> fetchNotifications() async {
    return await _apiClient.get("notifications",  params: {
      "status": "true",
      "sortBy": "createdAt",
      "order": "asc",
    },);
  }

  Future<dynamic> fetchBranchListApi() async {
    return await _apiClient.get("branches",  params: {
      "status": "true",
      "sortBy": "createdAt",
      "order": "asc",
    },);
  }

  Future<dynamic> fetchBankList() async {
    return await _apiClient.get("banks",  params: {
      "status": "true",
      "sortBy": "createdAt",
      "order": "asc",
    },);
  }

  Future<dynamic> fetchNewsChannel() async {
    return await _apiClient.get("news-channels",  params: {
      "status": "true",
      "sortBy": "createdAt",
      "order": "asc",
    },);
  }


  Future<dynamic> fetchSamachar() async {
    return await _apiClient.get("samachar",  params: {
      "status": "true",
      "sortBy": "createdAt",
      "order": "asc",
    },);
  }

  Future<dynamic> fetchPdfList() async {
    return await _apiClient.get("pdf",  params: {
      "status": "true",
      "sortBy": "createdAt",
      "order": "asc",
    },);
  }

  Future<dynamic> fetchNumberList() async {
    return await _apiClient.get("numbers",  params: {
      "status": "true",
      "sortBy": "createdAt",
      "order": "asc",
    },);
  }

  Future<dynamic> fetchProductById(String id) async {
    return await _apiClient.get("products",  params: {
      "status": "true",
      "sortBy": "createdAt",
      "order": "asc",
      "categoryId": id
    },);
  }


  Future<dynamic> fetchBanner() async {
    return await _apiClient.get("banners",  params: {
      "status": "true",
      "sortBy": "createdAt",
      "order": "asc",
    },);
  }

  //user/create-user
}
