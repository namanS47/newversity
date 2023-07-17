import 'package:newversity/config/app_config.dart';
import 'package:newversity/main/main.dart';

Future main() async {
  AppConfig.initConfig(Environment.stag);
  AppConfig.setDevMode(true);
  defaultMain();
}