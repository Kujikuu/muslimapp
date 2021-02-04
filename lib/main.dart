import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mulsim_app/screens/welcome_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cron/cron.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
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
    var localeLoaded = prefs.getString("lan") ?? 'ar';
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
            appBarTheme: AppBarTheme(centerTitle: false),
            fontFamily: GoogleFonts.cairo().fontFamily,
            platform: TargetPlatform.iOS,
            primarySwatch: _color,
            brightness: _brightness,
            // primaryColor: primaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: WelcomeScreen());
  }
}
