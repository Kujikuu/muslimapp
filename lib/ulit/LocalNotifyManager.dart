import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';

class LocalNotifyManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  LocalNotifyManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      requestIOSPermession();
    }
    initializePlatform();
  }

  requestIOSPermession() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  initializePlatform() {
    var initSettingAndroid = AndroidInitializationSettings('icon');
    var initSettingIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestAlertPermission: true,
        requestBadgePermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotification notification = ReceiveNotification(
              id: id, title: title, body: body, payload: payload);
          didReceiveLocalNotificationSubject.add(notification);
        });
    initSetting = InitializationSettings(
        android: initSettingAndroid, iOS: initSettingIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> shwoNotification() async {
    var androidChannel = AndroidNotificationDetails(
        '1', 'AthanNotification', 'CHANNEL_DESCRIPTION',
        sound: RawResourceAndroidNotificationSound('azan2'),
        importance: Importance.max,
        playSound: true,
        priority: Priority.high,
        timeoutAfter: 20000,
        enableVibration: true,
        enableLights: true);
    var iosChannel = IOSNotificationDetails(sound: 'azan2.mp3');
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(
        0, 'Test Title', 'Test Body', platformChannel,
        payload: 'New Payload');
  }

  Future<void> showAdhan(
      {@required String title,
      @required String body,
      @required DateTime date,
      bool muted = true,
      String no = "2"}) async {
    var androidChannel = AndroidNotificationDetails(
      '$no',
      'Adhan$no Noification',
      '',
      icon: 'icon',
      importance: Importance.max,
      playSound: muted,
      priority: Priority.high,
      enableVibration: true,
      fullScreenIntent: true,
      sound: RawResourceAndroidNotificationSound('azan2'),
    );

    var iosChannel = IOSNotificationDetails(sound: 'azan2.mp3');
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(
      int.parse(no),
      title,
      body,
      date,
      platformChannel,
      payload: 'New Payload',
      androidAllowWhileIdle: true,
    );
  }
}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}
