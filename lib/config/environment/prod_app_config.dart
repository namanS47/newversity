import 'package:newversity/config/environment/base_app_config.dart';

import '../app_config.dart';

class ProdAppConfig extends BaseAppConfig {

  @override
  // TODO: implement razorPayKey
  String get razorPayKey => throw UnimplementedError();

  @override
  // TODO: implement newversityAPIBaseUrl
  String get newversityAPIBaseUrl => throw UnimplementedError();

  @override
  String get termsAndConditionsUrl => EnvironmentValues.termsAndConditionsUrl;

  @override
  String get privacyPolicyUrl => EnvironmentValues.privacyPolicyUrl;

}