import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';

class CustomInterceptor extends Interceptor {
  late String clientId;
  late String clientSecret;
  CustomInterceptor(this.clientId, this.clientSecret);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // ignore: avoid_print
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    options.headers.addAll({'Authorization': 'Bearer $token'});
    log(token);

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // ignore: avoid_print
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');

    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    // ignore: avoid_print
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');

    return super.onError(err, handler);
  }

  _generateToken() {
    final Map<String, dynamic> headers = {"alg": "HS256", "typ": "JWT"};
    final jwt = JWT(
      {},
      header: headers,
      jwtId: clientId,
    );
    return jwt.sign(SecretKey(clientSecret), algorithm: JWTAlgorithm.HS256);
  }

  String get token => _generateToken();
}
