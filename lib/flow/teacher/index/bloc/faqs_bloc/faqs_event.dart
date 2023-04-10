part of 'faqs_bloc.dart';

@immutable
abstract class FaqsEvents {}

class SearchFaqsEvents extends FaqsEvents {
  final String searchedText;
  SearchFaqsEvents({required this.searchedText});
}

class OnFaqExpandEvent extends FaqsEvents {
  final int index;
  OnFaqExpandEvent({required this.index});
}
