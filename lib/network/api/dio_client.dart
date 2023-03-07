import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../interceptor/auth_interceptor.dart';
import '../interceptor/client_versioing_intercepter.dart';

class DioClient {
  static Dio getDio() {
    Dio dio = Dio();
    dio.interceptors.add(ClientVersioningInterceptor());
    dio.interceptors.add(AuthInterceptor());

    // if (AppConfig.isDevModeOn) {
    //   dio.interceptors.add(PrettyDioLogger(requestBody: true, requestHeader: true));
    // }
    return dio;
  }
}