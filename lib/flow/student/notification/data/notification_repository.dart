import 'package:dio/dio.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/network/api/common_api.dart';
import 'package:newversity/network/webservice/base_repository.dart';

import '../../../../network/webservice/exception.dart';
import 'model/notification_details_response_model.dart';

class NotificationRepository extends BaseRepository {
  final _commonApi = DI.inject<CommonApi>();

  Future<List<NotificationDetailsResponseModel>?>? fetchAllNotificationList(String userId) async {
    try{
      return await _commonApi.fetchAllNotificationList(userId);
    } on DioException catch (exception){
      throw AppException.forException(exception.response);
    }
  }
}