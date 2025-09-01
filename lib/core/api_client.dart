import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = "https://project6.blankserve.in/api/";
  static const String bannerImgBasePath = "https://project6.blankserve.in/starter/uploads/banner/";
  static const String pdfFileBasePath = "https://project6.blankserve.in/starter/uploads/pdfs/";


  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",   // यह ज़रूरी है
      },// यह ज़रूरी है
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }




  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    final uri = Uri.parse(baseUrl + endpoint).replace(queryParameters: params);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data["message"] ?? "API Error");
    }
  }
}
