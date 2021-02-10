import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:muslimapp/ulit/LocalNotifyManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:workmanager/workmanager.dart';

class HomeBanner extends StatefulWidget {
  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final location = new Location();
  String locationError;
  PrayerTimes prayerTimes;
  bool _loading = true;

  void callbackDispatcher() {
    Workmanager.executeTask((task, inputData) {
      print(
          "Native called background task: $task"); //simpleTask will be emitted here.
      schedules();
      return Future.value(true);
    });
  }

  setMute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMuted = prefs.getBool("mute") ?? false;
    });
  }

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

  static var method;
  static var params;

  setMethod() {
    switch (method) {
      case 'egyptian':
        setState(() {
          params = CalculationMethod.egyptian.getParameters();
        });
        break;
      case 'karachi':
        setState(() {
          params = CalculationMethod.karachi.getParameters();
        });
        break;
      case 'dubai':
        setState(() {
          params = CalculationMethod.dubai.getParameters();
        });
        break;
      case 'kuwait':
        setState(() {
          params = CalculationMethod.kuwait.getParameters();
        });
        break;
      case 'muslim_world_league':
        setState(() {
          params = CalculationMethod.muslim_world_league.getParameters();
        });
        break;
      case 'north_america':
        setState(() {
          params = CalculationMethod.north_america.getParameters();
        });
        break;
      case 'qatar':
        setState(() {
          params = CalculationMethod.qatar.getParameters();
        });
        break;
      case 'singapore':
        setState(() {
          params = CalculationMethod.singapore.getParameters();
        });
        break;
    }
  }

  Timer _timer;
  DateTime _dateTime;
  @override
  initState() {
    // var cron = new Cron();
    // cron.schedule(new Schedule.parse('0 1 * * *'), () async {
    //   schedules();
    // });
    Workmanager.initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    Workmanager.registerPeriodicTask(
      "2",
      "simpleTask",
    ); //Android only (see below)
    super.initState();
    loadPrefs();
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
    this._dateTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // schedules();
      setMute();
      setState(() {
        _prayernxt = _prayernxt;
        _isMuted = _isMuted;
      });
    });
  }

  loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMuted = prefs.getBool("mute") ?? false;
      method = prefs.getString("method") ?? 'egyptian';
    });
    setMethod();
    getLocationData().then((locationData) {
      if (!mounted) {
        return;
      }
      if (locationData != null) {
        setState(() {
          prayerTimes = PrayerTimes(
              Coordinates(locationData.latitude, locationData.longitude),
              DateComponents.from(DateTime.now()),
              params);
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
        });
        setState(() {
          _loading = false;
        });
      } else {
        setState(() {
          locationError = "Couldn't Get Your Location!";
        });
      }
    });

    // await AndroidAlarmManager.periodic(const Duration(days: 1), 0, schedules);
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
    // print('schedules');
    // if (DateTime.now().subtract(Duration(seconds: 3)) == prayerTimes.dhuhr)
    localNotifyManager.showAdhan(
        title: AppLocalizations.of(context).duhur,
        body: "${AppLocalizations.of(context).duhur} ${prayerTimes.dhuhr}",
        date: prayerTimes.dhuhr,
        muted: !_isMuted);
    // else if (DateTime.now().subtract(Duration(seconds: 3)) == prayerTimes.asr)
    localNotifyManager.showAdhan(
        title: AppLocalizations.of(context).asr,
        body: "${AppLocalizations.of(context).asr} ${prayerTimes.asr}",
        date: prayerTimes.asr,
        muted: !_isMuted);
    // else if (DateTime.now().subtract(Duration(seconds: 3)) ==
    //     prayerTimes.maghrib)
    localNotifyManager.showAdhan(
        title: AppLocalizations.of(context).maghrib,
        body: "${AppLocalizations.of(context).maghrib} ${prayerTimes.maghrib}",
        date: prayerTimes.maghrib,
        muted: !_isMuted);
    // else if (DateTime.now().subtract(Duration(seconds: 3)) == prayerTimes.isha)
    localNotifyManager.showAdhan(
        title: AppLocalizations.of(context).isha,
        body: "${AppLocalizations.of(context).isha} ${prayerTimes.isha}",
        date: prayerTimes.isha,
        muted: !_isMuted);
    // else if (DateTime.now().subtract(Duration(seconds: 3)) == prayerTimes.fajr)
    localNotifyManager.showAdhan(
        title: AppLocalizations.of(context).fajr,
        body: "${AppLocalizations.of(context).fajr} ${prayerTimes.fajr}",
        date: prayerTimes.fajr,
        muted: !_isMuted);
  }

  bool _isMuted;
  @override
  Widget build(BuildContext context) {
    var _timeinhours = _prayernxt.difference(DateTime.now()).inHours;
    var _timeminutes = _prayernxt.difference(DateTime.now()).inMinutes;
    var _timebetween = _timeminutes - (_timeinhours * 60);
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    int calculateDifference(DateTime date) {
      DateTime now = DateTime.now();
      return DateTime(date.year, date.month, date.day)
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
    }

    if (!_loading)
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
    return !_loading
        ? Container(
            height: deviceHeight * .23,
            width: deviceWidth,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).primaryColorDark
                ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: deviceWidth * .25,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
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
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(
                                    _isMuted
                                        ? CupertinoIcons.speaker_2_fill
                                        : CupertinoIcons.speaker_fill,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                                _isMuted
                                    ? AppLocalizations.of(context).ring
                                    : AppLocalizations.of(context).mute,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18))
                          ]),
                    ),
                    SizedBox(height: deviceHeight * .02),
                    Text(AppLocalizations.of(context).nextprayer,
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    SizedBox(height: deviceHeight * .005),
                    Text(DateFormat.jm().format(_prayernxt),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: deviceHeight * .02),
                    if (calculateDifference(_prayernxt) == 0 &&
                        _prayernxt == prayerTimes.fajr)
                      Expanded(
                        child: Text(
                          '${AppLocalizations.of(context).tmr} ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      Row(
                        children: [
                          Text(
                            _timeinhours < 10
                                ? '0${_timeinhours.toString()}:'
                                : '${_timeinhours.toString()}:',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _timebetween < 10
                                ? '0${_timebetween.toString()}'
                                : '${_timebetween.toString()}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' ${AppLocalizations.of(context).hoursleft} ' +
                                _nxtPrayerName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                  ],
                ),
                Container(
                  height: deviceHeight * .15,
                  // transform: Matrix4.translationValues(-20.0, -10.0, 0.0),
                  child: Image.asset(_nxtPrayerImg),
                )
              ],
            ),
          )
        : CircularProgressIndicator().center();
  }
}

HomeBanner homeBanner = HomeBanner();
