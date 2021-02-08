import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:muslimapp/ulit/LocalNotifyManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeBanner extends StatefulWidget {
  static void loadPrayers(BuildContext context) async {
    _HomeBannerState state =
        context.findAncestorStateOfType<_HomeBannerState>();
    state.loadPrefs();
  }

  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final location = new Location();
  String locationError;
  PrayerTimes prayerTimes;
  bool _loading = true;

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
    var cron = new Cron();
    cron.schedule(new Schedule.parse('0 1 * * *'), () async {
      schedules();
    });
    super.initState();
    loadPrefs();
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
    this._dateTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // schedules();
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
    localNotifyManager.showFullScreenNotification(
        AppLocalizations.of(context).duhur,
        "${AppLocalizations.of(context).duhur} ${prayerTimes.dhuhr}",
        prayerTimes.dhuhr);
    // else if (DateTime.now().subtract(Duration(seconds: 3)) == prayerTimes.asr)
    localNotifyManager.showFullScreenNotification(
        AppLocalizations.of(context).asr,
        "${AppLocalizations.of(context).asr} ${prayerTimes.asr}",
        prayerTimes.asr);
    // else if (DateTime.now().subtract(Duration(seconds: 3)) ==
    //     prayerTimes.maghrib)
    localNotifyManager.showFullScreenNotification(
        AppLocalizations.of(context).maghrib,
        "${AppLocalizations.of(context).maghrib} ${prayerTimes.maghrib}",
        prayerTimes.maghrib);
    // else if (DateTime.now().subtract(Duration(seconds: 3)) == prayerTimes.isha)
    localNotifyManager.showFullScreenNotification(
        AppLocalizations.of(context).isha,
        "${AppLocalizations.of(context).isha} ${prayerTimes.isha}",
        prayerTimes.isha);
    // else if (DateTime.now().subtract(Duration(seconds: 3)) == prayerTimes.fajr)
    localNotifyManager.showFullScreenNotification(
        AppLocalizations.of(context).fajr,
        "${AppLocalizations.of(context).fajr} ${prayerTimes.fajr}",
        prayerTimes.fajr);
  }

  bool _isMuted;
  @override
  Widget build(BuildContext context) {
    var _timeinhours = _prayernxt.difference(DateTime.now()).inHours;
    var _timeminutes = _prayernxt.difference(DateTime.now()).inMinutes;
    var _timebetween = _timeminutes - (_timeinhours * 60);
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
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
                    // SizedBox(height: 5),
                    Text(AppLocalizations.of(context).nextprayer,
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text(DateFormat.jm().format(_prayernxt),
                        style: TextStyle(color: Colors.white, fontSize: 28)),
                    // SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        '${_timeinhours.toString()}:${_timebetween.toString()} ${AppLocalizations.of(context).hoursleft} ' +
                            _nxtPrayerName,
                        style: TextStyle(color: Colors.white),
                      ),
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
