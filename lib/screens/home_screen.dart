import 'package:adhan/adhan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mulsim_app/database/user_options.dart';
import 'package:mulsim_app/ulit/constants.dart';
import 'package:location/location.dart';
import 'package:mulsim_app/widgets/home_banner.dart';
import 'package:mulsim_app/widgets/home_features.dart';
import 'package:threading/threading.dart';
import 'package:mulsim_app/ulit/LocalNotifyManager.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final location = new Location();
  String locationError;
  PrayerTimes prayerTimes;
  Future<List<UserOptions>> _userOptions;
  Thread thread;
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
    super.initState();
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
    thread = new Thread(work);
    thread.start();
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
  }

  @override
  void dispose() {
    thread.join();
    super.dispose();
  }

  onNotificationReceive(ReceiveNotification notification) {
    print('Notification Received: ${notification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload: $payload');
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  bool isMuted = false;
  String _nxtPrayerName;
  var _nxtPrayerImg;
  var _prayernxt;
  void work() async {
    while (true) {
      await Thread.sleep(10000);
      var time = _prayernxt.difference(DateTime.now()).inSeconds;
      if (time >= 15 && time <= 25) {
        localNotifyManager.showFullScreenNotification(_nxtPrayerName,
            '$_nxtPrayerName is about start. don`t mess it please!');

        setState(() {
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
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
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
                    buildFeatures(deviceWidth, deviceHeight),
                  ],
                ))
              ],
            ),
          ),
        ),
      );
  }
}
