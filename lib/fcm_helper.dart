
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifications/Navigation_services.dart';

class FCMHelper {
 static  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  Future<void> initFireBaseMessaging() async {
    //when a msg came and user use the app state:terminated|background --->action nth.
    await requestPermission();
    await printToken();
    HandleForegroundMessage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  }


  Future<void> requestPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> printToken() async {
    String? token = await firebaseMessaging.getToken();
    print("Token ${token!}");
  }

  Future<void> HandleForegroundMessage() async {

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
    const InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
      },
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
//when a msg came and user use the app state:open --->action nth.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: "ic_stat_name",
                // other properties...
              ),
            ));
      }
    });
    // when the user on state:backGround --->action user click on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
    //  Navigator.pushNamed(NavigationService.context!, '/notification');
      }
    });
    //click on the notification when the app is closed
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      // if the notification has data so i can here use this data to do an action
    });
  }
//when the app is closed
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification!.title,
      message.notification!.body,
        const NotificationDetails(
            android: AndroidNotificationDetails(
              'Assigment',
              'Assigment Notifications',
              channelDescription: 'Assigment Notifications',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: false,
              styleInformation: BigTextStyleInformation(''),

            ),
            iOS: DarwinNotificationDetails(
              sound: 'default',
              subtitle: 'Assigment',
              badgeNumber: 1,
              categoryIdentifier: 'Assigment',
              threadIdentifier: 'Assigment',
            )
        ),
    );

    print("Handling a background message: ${message.notification!.title}");
  }

}