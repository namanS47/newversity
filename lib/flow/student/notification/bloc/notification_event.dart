part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class FetchAllUserNotificationsEvent extends NotificationEvent {}
