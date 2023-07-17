import '../config/app_config.dart';
import 'main.dart';

Future main() async {
  AppConfig.initConfig(Environment.prod);
  AppConfig.setDevMode(false);
  defaultMain();
}