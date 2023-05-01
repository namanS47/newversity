part of 'my_session_bloc.dart';

@immutable
abstract class MySessionEvents {}

class ChangeMySessionTabEvent extends MySessionEvents {
  final int index;
  ChangeMySessionTabEvent({required this.index});
}
