import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  static Future<Map<String, dynamic>> getMethod(
    String url, {
    Map<String, dynamic> data,
    Map<String, dynamic> headers,
  }) async {
    String requestUrl = data != null ? _getFullUrl(url, data) : url;
    final response = await http.get(
      Uri.parse(requestUrl),
      headers: headers ?? _getHeader(),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> postMethod(
    String url, {
    Map<String, dynamic> data,
    Map<String, String> headers,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: headers ?? _getHeader(),
      body: headers != null ? jsonEncode(data) : data,
    );
    return jsonDecode(response.body);
  }

  static String _getFullUrl(String url, Map<String, dynamic> params) {
    String fullUrl = url;
    List<String> keys = params.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      if (i == 0) {
        fullUrl += '?$key=${params[key]}';
      } else {
        fullUrl += '&$key=${params[key]}';
      }
    }
    return fullUrl;
  }

  static Map<String, String> _getHeader() {
    return {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': '*/*',
    };
  }
}
