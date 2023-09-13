import 'package:dio/dio.dart';
import 'package:newversity/flow/student/payment/data/model/payment_argument.dart';

import '../../../../di/di_initializer.dart';
import '../../../../network/api/student_api.dart';
import '../../../../network/webservice/exception.dart';
import 'model/create_order_response_model.dart';
import 'model/phonepe/phone_pe_callback_url_request_model.dart';
import 'model/phonepe/phone_pe_callback_url_response_model.dart';
import 'model/phonepe/phone_pe_transaction_status_response_model.dart';

class PaymentRepository {
  final StudentApi _studentApi = DI.inject<StudentApi>();

  Future<CreateOrderResponseModel?> createPaymentOrder(PaymentArgument paymentArgument) async {
    try {
      return await _studentApi.createPaymentOrder(paymentArgument);
    } on DioException catch (exception){
      throw AppException.forException(exception.response);
    }
  }

  Future<PhonePeCallbackUrlResponseModel?> getPhonePePGUrl(PhonePeCallbackUrlRequestModel request) async {
    try{
      return await _studentApi.getPhonePePGUrl(request);
    } on DioException catch (exception){
      throw AppException.forException(exception.response);
    }
  }

  Future<PhonePeTransactionStatusResponseModel?> getPhonePeTransactionStatus(String merchantTransactionId) async {
    try{
      return await _studentApi.getPhonePeTransactionStatus(merchantTransactionId);
    } on DioException catch (exception){
      throw AppException.forException(exception.response);
    }
  }
}