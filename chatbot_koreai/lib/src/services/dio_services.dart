
import 'package:dio/dio.dart';

import '../shared/endpoints.dart';
import 'custom_interceptors.dart';

class CustomHttp {
  final Dio client = Dio();
  CustomHttp(String clientId, String clientSecret) {
    client.options.baseUrl = Endpoints.baseUrl;
    client.options.baseUrl = Endpoints.baseUrl;
    client.interceptors.add(CustomInterceptor(clientId, clientSecret));
    client.options.connectTimeout = const Duration(milliseconds: 8000000) ;
  }
}