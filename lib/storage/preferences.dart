import 'dart:convert';

import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/utils/enums.dart';
import 'package:newversity/utils/string_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Preferences {
  static SharedPreferences? sharedPreferences;

  Future<SharedPreferences?> getInstance() async {
    if (sharedPreferences == null) {
      return sharedPreferences = await _getPreferences();
    } else {
      return sharedPreferences;
    }
  }

  Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  dynamic getObjectPreference(String key) async {
    SharedPreferences? preferences = await getInstance();
    final jsonString = preferences!.getString(key);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    return jsonDecode(jsonString);
  }

  Future<void> setObjectPreference(String key, var object) async {
    SharedPreferences? preferences = await getInstance();
    await preferences!.setString(key, jsonEncode(object));
  }

  clear() async {
    return await SharedPreferences.getInstance()
      ..clear();
  }

  resetFlow() async {
    SharedPreferences preferences = await _getPreferences();
    for (String key in preferences.getKeys()) {
      if (!PreferencesKey.persistentKeys.contains(key)) {
        preferences.remove(key);
      }
    }
  }

  Future<TeacherDetailsModel> getTeacherDetails();

  Future<void> setTeacherDetails(TeacherDetailsModel teacherDetails);

  Future<String> getMobileNumber();

  Future<void> setMobileNumber(String mobileNumber);

  Future<UserType?> getUserType();

  Future<void> setUserType(UserType userType);
}

class PreferencesImpl extends Preferences {
  @override
  Future<UserType?> getUserType() async {
    final userType = await getObjectPreference(PreferencesKey.userType);
    if (userType == "teacher") {
      return UserType.teacher;
    }
    if (userType == "student") {
      return UserType.student;
    }
    return null;
  }

  @override
  Future<void> setUserType(UserType userType) {
    return setObjectPreference(
        PreferencesKey.userType, userType.toShortString());
  }

  @override
  Future<TeacherDetailsModel> getTeacherDetails() async {
    return await getObjectPreference(PreferencesKey.teacherDetails);
  }

  @override
  Future<void> setTeacherDetails(TeacherDetailsModel teacherDetails) async {
    return setObjectPreference(PreferencesKey.teacherDetails, teacherDetails);
  }

  @override
  Future<String> getMobileNumber() async {
    return await getObjectPreference(PreferencesKey.mobileNumber);
  }

  @override
  Future<void> setMobileNumber(String mobileNumber) {
    return setObjectPreference(PreferencesKey.mobileNumber, mobileNumber);
  }
}

abstract class PreferencesKey {
  static const String userType = "userType";
  static const String teacherDetails = "teacherDetails";
  static const String mobileNumber = "mobileNumber";

  static List<String> persistentKeys = [];
}
