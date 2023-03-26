part of 'previous_session_bloc.dart';

@immutable
abstract class PreviousSessionEvents {}

class OnSelectTimeRangeChipEvent extends PreviousSessionEvents {
  int index;
  OnSelectTimeRangeChipEvent({required this.index});
}

class OnChangeSortByIndexEvent extends PreviousSessionEvents {
  int index;
  OnChangeSortByIndexEvent({required this.index});
}

class OnSortByResetButtonClickedEvent extends PreviousSessionEvents {}

class OnSortByApplyButtonClicked extends PreviousSessionEvents {}

