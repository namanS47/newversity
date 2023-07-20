import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/student/payment/data/model/payment_argument.dart';
import 'package:newversity/flow/student/payment/data/payment_repository.dart';

import '../../../../storage/preferences.dart';
import '../data/model/create_order_response_model.dart';
import '../data/model/phonepe/phone_pe_callback_url_request_model.dart';
import '../data/model/phonepe/phone_pe_callback_url_response_model.dart';
import '../data/model/phonepe/phone_pe_transaction_status_response_model.dart';

part 'payment_event.dart';

part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository = DI.inject<PaymentRepository>();
  final String studentId = CommonUtils().getLoggedInUser();
  CreateOrderResponseModel? orderResponseDetails;
  late String mobileNumber;
  late String merchantTransactionId;

  PaymentBloc() : super(PaymentInitial()) {
    on<CreatePaymentOrderEvent>((event, emit) async {
      emit(CreatePaymentOrderLoadingState());
      try {
        event.paymentArgument.studentId = studentId;
        final response =
            await _paymentRepository.createPaymentOrder(event.paymentArgument);
        mobileNumber = await DI.inject<Preferences>().getMobileNumber();
        if (response != null) {
          orderResponseDetails = response;
          emit(CreatePaymentOrderSuccessState());
        }
      } catch (exception) {
        emit(CreatePaymentOrderFailureState());
      }
    });

    on<FetchPhonePePGUrlEvent>((event, emit) async {
      emit(FetchPhonePePGUrlLoadingState());
      try {
        mobileNumber = await DI.inject<Preferences>().getMobileNumber();
        merchantTransactionId = getUniqueMerchantId(
          studentId,
          event.paymentArgument.availabilityId,
        );
        final phonePePGUrlRequest = PhonePeCallbackUrlRequestModel(
            amount: event.paymentArgument.amount,
            mobileNumber: mobileNumber,
            merchantUserId: studentId,
            merchantTransactionId: merchantTransactionId);
        final response =
            await _paymentRepository.getPhonePePGUrl(phonePePGUrlRequest);
        if (response != null) {
          emit(FetchPhonePePGUrlSuccessState(
              phonePeCallbackUrlResponseModel: response));
        }

      } catch (exception) {
        emit(FetchPhonePePGUrlFailureState());
      }
    });

    on<FetchPhonePeTransactionStatusEvent>((event, emit) async {
      emit(FetchPhonePeTransactionStatusLoadingState());
      try{
        await fetchPhonePeTransactionStatus(merchantTransactionId, emit);
      } catch (exception) {
        emit(FetchPhonePePGUrlFailureState());
      }
    });
  }

  String getUniqueMerchantId(String userId, String availabilityId) {
    int userIdLength = userId.length;
    int availabilityIdLength = availabilityId.length;
    final timeEpoch = DateTime.now().millisecondsSinceEpoch.toString();
    String uniqueId =
        "${userId.substring(userIdLength - 10)}_${availabilityId.substring(availabilityIdLength - 10)}_$timeEpoch";
    return uniqueId;
  }

  Future<void> fetchPhonePeTransactionStatus(String merchantTransactionId, Emitter<PaymentState> emit) async {
    final response = await _paymentRepository.getPhonePeTransactionStatus(merchantTransactionId);
    if(response?.phonePeTransactionDetailsData?.code == "PAYMENT_SUCCESS") {
      emit(FetchPhonePeTransactionStatusSuccessState(phonePeTransactionStatusResponseModel: response));
      return;
    } else if(response?.phonePeTransactionDetailsData?.code == "PAYMENT_PENDING") {
      while(response?.phonePeTransactionDetailsData?.code == "PAYMENT_PENDING") {
        Future.delayed(const Duration(seconds: 10));
        return fetchPhonePeTransactionStatus(merchantTransactionId, emit);
      }
    } else {
      emit(FetchPhonePeTransactionStatusFailureState());
    }
  }
}
