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
        ? NewWidget(
            prayerTimes: prayerTimes,
            prayerimg: _nxtPrayerImg,
            prayername: _prayernxt)
        : Center(child: CircularProgressIndicator());
  }
}

class NewWidget extends StatelessWidget {
  final PrayerTimes prayerTimes;
  final prayername;
  final prayerimg;

  const NewWidget({Key key, this.prayerTimes, this.prayername, this.prayerimg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .5,
                child: Center(
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context).nextprayer,
                          style: TextStyle(fontSize: 20)),
                      SizedBox(height: deviceHeight * .01),
                      Text(DateFormat.jm().format(prayername),
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold)),
                      SizedBox(height: deviceHeight * .01),
                      Expanded(
                        child: Image.asset(
                          prayerimg,
                        ),
                      ),
                      SizedBox(height: deviceHeight * .03),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat('EEEE, d MMMM').format(DateTime.now()),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      HijriCalendar.now().toFormat('dd, MMMM yyyy'),
                      style: TextStyle(fontSize: 15),
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
                      selected: prayername == prayerTimes.fajr ? true : false,
                      selectedTileColor: Theme.of(context).primaryColorLight,
                      title: Text(AppLocalizations.of(context).fajr),
                      trailing: Text(DateFormat.jm().format(prayerTimes.fajr)),
                    ),
                    // Divider(),
                    ListTile(
                      selected: prayername == prayerTimes.dhuhr ? true : false,
                      selectedTileColor: Theme.of(context).primaryColorLight,
                      title: Text(AppLocalizations.of(context).duhur),
                      trailing: Text(DateFormat.jm().format(prayerTimes.dhuhr)),
                    ),
                    // Divider(),
                    ListTile(
                      selected: prayername == prayerTimes.asr ? true : false,
                      title: Text(AppLocalizations.of(context).asr),
                      selectedTileColor: Theme.of(context).primaryColorLight,
                      trailing: Text(DateFormat.jm().format(prayerTimes.asr)),
                    ),
                    // Divider(),
                    ListTile(
                      selected:
                          prayername == prayerTimes.maghrib ? true : false,
                      selectedTileColor: Theme.of(context).primaryColorLight,
                      title: Text(AppLocalizations.of(context).maghrib),
                      trailing:
                          Text(DateFormat.jm().format(prayerTimes.maghrib)),
                    ),
                    // Divider(),
                    ListTile(
                      selected: prayername == prayerTimes.isha ? true : false,
                      selectedTileColor: Theme.of(context).primaryColorLight,
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
