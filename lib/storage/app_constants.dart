import 'package:firebase_messaging/firebase_messaging.dart';

class AppConstants {
  static int imageUploadQuality = 50;
  static int documentUploadQuality = 50;
}

///Global variables

//This is notification message when tap on notification in terminated state
class GlobalConstants {
  static RemoteMessage? initialMessage;
  static bool isCheckedForAppUpdate = false;
}