import 'dart:io';

import 'package:dictator/core.dart';

class ApiService extends GetConnect {
  // static const String url = 'https://api.example.com';

  Future<Response> getData(String endpoint) async {
    try {
      final response = await get('$baseUrl/$endpoint');
      if (response.status.hasError) {
        throw Exception(response.statusText);
      }
      return response;
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Response> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await post('$baseUrl/$endpoint', data);
      if (response.status.hasError) {
        throw Exception(response.statusText);
      }
      return response;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  Future<Uint8List> downloadFile(String endpoint) async {
    try {
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient
          .getUrl(Uri.parse("$endpoint}"));
      HttpClientResponse response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      return bytes;
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }
}
