import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:markaa/preload.dart';

class Api {
  static Dio _dio = Dio();
  static _dioInit() async {
    if (_dio.interceptors.length > 0) return;
    _dio.interceptors
      ..add(
          CacheInterceptor()); //..add(LogInterceptor(requestHeader: false, responseHeader: false));
  }

  static Future<Map<String, dynamic>> getMethod(
    String url, {
    Map<String, dynamic> data,
    Map<String, dynamic> headers,
    Map<String, dynamic> extra,
  }) async {
    _dioInit();
    String requestUrl = data != null ? _getFullUrl(url, data) : url;
    print(requestUrl);
    final response = await _dio.get(requestUrl,
        options: Options(headers: headers ?? _getHeader(), extra: extra));
    return response.data;
  }

  static Future<Map<String, dynamic>> postMethod(
    String url, {
    Map<String, dynamic> data,
    Map<String, String> headers,
  }) async {
    print(url);
    print(data);
    if (!data.containsKey('lang')) data['lang'] = Preload.language;

    final response = await _dio.post(
      url,
      options: Options(headers: headers ?? _getHeader()),
      data: headers != null ? jsonEncode(data) : data,
    );
    print(response.data);
    return response.data;
  }

  static String _getFullUrl(String url, Map<String, dynamic> params) {
    String fullUrl = url;
    List<String> keys = params.keys.toList();

    if (!params.containsKey('lang')) params['lang'] = Preload.language;

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

class CacheInterceptor extends Interceptor {
  CacheInterceptor();

  final _cache = <Uri, Response>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toLowerCase() != "get") return handler.next(options);
    var response = _cache[options.uri];
    print("options.method ${options.method}");
    if (options.extra['refresh'] == true) {
      print('${options.uri}: force refresh, ignore cache! \n');
      return handler.next(options);
    } else if (response != null) {
      print('cache hit: ${options.uri} \n');
      return handler.resolve(response);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cache[response.requestOptions.uri] = response;
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('onError: $err');
    super.onError(err, handler);
  }
}
