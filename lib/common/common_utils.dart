import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/storage/preferences.dart';
import 'package:newversity/utils/enums.dart';


class CommonUtils {
  static final CommonUtils _instance = CommonUtils._internal();

  factory CommonUtils() {
    return _instance;
  }
  CommonUtils._internal();

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<String> getInitialRoute() async {
    if(!isUserLoggedIn()) {
      return AppRoutes.loginRoute;
    }

    final isStudent =  isUserStudent();
    return AppRoutes.homeScreen;
  }

  Future<bool> isUserStudent() async {
    return await DI.inject<Preferences>().getUserType() == UserType.student;
  }

  Future<bool> isUserTeacher() async {
    return await DI.inject<Preferences>().getUserType() == UserType.teacher;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}