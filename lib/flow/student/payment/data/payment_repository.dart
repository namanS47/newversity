import 'package:dio/dio.dart';
import 'package:newversity/flow/student/payment/data/model/payment_argument.dart';

import '../../../../di/di_initializer.dart';
import '../../../../network/api/student_api.dart';
import '../../../../network/webservice/exception.dart';
import 'model/create_order_response_model.dart';

class PaymentRepository {
  final StudentApi _studentApi = DI.inject<StudentApi>();

  Future<CreateOrderResponseModel?> createPaymentOrder(PaymentArgument paymentArgument) async {
    try {
      return await _studentApi.createPaymentOrder(paymentArgument);
    } on DioError catch (exception){
      throw AppException.forException(exception.response);
    }
  }
}