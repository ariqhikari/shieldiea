import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shieldiea/app/routes/app_pages.dart';
import 'package:shieldiea/app/shared/shared.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notification',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    print("message: ${message?.data.toString()}");
    if (message == null) return;

    Map<String, dynamic> arguments = {
      "title": message.notification?.title,
      "text": message.notification?.body,
      "logId": message.data['id']
    };
    // Get.toNamed(Routes.ACTION_PARENT, arguments: arguments);
  }

  Future initPushNotifcations() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    print("INIT");

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      print("notification ${message.toMap()}");
      print("notification: ${message.data['deviceToken']}");
      if (notification == null) return;

      final box = GetStorage();
      final data = box.read("dataParent") as Map<String, dynamic>;

      log('registrationToken: ${data["registrationToken"]}');
      log('registrationTokenChild: ${data["registrationTokenChild"]}');

      final deviceToken = message.data['deviceToken'];

      // if (deviceToken != null) {
      //   if (deviceToken == data['registrationTokenChild']) {
      //     final browserSurfiorController =
      //         Get.find<BrowserSurfiorController>(); // Inject controller

      //     Uri? url = Uri.tryParse(message.data['url']);
      //     String access = message.data['access'];

      //     if (access == "true") {
      //       browserSurfiorController.webViewController?.loadUrl(
      //           urlRequest:
      //               URLRequest(url: url != null ? WebUri.uri(url) : null));
      //     } else {
      //       browserSurfiorController.checkBlacklist(url);
      //     }
      //   }
      // }

      // if (data['registrationToken'] == data['registrationTokenChild']) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_notification',
            color: whiteColor,
            colorized: true,
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future initLocalNotificaitons() async {
    const android = AndroidInitializationSettings('@drawable/ic_notification');
    // const iOS = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
        handleMessage(message);
      }
    });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await getToken();
    print('Token FCM: $fCMToken');
    initPushNotifcations();
    initLocalNotificaitons();
  }
}
