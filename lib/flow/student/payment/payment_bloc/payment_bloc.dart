import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/student/payment/data/model/payment_argument.dart';
import 'package:newversity/flow/student/payment/data/payment_repository.dart';

import '../../../../storage/preferences.dart';
import '../data/model/create_order_response_model.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository = DI.inject<PaymentRepository>();
  final String studentId = CommonUtils().getLoggedInUser();
  CreateOrderResponseModel? orderResponseDetails;
  late String mobileNumber;

  PaymentBloc() : super(PaymentInitial()) {
    on<CreatePaymentOrderEvent>((event, emit) async {
      emit(CreatePaymentOrderLoadingState());
      try{
        event.paymentArgument.studentId = studentId;
        final response = await _paymentRepository.createPaymentOrder(event.paymentArgument);
        mobileNumber = await DI.inject<Preferences>().getMobileNumber();
        if(response != null) {
          orderResponseDetails = response;
          emit(CreatePaymentOrderSuccessState());
        }
      } catch(exception) {
        emit(CreatePaymentOrderFailureState());
      }
    });

  }
}
