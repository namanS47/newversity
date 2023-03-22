
part of 'profile_bloc.dart';

@immutable
abstract class ProfileStates {
}

class ProfileInitial extends ProfileStates{}

class ProfileLoading extends ProfileStates {}

class ProfileCardChangedState extends ProfileStates{}