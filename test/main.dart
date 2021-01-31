// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:device_info/device_info.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:http/http.dart' as http;
// import 'package:mulsim_app/screens/home_screen.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:rxdart/subjects.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:mulsim_app/ulit/constants.dart';

// import 'screens/welcome_screen.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// /// Streams are created so that app can respond to notification-related events
// /// since the plugin is initialised in the `main` function
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//     BehaviorSubject<ReceivedNotification>();

// final BehaviorSubject<String> selectNotificationSubject =
//     BehaviorSubject<String>();

// // const MethodChannel platform =
// //     MethodChannel('dexterx.dev/flutter_local_notifications_example');

// class ReceivedNotification {
//   ReceivedNotification({
//     @required this.id,
//     @required this.title,
//     @required this.body,
//     @required this.payload,
//   });

//   final int id;
//   final String title;
//   final String body;
//   final String payload;
// }

// void main() async {
//   // needed if you intend to initialize in the `main` function
//   WidgetsFlutterBinding.ensureInitialized();

//   await _configureLocalTimeZone();

//   final NotificationAppLaunchDetails notificationAppLaunchDetails =
//       await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('ic_launcher');

//   /// Note: permissions aren't requested here just to demonstrate that can be
//   /// done later
//   final IOSInitializationSettings initializationSettingsIOS =
//       IOSInitializationSettings(
//           requestAlertPermission: false,
//           requestBadgePermission: false,
//           requestSoundPermission: false,
//           onDidReceiveLocalNotification:
//               (int id, String title, String body, String payload) async {
//             didReceiveLocalNotificationSubject.add(ReceivedNotification(
//                 id: id, title: title, body: body, payload: payload));
//           });
//   const MacOSInitializationSettings initializationSettingsMacOS =
//       MacOSInitializationSettings(
//           requestAlertPermission: false,
//           requestBadgePermission: false,
//           requestSoundPermission: false);
//   final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//       macOS: initializationSettingsMacOS);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onSelectNotification: (String payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: $payload');
//     }
//     selectNotificationSubject.add(payload);
//   });
//   runApp(MyApp(notificationAppLaunchDetails));
// }

// Future<void> _configureLocalTimeZone() async {
//   tz.initializeTimeZones();
//   final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
//   tz.setLocalLocation(tz.getLocation(timeZoneName));
// }

// class MyApp extends StatefulWidget {
//   const MyApp(
//     this.notificationAppLaunchDetails, {
//     Key key,
//   }) : super(key: key);

//   final NotificationAppLaunchDetails notificationAppLaunchDetails;
//   bool get didNotificationLaunchApp =>
//       notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions();
//     _configureDidReceiveLocalNotificationSubject();
//     _configureSelectNotificationSubject();
//   }

//   void _requestPermissions() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             MacOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }

//   void _configureDidReceiveLocalNotificationSubject() {
//     didReceiveLocalNotificationSubject.stream
//         .listen((ReceivedNotification receivedNotification) async {
//       await showDialog(
//         context: context,
//         builder: (BuildContext context) => CupertinoAlertDialog(
//           title: receivedNotification.title != null
//               ? Text(receivedNotification.title)
//               : null,
//           content: receivedNotification.body != null
//               ? Text(receivedNotification.body)
//               : null,
//           actions: <Widget>[
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               onPressed: () async {
//                 Navigator.of(context, rootNavigator: true).pop();
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute<void>(
//                     builder: (BuildContext context) => HomeScreen(),
//                   ),
//                 );
//               },
//               child: const Text('Ok'),
//             )
//           ],
//         ),
//       );
//     });

//     _zonedScheduleNotification();
//   }

//   void _configureSelectNotificationSubject() {
//     selectNotificationSubject.stream.listen((String payload) async {
//       await Navigator.push(
//         context,
//         MaterialPageRoute<void>(
//             builder: (BuildContext context) => HomeScreen()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     didReceiveLocalNotificationSubject.close();
//     selectNotificationSubject.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         platform: TargetPlatform.iOS,
//         primarySwatch: Colors.blue,
//         primaryColor: primaryColor,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: WelcomeScreen(),
//       // home: Scaffold(
//       //   body: Center(
//       //     child: RaisedButton(
//       //       onPressed: () async {
//       //         await _zonedScheduleNotification();
//       //       },
//       //     ),
//       //   ),
//       // ),
//     );
//   }

//   Future<void> _zonedScheduleNotification() async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'scheduled title',
//         'scheduled body',
//         tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//         const NotificationDetails(
//             android: AndroidNotificationDetails('your channel id',
//                 'your channel name', 'your channel description')),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime);
//   }

//   Future<void> _showNotificationWithNoSound() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails('silent channel id', 'silent channel name',
//             'silent channel description',
//             playSound: false,
//             styleInformation: DefaultStyleInformation(true, true));
//     const IOSNotificationDetails iOSPlatformChannelSpecifics =
//         IOSNotificationDetails(presentSound: false);
//     const MacOSNotificationDetails macOSPlatformChannelSpecifics =
//         MacOSNotificationDetails(presentSound: false);
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics,
//         macOS: macOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(0, '<b>silent</b> title',
//         '<b>silent</b> body', platformChannelSpecifics);
//   }

//   Future<void> _showNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//             'your channel id', 'your channel name', 'your channel description',
//             importance: Importance.max,
//             priority: Priority.high,
//             ticker: 'ticker');
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         0, 'plain title', 'plain body', platformChannelSpecifics,
//         payload: 'item x');
//   }

//   Future<void> _showFullScreenNotification() async {
//     await showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Turn off your screen'),
//         content: const Text(
//             'to see the full-screen intent in 5 seconds, press OK and TURN '
//             'OFF your screen'),
//         actions: <Widget>[
//           FlatButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel'),
//           ),
//           FlatButton(
//             onPressed: () async {
//               await flutterLocalNotificationsPlugin.zonedSchedule(
//                   0,
//                   'scheduled title',
//                   'scheduled body',
//                   tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//                   const NotificationDetails(
//                       android: AndroidNotificationDetails(
//                           'full screen channel id',
//                           'full screen channel name',
//                           'full screen channel description',
//                           priority: Priority.high,
//                           importance: Importance.high,
//                           fullScreenIntent: true)),
//                   androidAllowWhileIdle: true,
//                   uiLocalNotificationDateInterpretation:
//                       UILocalNotificationDateInterpretation.absoluteTime);

//               Navigator.pop(context);
//             },
//             child: const Text('OK'),
//           )
//         ],
//       ),
//     );
//   }
// }
