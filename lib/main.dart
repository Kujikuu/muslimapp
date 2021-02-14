import 'package:adhan/adhan.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:muslimapp/screens/welcome_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muslimapp/ulit/LocalNotifyManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  Workmanager.initialize(callbackDispatcher);
  Workmanager.registerPeriodicTask("uniqueName", "taskName",
      inputData: {"data1": "value1"},
      frequency: Duration(minutes: 15),
      initialDelay: Duration(minutes: 5));
  runApp(MyApp());
  initPrayers();
}

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) {
    localNotifyManager.initSetting();
    schedules();
    return Future.value(true);
  });
}

PrayerTimes prayerTimes;
final location = new Location();
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

var method;
var params;
var _isMuted;

loadPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _isMuted = prefs.getBool("mute") ?? false;
  method = prefs.getString("method") ?? 'egyptian';
  setMethod();
}

setMethod() {
  switch (method) {
    case 'egyptian':
      params = CalculationMethod.egyptian.getParameters();
      break;
    case 'karachi':
      params = CalculationMethod.karachi.getParameters();
      break;
    case 'dubai':
      params = CalculationMethod.dubai.getParameters();
      break;
    case 'kuwait':
      params = CalculationMethod.kuwait.getParameters();
      break;
    case 'muslim_world_league':
      params = CalculationMethod.muslim_world_league.getParameters();
      break;
    case 'north_america':
      params = CalculationMethod.north_america.getParameters();
      break;
    case 'qatar':
      params = CalculationMethod.qatar.getParameters();
      break;
    case 'singapore':
      params = CalculationMethod.singapore.getParameters();
      break;
  }
}

Future<void> initPrayers() async {
  await loadPrefs();
  getLocationData().then((locationData) {
    if (locationData != null) {
      prayerTimes = PrayerTimes(
          Coordinates(locationData.latitude, locationData.longitude),
          DateComponents.from(DateTime.now()),
          params);
      schedules();
    }
  });
}

void schedules() {
  print("schedules has called");
  // if (prayerTimes.nextPrayer() == prayerTimes.dhuhr)
  if (prayerTimes.dhuhr.isAfter(DateTime.now()))
    localNotifyManager.showAdhan(
        title: "Duhur",
        body: "Duhur at ${DateFormat.jm().format(prayerTimes.dhuhr)}",
        date: prayerTimes.dhuhr,
        muted: !_isMuted,
        no: "2");
  // else if (prayerTimes.nextPrayer() == prayerTimes.asr)
  if (prayerTimes.asr.isAfter(DateTime.now()))
    localNotifyManager.showAdhan(
        title: 'Asr',
        body: "Asr at ${DateFormat.jm().format(prayerTimes.asr)}",
        date: prayerTimes.asr,
        muted: !_isMuted,
        no: "3");
  // else if (prayerTimes.nextPrayer() == prayerTimes.maghrib)
  if (prayerTimes.maghrib.isAfter(DateTime.now()))
    localNotifyManager.showAdhan(
        title: 'Maghrib',
        body: "Maghrib at ${DateFormat.jm().format(prayerTimes.maghrib)}",
        date: prayerTimes.maghrib,
        muted: !_isMuted,
        no: "4");
  if (prayerTimes.isha.isAfter(DateTime.now()))
    // else if (prayerTimes.nextPrayer() == prayerTimes.isha)
    localNotifyManager.showAdhan(
        title: "Isha",
        body: "Isha at ${DateFormat.jm().format(prayerTimes.isha)}",
        date: prayerTimes.isha,
        muted: !_isMuted,
        no: "5");
  // else if (prayerTimes.nextPrayer() == prayerTimes.fajr)
  if (prayerTimes.fajr.isAfter(DateTime.now()))
    localNotifyManager.showAdhan(
        title: "Fajr",
        body: "Fajr at ${DateFormat.jm().format(prayerTimes.fajr)}",
        date: prayerTimes.fajr,
        muted: !_isMuted,
        no: "6");
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.changeLanguage(newLocale);
  }

  static void setBrightness(
      BuildContext context, Brightness newBrightness) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.changeBrightness(newBrightness);
  }

  static void setThemeColor(
      BuildContext context, MaterialColor newcolor) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.changeThemeColor(newcolor);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  var _brightness;
  var _color;

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var localeLoaded = prefs.getString("lan") ?? 'en';
    changeLanguage(Locale(localeLoaded, ''));
  }

  loadBrightness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var localeLoaded = prefs.getBool("dark") ?? false;
    changeBrightness(localeLoaded ? Brightness.light : Brightness.dark);
  }

  loadThemeColor() async {
    List<Color> colorsThemes = [
      Colors.blue,
      Colors.amber,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.pink,
      Colors.blueGrey,
      Colors.brown
    ];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Color localeLoaded = colorsThemes[prefs.get("themecolor") ?? 0];
    changeThemeColor(localeLoaded);
  }

  changeBrightness(Brightness brightness) {
    setState(() {
      _brightness = brightness;
    });
  }

  changeThemeColor(Color color) {
    setState(() {
      _color = color;
    });
  }

  @override
  void initState() {
    loadLanguage();
    loadBrightness();
    loadThemeColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale('ar', ''), // Arabic, no country code
        ],
        locale: _locale,
        debugShowCheckedModeBanner: false,
        title: 'Muslim App',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                centerTitle: false,
                textTheme: TextTheme(
                    title: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: GoogleFonts.tajawal().fontFamily))),
            fontFamily: GoogleFonts.tajawal().fontFamily,
            // platform: TargetPlatform.iOS,
            primarySwatch: _color,
            brightness: _brightness,
            // // primaryColorDark: _color,
            // accentColor: Theme.of(context).primaryColorDark,
            // highlightColor: _color,
            // indicatorColor: _color,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: WelcomeScreen());
  }
}
