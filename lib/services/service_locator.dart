


import 'package:get_it/get_it.dart';

import 'call_message_service.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton(CallsAndMessagesService());
}