import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
      "high_importance_channel", "High importance notifications",
      description: "This channel is used for important notifications",
      importance: Importance.high,
      playSound: true);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize FCM and configure callbacks
  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen(_onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  // Callback for handling a received message
  Future<void> _onMessageReceived(RemoteMessage message) async {
    RemoteNotification? remoteNotification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;

    if (remoteNotification != null && androidNotification != null) {
      _flutterLocalNotificationsPlugin.show(
        remoteNotification.hashCode,
        remoteNotification.title,
        remoteNotification.body,
        NotificationDetails(
            android:AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              importance: _channel.importance,
              playSound: _channel.playSound,
              icon: '@mipmap/app_icon'
            )
        ));
    }
  }

  // Callback for handling a notification that was clicked when the app was in the background or terminated
  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    // Handle the opened app message according to your requirements
    print('Opened app from FCM message: ${message.data}');
  }
}
