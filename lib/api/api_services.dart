import 'package:http/http.dart';

class ApiService {
  static const String baseUrl = "https://backend-api.emtrade.link";

  static Future<Response> getContents(int page, int pagesize, String sort, String search, String category, String contentFormat) async {
    String categoryString = "";
    if(category != ""){
      categoryString = ",category_name:$category";
    }
    String contentString = "";
    if(contentFormat != ""){
      contentString = ",content_format:$contentFormat";
    }

    String url = "$baseUrl/content/public/v1/post?page=$page&size=$pagesize&sort=$sort&query=search:$search$categoryString$contentString";
    print("=== url ===");
    print(url);
    Response response = await get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json'
      },
    );
    return response;
  }
}