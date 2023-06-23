import 'package:newversity/config/app_config.dart';
import 'package:newversity/config/environment/base_app_config.dart';

class StageAppConfig extends BaseAppConfig {
  @override
  String get newversityAPIBaseUrl => EnvironmentValues.newversityStagingUrl;

  @override
  String get razorPayKey => EnvironmentValues.stagingRazorPayKey;

  @override
  String get termsAndConditionsUrl => EnvironmentValues.termsAndConditionsUrl;

  @override
  String get privacyPolicyUrl => EnvironmentValues.privacyPolicyUrl;
}