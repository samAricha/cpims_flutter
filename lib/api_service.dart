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


  static Future<Map<String, dynamic>> login(String apiUrl, String username, String password) async {
    HttpClient client = HttpClient();
    client.autoUncompress = true;

    final HttpClientRequest request = await client.postUrl(Uri.parse(apiUrl));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");

    final String formData = 'username=$username&password=$password';

    request.write(formData);

    final HttpClientResponse response = await request.close();

    final String content = await response.transform(utf8.decoder).join();
    final Map<String, dynamic> responseData = json.decode(content);

    return responseData;
  }

}