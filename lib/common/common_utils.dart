import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newversity/di/di_initializer.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/storage/preferences.dart';
import 'package:newversity/utils/enums.dart';
import 'package:newversity/utils/string_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;


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

  Future<String> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken() ?? "";
  }

  Future<String> getInitialRoute() async {
    if(!isUserLoggedIn()) {
      return AppRoutes.loginRoute;
    }

    final isStudent =  isUserStudent();
    return AppRoutes.studentHome;
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

  Future<String> getAppVersion() async {
    return await PackageInfo.fromPlatform()
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

  File renameFile(XFile xFile, String id) {
    String dir = path.dirname(xFile.path);
    String fileName = path.basename(xFile.path);
    String newFileName =
        DateTime.now().toString().replaceAll(RegExp('[^A-Za-z0-9]'), "") +
            id +
            fileName.substring(fileName.indexOf('.'));
    String newPath = path.join(dir, newFileName);
    File file = File(xFile.path);
    return file.renameSync(newPath);
  }
}