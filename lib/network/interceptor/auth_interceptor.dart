import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:newversity/common/common_utils.dart';

import '../../config/app_config.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers["Authorization"] = await CommonUtils().getAuthToken();
    log("Auth token: ${options.headers["Authorization"]}");

    //TODO: get auth token from appconfig
    if (AppConfig.authToken?.isNotEmpty == true) {
      options.headers["Authorization"] = AppConfig.authToken;
    }
    return handler.next(options);
  }
}
