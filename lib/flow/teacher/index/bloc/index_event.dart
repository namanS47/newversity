part  of 'index_bloc.dart';

@immutable
abstract class IndexEvents {}

class IndexPageUpdateEvent extends IndexEvents {
  int index;
  IndexPageUpdateEvent({required this.index});
}

class FetchTeacherProfileCompletenessPercentageEvent extends IndexEvents {

}

class FetchStudentProfileCompletenessPercentageEvent extends IndexEvents {}

