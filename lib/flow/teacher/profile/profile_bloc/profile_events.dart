part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvents {}

class ChangeProfilecardIndex extends ProfileEvents {
  final int index;
  bool isBack;

  ChangeProfilecardIndex(this.index, {this.isBack = false});
}

class FetchTeachersExperience extends ProfileEvents {
  FetchTeachersExperience();
}

class FetchTeachersEducation extends ProfileEvents {
  FetchTeachersEducation();
}
