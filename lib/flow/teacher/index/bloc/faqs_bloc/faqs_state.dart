part of 'faqs_bloc.dart';

@immutable
abstract class FaqsStates {}

class FaqsInitialState extends FaqsStates{}

class SearchingFaqsState extends FaqsStates {}

class SearchedFaqsState extends FaqsStates {}

class SearchingFaqsFailureState extends FaqsStates {}

class ExpandedFaqsState extends FaqsStates {}
