import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/storage/preferences.dart';
import 'package:newversity/utils/enums.dart';
import 'package:newversity/utils/string_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';


class CommonUtils {
  static final CommonUtils _instance = CommonUtils._internal();

  factory CommonUtils() {
    return _instance;
  }
  CommonUtils._internal();

  String getLoggedInUser() {
    return FirebaseAuth.instance.currentUser?.uid ?? "";
  }

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<String> getAuthToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken() ?? "";
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

  Map<String, String> getQueryParameters(String? url) {
    if (url.isValid) {
      var uri = Uri.parse(url!);
      return uri.queryParameters;
    } else {
      return {};
    }
  }

  Future<String> getAppVersion() {
    return PackageInfo.fromPlatform()
        .then((info) => info.version);
  }

  String getGenderString(Gender gender) {
    switch(gender){
      case Gender.male:
        return "Male";
      case Gender.female:
        return "Female";
      case Gender.other:
        return "Other";
    }
  }
}