import 'package:newversity/config/app_config.dart';
import 'package:newversity/config/environment/base_app_config.dart';

class StageAppConfig extends BaseAppConfig {
  @override
  String get newversityAPIBaseUrl => EnvironmentValues.newversityStagingUrl;

  @override
  String get razorPayKey => EnvironmentValues.stagingRazorPayKey;

}