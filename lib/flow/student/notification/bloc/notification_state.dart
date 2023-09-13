part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class FetchAllUserNotificationLoadingState extends NotificationState {}

class FetchAllUserNotificationSuccessState extends NotificationState {
  FetchAllUserNotificationSuccessState({required this.notificationList,});
  final List<NotificationDetailsResponseModel> notificationList;
}

class FetchAllUserNotificationFailureState extends NotificationState {
  FetchAllUserNotificationFailureState({required this.message});
  final String message;
}
