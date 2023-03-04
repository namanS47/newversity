import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../utils/enums.dart';

part 'common_api.g.dart';

@RestApi(baseUrl: "http://localhost:8080/" "/")
abstract class CommonApi{
  factory CommonApi(Dio dio, {String? baseUrl}) {
    return _CommonApi(
        dio,
        baseUrl: baseUrl ?? "/"
    );
  }

  @GET("/getUserType")
  Future<String> getUserType(
      @Header("userId") String userId
      );
}