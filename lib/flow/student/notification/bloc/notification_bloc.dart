import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newversity/common/common_utils.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/flow/student/notification/data/notification_repository.dart';

import '../data/model/notification_details_response_model.dart';


part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final _notificationRepository = DI.inject<NotificationRepository>();

  NotificationBloc() : super(NotificationInitial()) {
    on<FetchAllUserNotificationsEvent>((event, emit) async {
      emit(FetchAllUserNotificationLoadingState());
      try{
        final response = await _notificationRepository.fetchAllNotificationList(CommonUtils().getLoggedInUser());
        if(response != null) {
          emit(FetchAllUserNotificationSuccessState(notificationList: response));
        } else {
          emit(FetchAllUserNotificationFailureState(message: "Something went wrong"));
        }
      } catch (exception) {
        emit(FetchAllUserNotificationFailureState(message: "Something went wrong"));
      }
    });
  }
}
