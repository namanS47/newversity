part of 'index_bloc.dart';

@immutable
abstract class IndexState {}

class IndexInitialState extends IndexState {}

class PageUpdatedState extends IndexState {}

class FetchingProfileCompletionInfoState extends IndexState {}

class FetchedProfileCompletionInfoState extends IndexState {
  final ProfileCompletionPercentageResponse? profileCompletionPercentageResponse;
  FetchedProfileCompletionInfoState(
      {required this.profileCompletionPercentageResponse});
}

class FetchingProfileCompletionInfoFailureState extends IndexState {
  final String msg;
  FetchingProfileCompletionInfoFailureState({required this.msg});
}
