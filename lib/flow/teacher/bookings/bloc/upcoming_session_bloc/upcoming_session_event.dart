part of 'upcoming_session_bloc.dart';

@immutable
class UpcomingSessionEvent {}

class OnSelectTimeRangeChipEvent extends UpcomingSessionEvent {
  int index;
  OnSelectTimeRangeChipEvent({required this.index});
}

class OnChangeSortByIndexEvent extends UpcomingSessionEvent {
  int index;
  OnChangeSortByIndexEvent({required this.index});
}

class OnSortByResetButtonClickedEvent extends UpcomingSessionEvent {}

class OnSortByApplyButtonClicked extends UpcomingSessionEvent {}
