import 'dart:convert';
import 'dart:io';

class ApiService {
  static Future<List> fetchPhotos(String apiUrl) async {
    HttpClient client = HttpClient();
    client.autoUncompress = true;

    final HttpClientRequest request =
    await client.getUrl(Uri.parse(apiUrl));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    final HttpClientResponse response = await request.close();

    final String content = await response.transform(utf8.decoder).join();
    final List data = json.decode(content);

    return data;
  }


  static Future<String> login(String apiUrl, String username, String password) async {
    HttpClient client = HttpClient();
    client.autoUncompress = true;

    final HttpClientRequest request = await client.postUrl(Uri.parse("https://dev.cpims.net/api/token/"));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");

    final Map<String, dynamic> requestData = {
      'username': "testhealthit",
      'password': "T3st@987654321",
    };

    final String jsonData = json.encode(requestData);

    request.headers.set(HttpHeaders.contentLengthHeader, jsonData.length);
    request.write(jsonData);

    final HttpClientResponse response = await request.close();

    final String content = await response.transform(utf8.decoder).join();
    // print(content);
    final Map<String, dynamic> responseData = json.decode(content);
    final String access = responseData['access'];

    return access;
  }



  static Future<Map<String, dynamic>> fetchDashboardData(String apiUrl, String token) async {
    HttpClient client = HttpClient();
    client.autoUncompress = true;

    final HttpClientRequest request = await client.getUrl(Uri.parse(apiUrl));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    request.headers.add(HttpHeaders.authorizationHeader, 'Bearer $token');

    final HttpClientResponse response = await request.close();

    final String content = await response.transform(utf8.decoder).join();
    final Map<String, dynamic> responseData = json.decode(content);

    return responseData;
  }


}