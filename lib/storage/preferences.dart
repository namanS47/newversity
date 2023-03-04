import 'dart:convert';

import 'package:newversity/utils/enums.dart';
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

  Future<UserType?> getUserType();

  Future<void> setUserType(UserType userType);

}

class PreferencesImpl extends Preferences {
  @override
  Future<UserType?> getUserType() async {
    return await getObjectPreference(PreferencesKey.userType);
    // if(userType != null) {
    //   return userType as UserType;
    // }
    // return userType as UserType?;
  }

  @override
  Future<void> setUserType(UserType userType) {
    return setObjectPreference(PreferencesKey.userType, userType);
  }
}

abstract class PreferencesKey {
  static const String userType = "userType";
}