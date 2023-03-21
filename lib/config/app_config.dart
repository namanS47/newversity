
import 'package:firebase_core/firebase_core.dart';

import 'environment/base_app_config.dart';
import 'environment/prod_app_config.dart';
import 'environment/stage_app_config.dart';

enum Environment { stag, prod }
enum BuildType { release, debug, profile }

class AppConfig {
  // Global Variables
  static String? authToken = "";

  static AppConfig instance = AppConfig(Environment.stag);
  static Environment environment = Environment.stag;
  static bool isDevModeOn = false;
  late BaseAppConfig config;
  static String? sessionQueryParams;

  AppConfig(Environment environment) {
    config = _getConfig(environment);
  }

  static initConfig(Environment environment) {
    instance = AppConfig(environment);
    AppConfig.environment = environment;
  }

  static initAnalytics() {

  }

  static setUserPropertiesForSession(String authToken) {
    AppConfig.authToken = authToken;
  }

  BaseAppConfig _getConfig(Environment environment) {
    switch (environment) {
      case Environment.stag:
        return StageAppConfig();
      case Environment.prod:
        return ProdAppConfig();
      default:
        return StageAppConfig();
    }
  }

  static void setDevMode(bool isDev) {
    AppConfig.isDevModeOn = isDev;
  }

  static initializeFirebase() async {
    await Firebase.initializeApp();

    // if (AppConfig.isDevModeOn) {
    //   firebaseAnalytics.disableAnalytics();
    // } else {
    //   firebaseAnalytics.enableAnalytics();
    // }
  }
}


class EnvironmentValues {
  //Staging
  static const String newversityStagingUrl = "http://192.168.1.11:8080/";
  // static const String newversityStagingUrl = "http://10.154.22.161:8080/";


  // Production
  static const String newversityProductionUrl = "http://192.168.1.11:8080/";
}