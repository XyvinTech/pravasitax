import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getFcmToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for iOS devices (optional)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // Fetch the FCM token
    String? token = await messaging.getToken();
    print("FCM Token: $token");
    return token!;
  } else {
    print('User declined or has not accepted permission');
    return '';
  }
}
