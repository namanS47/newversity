part of 'campus_bloc.dart';

@immutable
abstract class StudentCampusEvents {}

class ShowCampusEvent extends StudentCampusEvents {}

class FetchUserCommunityTokenEvent extends StudentCampusEvents {}
