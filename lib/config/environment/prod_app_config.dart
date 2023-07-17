import 'package:newversity/config/environment/base_app_config.dart';

import '../app_config.dart';

class ProdAppConfig extends BaseAppConfig {

  @override
  // TODO: implement razorPayKey
  String get razorPayKey => throw UnimplementedError();

  @override
  String get newversityAPIBaseUrl => EnvironmentValues.newversityProductionUrl;

  @override
  String get termsAndConditionsUrl => EnvironmentValues.termsAndConditionsUrl;

  @override
  String get privacyPolicyUrl => EnvironmentValues.privacyPolicyUrl;

}