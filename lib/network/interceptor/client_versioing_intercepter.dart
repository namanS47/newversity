import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newversity/common/common_utils.dart';
import '../../config/app_config.dart';

class ClientVersioningInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    String appVersion =  await CommonUtils().getAppVersion();

    options.headers["platform"] = Platform.operatingSystem;
    options.headers["app_version"] = appVersion;

    options.queryParameters.addAll({
      "platform": Platform.operatingSystem,
      "app_version": appVersion,
    });

    // adding session query parameters =
    var sessionQueryMap = CommonUtils().getQueryParameters(AppConfig.sessionQueryParams);
    options.queryParameters.addAll(sessionQueryMap);

    log("method: ${options.method} uri: ${options.uri} \n body: ${options.data.toString()} \n headers: ${options.headers}");

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    log("uri: ${response.realUri} \n data: ${response.data.toString()} \n statusCode ${response.statusCode}");
  }
}
