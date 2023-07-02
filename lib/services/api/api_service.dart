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

  Future<void> downloadFile(String endpoint, String filePath) async {
    try {
      final response = await get('$endpoint');
      if (response.status.hasError) {
        throw Exception(response.statusText);
      }
      final bytes = response.bodyBytes;
      final file = File(filePath);
      await file.writeAsBytes(bytes as List<int>);
      print('File saved successfully.');
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }
}
