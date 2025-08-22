// services/api_service.dart
class ApiService {
  // Splash / config (colors + app version)
  static Future<Map<String, dynamic>> fetchAppConfig() async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      "success": true,
      "colors": {
        "primary": "#FFB300",
        "button": "#0D47A1",
        "background": "#FFF8E1",
        "container": "#FFF3E0",
        "splashBg": "#FFFDE7"
      },
      "appVersion": "1.0.0"
    };
  }

  // Login
  static Future<Map<String, dynamic>> login(String mobileNo) async {
    await Future.delayed(const Duration(seconds: 1));
    if (mobileNo == "0123456789") {
      return {
        "success": true,
        "user": {"id": "u123", "name": "test-user", "email": "testuser@gmail.com"},
        "token": "dummy_token_abc123"
      };
    }
    return {"success": false, "message": "User Not Found"};
  }

  // Signup
  static Future<Map<String, dynamic>> signup(Map<String, dynamic> body) async {
    await Future.delayed(const Duration(seconds: 1));
    // return body as user for now
    return {"success": true, "user": body, "token": "dummy_token_signup"};
  }

  // Locations (cities -> talukas -> districts)
  static Future<Map<String, dynamic>> getLocations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      "cities": [
        {
          "id": "c1",
          "name": "Rajkot",
          "talukas": [
            {
              "id": "t1",
              "name": "Taluka A",
              "districts": [
                {"id": "d1", "name": "Jilla 1"},
                {"id": "d2", "name": "Jilla 2"}
              ]
            },
            {
              "id": "t2",
              "name": "Taluka B",
              "districts": [
                {"id": "d3", "name": "Jilla 3"}
              ]
            }
          ]
        },
        {
          "id": "c2",
          "name": "Ahmedabad",
          "talukas": [
            {
              "id": "t3",
              "name": "Taluka X",
              "districts": [
                {"id": "d4", "name": "Jilla 4"}
              ]
            }
          ]
        }
      ]
    };
  }

  // Dashboard list
  static Future<Map<String, dynamic>> getDashboardList() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      "items": List.generate(
        12,
            (i) => {
          "title": "Category ${i + 1}",
          "subtitle": "Description ${i + 1}",
          "value": (i + 1) * 10
        },
      )
    };
  }

  // App version check
  static Future<Map<String, dynamic>> getAppVersion() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      "version": "1.0.0",
      "forceUpdate": false,
      "updateUrl": "https://play.google.com/store/apps/details?id=your.app.id"
    };
  }
}
