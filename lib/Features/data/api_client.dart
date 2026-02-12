import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({required this.client, required this.baseUrl,});

  Future<dynamic> get(String path, {Map<String, String>? queryParameters,
      }) async {
    // combine base URL with endpoint and add optional query parameters (page=1)
    final uri = Uri.parse(baseUrl + path).replace(queryParameters: queryParameters);


    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error: ${response.statusCode}");
    }
  }
}

