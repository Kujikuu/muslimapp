import 'package:adhan/adhan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:mulsim_app/main.dart';
import 'package:mulsim_app/ulit/constants.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final location = new Location();
  String locationError;
  PrayerTimes prayerTimes;

  Future<LocationData> getLocationData() async {
    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  @override
  void initState() {
    getLocationData().then((locationData) {
      if (!mounted) {
        return;
      }
      if (locationData != null) {
        setState(() {
          prayerTimes = PrayerTimes(
              Coordinates(locationData.latitude, locationData.longitude),
              DateComponents.from(DateTime.now()),
              CalculationMethod.karachi.getParameters());
        });
      } else {
        setState(() {
          locationError = "Couldn't Get Your Location!";
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM').format(now);
    var hijriformat = new HijriCalendar.now();

    String _nxtPrayerName;
    var _nxtPrayerImg;
    var _prayernxt;
    switch (prayerTimes.nextPrayer()) {
      case Prayer.dhuhr:
        _nxtPrayerName = "Dhur";
        _nxtPrayerImg =
            'https://oshawamosque.com/wp-content/uploads/2020/04/Dhuhr-Prayer-English.png';
        _prayernxt = prayerTimes.dhuhr;
        break;
      case Prayer.asr:
        _nxtPrayerName = "Asr";
        _nxtPrayerImg =
            'https://oshawamosque.com/wp-content/uploads/2020/04/Asr-Prayer-English.png';
        _prayernxt = prayerTimes.asr;
        break;
      case Prayer.fajr:
        _nxtPrayerName = "Fajr";
        _nxtPrayerImg =
            'https://oshawamosque.com/wp-content/uploads/2020/04/Fajr-Prayer-English.png';
        _prayernxt = prayerTimes.fajr;
        break;
      case Prayer.maghrib:
        _nxtPrayerName = "Maghrib";
        _nxtPrayerImg =
            'https://oshawamosque.com/wp-content/uploads/2020/04/Maghrib-Prayer-English.png';
        _prayernxt = prayerTimes.maghrib;
        break;
      case Prayer.isha:
        _nxtPrayerName = "Isha";
        _nxtPrayerImg =
            'https://oshawamosque.com/wp-content/uploads/2020/04/Isha-Prayer-English.png';
        _prayernxt = prayerTimes.isha;
        break;
      default:
        _nxtPrayerName = "None";
        break;
    }

    if (prayerTimes.nextPrayer() == null)
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    else

      // var currntPrayer = PrayerTimes(coordinates, dateComponents, calculationParameters)
      return Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appName,
                      style: titleTxt,
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_pin),
                        Text(
                          'Zagazig',
                          // style: welcomeSub,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 30),
                HomeBanner(
                  deviceHeight: deviceHeight,
                  deviceWidth: deviceWidth,
                  prayerTimes: prayerTimes,
                  nxtPrayerName: _nxtPrayerName,
                  nxtPrayerImg: _nxtPrayerImg,
                  prayernxt: _prayernxt,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Featured', style: featTxt),
                    Text('View all', style: viewAllTxt),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                    child: ListView(
                  children: [
                    buildVerses(deviceWidth, deviceHeight, context),
                    buildVerses(deviceWidth, deviceHeight, context),
                    buildVerses(deviceWidth, deviceHeight, context)
                  ],
                ))
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_searching), label: 'Qibla'),
            BottomNavigationBarItem(
                icon: Icon(Icons.timelapse), label: 'Prayers')
          ],
        ),
      );
  }

  Padding buildVerses(
      double deviceWidth, double deviceHeight, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        width: deviceWidth,
        height: deviceHeight * 0.25,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: deviceWidth * 0.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CachedNetworkImage(
                    height: 30,
                    imageUrl:
                        'https://images-na.ssl-images-amazon.com/images/I/41APHvabE0L.png',
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verse of the day',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Al-Jumu`a',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text(
                'But never will they express their desire ( for Death), beacause of th (deeds) their hands have sent on before them! and Allah knows well those that do wrong!',
                style: TextStyle(color: Colors.white)),
            // SizedBox(height: 5),
            Divider(color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton.icon(
                    minWidth: deviceWidth / 2.6,
                    onPressed: () {},
                    textColor: Colors.white,
                    icon: Icon(Icons.read_more),
                    label: Text('Read')),
                FlatButton.icon(
                    minWidth: deviceWidth / 2.6,
                    onPressed: () {},
                    textColor: Colors.white,
                    icon: Icon(Icons.share),
                    label: Text('Share')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HomeBanner extends StatelessWidget {
  const HomeBanner(
      {Key key,
      @required this.deviceHeight,
      @required this.deviceWidth,
      @required this.prayerTimes,
      @required nxtPrayerName,
      @required nxtPrayerImg,
      @required prayernxt})
      : _nxtPrayerName = nxtPrayerName,
        _nxtPrayerImg = nxtPrayerImg,
        _prayernxt = prayernxt,
        super(key: key);

  final double deviceHeight;
  final double deviceWidth;
  final PrayerTimes prayerTimes;
  final _nxtPrayerName;
  final _nxtPrayerImg;
  final _prayernxt;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight * .23,
      width: deviceWidth,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient:
              LinearGradient(colors: [Color(0xff5b6afa), Color(0xff87ecfe)])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: deviceWidth * .20,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5)),
                          child:
                              Icon(Icons.notifications, color: Colors.white)),
                      Text('Mute', style: TextStyle(color: Colors.white))
                    ]),
              ),
              SizedBox(height: 20),
              Text('Next Prayer',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
              Text(DateFormat.jm().format(_prayernxt),
                  style: TextStyle(color: Colors.white, fontSize: 35)),
              SizedBox(height: 5),
              Text(
                _prayernxt.difference(DateTime.now()).inHours > 0
                    ? _prayernxt
                            .difference(DateTime.now())
                            .inHours
                            .floor()
                            .toString() +
                        ' hours left untill ' +
                        _nxtPrayerName
                    : _prayernxt
                            .difference(DateTime.now())
                            .inMinutes
                            .floor()
                            .toString() +
                        ' minutes left untill ' +
                        _nxtPrayerName,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Container(
            height: 140,
            // transform: Matrix4.translationValues(0.0, -20.0, 0.0),
            child: CachedNetworkImage(imageUrl: _nxtPrayerImg),
          )
        ],
      ),
    );
  }
}

void scheduleAlarm(DateTime scheduledNotificationDateTime) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'alarm_notif',
    'alarm_notif',
    'Channel for Alarm notification',
    icon: 'ic_launcher',
    sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
    largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
  );

  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.schedule(0, 'Office', 'Title',
      scheduledNotificationDateTime, platformChannelSpecifics);
}

//  appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           title: Text(appName, style: titleTxt),
//           leading: IconButton(
//             color: Colors.black54,
//             hoverColor: Colors.black87,
//             icon: Icon(Icons.menu),
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//           actions: [
//             IconButton(
//               color: Colors.black54,
//               hoverColor: Colors.black87,
//               icon: Icon(Icons.settings),
//               onPressed: () {},
//             )
//           ],
//         ),
//         body: Builder(
//           builder: (BuildContext context) {
//             if (prayerTimes != null) {
//               return Column(
//                 children: [
//                   Text(
//                     'Prayer Times for Today',
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                       'Fajr Time: ' + DateFormat.jm().format(prayerTimes.fajr)),
//                   Text('Sunrise Time: ' +
//                       DateFormat.jm().format(prayerTimes.sunrise)),
//                   Text('Dhuhr Time: ' +
//                       DateFormat.jm().format(prayerTimes.dhuhr)),
//                   Text('Asr Time: ' + DateFormat.jm().format(prayerTimes.asr)),
//                   Text('Maghrib Time: ' +
//                       DateFormat.jm().format(prayerTimes.maghrib)),
//                   Text(
//                       'Isha Time: ' + DateFormat.jm().format(prayerTimes.isha)),
//                 ],
//               );
//             }
//             if (locationError != null) {
//               return Text(locationError);
//             }
//             return Text('Waiting for Your Location...');
//           },
//         )
