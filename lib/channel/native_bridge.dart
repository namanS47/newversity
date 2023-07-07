import 'package:flutter/services.dart';
import 'package:newversity/channel/method_argument_keys.dart';

class NativeBridge{
  static const platform = MethodChannel(ChannelNames.flutterModuleModule);

  static void openPhonePePG() {
    platform.invokeMethod(MethodNames.openPhonePePG);
  }
}