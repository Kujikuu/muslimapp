import 'package:adhan/adhan.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mulsim_app/ulit/LocalNotifyManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threading/threading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeBanner extends StatefulWidget {
  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final location = new Location();
  String locationError;
  PrayerTimes prayerTimes;
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
  initState() {
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
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
    loadPrefs();
  }

  loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isMuted = prefs.getBool("mute") ?? false;
    await AndroidAlarmManager.periodic(const Duration(days: 1), 0, schedules);
  }

  onNotificationReceive(ReceiveNotification notification) {
    print('Notification Received: ${notification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload: $payload');
  }

  String _nxtPrayerName;
  var _nxtPrayerImg;
  var _prayernxt;
  void schedules() {
    localNotifyManager.showFullScreenNotification(
        AppLocalizations.of(context).duhur,
        "${AppLocalizations.of(context).duhur} ${prayerTimes.dhuhr}",
        prayerTimes.dhuhr);
    localNotifyManager.showFullScreenNotification(
        AppLocalizations.of(context).asr,
        "${AppLocalizations.of(context).asr} ${prayerTimes.asr}",
        prayerTimes.asr);
    localNotifyManager.showFullScreenNotification(
        AppLocalizations.of(context).maghrib,
        "${AppLocalizations.of(context).maghrib} ${prayerTimes.maghrib}",
        prayerTimes.maghrib);
    localNotifyManager.showFullScreenNotification(
        AppLocalizations.of(context).isha,
        "${AppLocalizations.of(context).isha} ${prayerTimes.isha}",
        prayerTimes.isha);
    localNotifyManager.showFullScreenNotification(
        AppLocalizations.of(context).fajr,
        "${AppLocalizations.of(context).fajr} ${prayerTimes.fajr}",
        prayerTimes.fajr);
  }

  bool _isMuted;
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    switch (prayerTimes.nextPrayer()) {
      case Prayer.dhuhr:
        _nxtPrayerName = AppLocalizations.of(context).duhur;
        _nxtPrayerImg = 'assets/prayers/Dhuhr.png';
        _prayernxt = prayerTimes.dhuhr;
        break;
      case Prayer.asr:
        _nxtPrayerName = AppLocalizations.of(context).asr;
        _nxtPrayerImg = 'assets/prayers/Asr.png';
        _prayernxt = prayerTimes.asr;
        break;
      case Prayer.fajr:
        _nxtPrayerName = AppLocalizations.of(context).fajr;
        _nxtPrayerImg = 'assets/prayers/Fajr.png';
        _prayernxt = prayerTimes.fajr;
        break;
      case Prayer.maghrib:
        _nxtPrayerName = AppLocalizations.of(context).maghrib;
        _nxtPrayerImg = 'assets/prayers/Maghrib.png';
        _prayernxt = prayerTimes.maghrib;
        break;
      case Prayer.isha:
        _nxtPrayerName = AppLocalizations.of(context).isha;
        _nxtPrayerImg = 'assets/prayers/Isha.png';
        _prayernxt = prayerTimes.isha;
        break;
      default:
        _nxtPrayerName = AppLocalizations.of(context).fajr;
        _nxtPrayerImg = 'assets/prayers/Fajr.png';
        _prayernxt = prayerTimes.fajr;
        break;
    }
    return Container(
      height: deviceHeight * .25,
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
                          child: GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              _isMuted
                                  ? prefs.setBool("mute", false)
                                  : prefs.setBool("mute", true);
                              setState(() {
                                _isMuted = prefs.getBool("mute") ?? false;
                              });
                            },
                            child: Icon(
                                _isMuted
                                    ? Icons.notifications
                                    : Icons.notifications_off,
                                color: Colors.white),
                          )),
                      Text(
                          _isMuted
                              ? AppLocalizations.of(context).ring
                              : AppLocalizations.of(context).mute,
                          style: TextStyle(color: Colors.white))
                    ]),
              ),
              SizedBox(height: 10),
              Text(AppLocalizations.of(context).nextprayer,
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
                        ' ${AppLocalizations.of(context).hoursleft} ' +
                        _nxtPrayerName
                    : _prayernxt
                            .difference(DateTime.now())
                            .inMinutes
                            .floor()
                            .toString() +
                        ' ${AppLocalizations.of(context).minsleft} ' +
                        _nxtPrayerName,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Container(
            height: 140,
            // transform: Matrix4.translationValues(0.0, -20.0, 0.0),
            child: Image.asset(_nxtPrayerImg),
          )
        ],
      ),
    );
  }
}

HomeBanner homeBanner = HomeBanner();
