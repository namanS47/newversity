import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../storage/app_constants.dart';

///Uncomment it if you want to run a process when app is in background or terminated
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background FCM message: ${message.messageId}");
// }

class FirebaseMessagingService {
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
      "high_importance_channel", "High importance notifications",
      description: "This channel is used for important notifications",
      importance: Importance.high,
      playSound: true);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Initialize FCM and configure callbacks
  Future<void> initialize() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _firebaseMessaging.requestPermission();
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen(_onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


    const InitializationSettings initSettings = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/app_icon"),
    );
    
    _flutterLocalNotificationsPlugin.initialize(initSettings, onDidReceiveNotificationResponse: onTapNotification);
  }

  /// when app is in the foreground
  static Future<void> onTapNotification(NotificationResponse? response) async {
    print("onForeground tap FCM message");
  }

  // Callback for handling a received message
  Future<void> _onMessageReceived(RemoteMessage message) async {
    print('on received FCM message: ${message.data}');
    RemoteNotification? remoteNotification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;

    if (remoteNotification != null && androidNotification != null) {
      _flutterLocalNotificationsPlugin.show(
        remoteNotification.hashCode,
        remoteNotification.title,
        remoteNotification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(_channel.id, _channel.name,
              channelDescription: _channel.description,
              importance: _channel.importance,
              playSound: _channel.playSound,
              icon: '@mipmap/app_icon'),
        ),
      );
    }
  }

  // Callback for handling a notification that was clicked when the app was in the background or terminated
  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    // Handle the opened app message according to your requirements
    print('Opened app from FCM message: ${message.data}');
  }
}
