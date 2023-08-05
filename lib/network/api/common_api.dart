import 'package:dio/dio.dart';
import 'package:newversity/flow/initial_route/model/common_details_model.dart';
import 'package:retrofit/http.dart';

import '../../config/app_config.dart';
import '../../flow/model/app_version_config_model.dart';

part 'common_api.g.dart';

@RestApi(baseUrl: EnvironmentValues.newversityStagingUrl)
abstract class CommonApi {
  factory CommonApi(Dio dio, {String? baseUrl}) {
    return _CommonApi(dio,
        baseUrl: baseUrl ?? AppConfig.instance.config.newversityAPIBaseUrl);
  }

  @GET("/getUserType")
  @NoBody()
  Future<String> getUserType(@Header("userId") String userId);

  @POST("/fcmToken")
  Future<void> sendFcmToken(@Body() CommonDetailsModel commonDetailsModel);

  @GET("/app/android/version")
  @NoBody()
  Future<AppVersionConfigModel?> fetchAppVersionDetails();
}
