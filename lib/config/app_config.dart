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

  static initAnalytics() {}

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

  static const String newversityStagingUrl = "https://api.newversity.in/";
  // static const String newversityStagingUrl = "http://192.168.1.8:8080/";


  static const String stagingRazorPayKey = "rzp_test_C4quaG5XBcUQDb";

  // Production
  static const String newversityProductionUrl =
      "http://newversity-env.eba-w8mvmik7.ap-south-1.elasticbeanstalk.com/";

  static const String termsAndConditionsUrl = "https://termify.io/terms-and-conditions/VFg48qjAGJ";
  static const String privacyPolicyUrl = "https://termify.io/privacy-policy/H8CgMiE5yx";
}
