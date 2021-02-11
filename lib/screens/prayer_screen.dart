import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nb_utils/nb_utils.dart';

class PrayerScreen extends StatefulWidget {
  @override
  _PrayerScreenState createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final location = new Location();
  String locationError;
  PrayerTimes prayerTimes;
  bool _loading = true;
  static var method;
  static var params;
  String _nxtPrayerName;
  var _nxtPrayerImg;
  var _prayernxt;
  bool _isMuted;

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
  }

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

  @override
  void initState() {
    loadPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        ? NewWidget(prayerTimes: prayerTimes)
        : Center(child: CircularProgressIndicator());
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key key,
    @required this.prayerTimes,
  }) : super(key: key);

  final PrayerTimes prayerTimes;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      // contentPadding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                      title: Column(
                        children: [
                          Text(
                            DateFormat('EEEE, d MMMM').format(DateTime.now()),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            HijriCalendar.now().toFormat('dd, MMMM yyyy'),
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(AppLocalizations.of(context).fajr),
                      trailing: Text(DateFormat.jm().format(prayerTimes.fajr)),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(AppLocalizations.of(context).duhur),
                      trailing: Text(DateFormat.jm().format(prayerTimes.dhuhr)),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(AppLocalizations.of(context).asr),
                      trailing: Text(DateFormat.jm().format(prayerTimes.asr)),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(AppLocalizations.of(context).maghrib),
                      trailing:
                          Text(DateFormat.jm().format(prayerTimes.maghrib)),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(AppLocalizations.of(context).isha),
                      trailing: Text(DateFormat.jm().format(prayerTimes.isha)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
