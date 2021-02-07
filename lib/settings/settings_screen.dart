import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mulsim_app/account/signinemail.dart';
import 'package:mulsim_app/main.dart';
import 'package:mulsim_app/screens/account_screen.dart';
import 'package:mulsim_app/settings/colortheme_settings.dart';
import 'package:mulsim_app/settings/lang_settings.dart';
import 'package:mulsim_app/settings/prayertimes_screen.dart';
import 'package:mulsim_app/widgets/rateapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mulsim_app/ulit/adsmanager.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'MobileId';

class SettingsOnePage extends StatefulWidget {
  @override
  _SettingsOnePageState createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<SettingsOnePage> {
  static const MobileAdTargetingInfo targetInfo = MobileAdTargetingInfo(
      // testDevices: testDevice != null ? [testDevice] : null,
      // nonPersonalizedAds: true,
      keywords: ['conquer', 'web develop']);

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.fullBanner,
        targetingInfo: targetInfo);
  }

  InterstitialAd createInterAd() {
    return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId, targetingInfo: targetInfo);
  }

  bool _dark;
  bool _isMuted = false;

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: AdManager.appId);
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    super.initState();
    loadPrefs();
    _dark = false;
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  FirebaseUser user;
  void loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = await FirebaseAuth.instance.currentUser();
    setState(() {
      _isMuted = prefs.getBool("mute") ?? false;
    });
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).settings,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.moon),
            onPressed: () async {
              var darken = Theme.of(context).brightness;
              if (darken == Brightness.dark)
                _dark = false;
              else if (darken == Brightness.light) _dark = true;
              Brightness newBrightness =
                  _dark ? Brightness.dark : Brightness.light;
              MyApp.setBrightness(context, newBrightness);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("dark", !_dark);
            },
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      user != null
                          ? ListTile(
                              leading: Icon(
                                FontAwesomeIcons.solidUserCircle,
                              ),
                              title: Text(
                                  AppLocalizations.of(context).signuporlogin),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignInWithEmail()));
                              },
                            )
                          : ListTile(
                              leading: Icon(
                                FontAwesomeIcons.solidUserCircle,
                              ),
                              title: Text('Ahmed AbdAllah'),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AccountScreen()));
                              },
                            )
                    ],
                  ),
                ),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      SwitchListTile(
                        title: Text(AppLocalizations.of(context).notifications),
                        value: _isMuted,
                        selected: _isMuted,
                        onChanged: (value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool("mute", value);
                          setState(() {
                            _isMuted = value;
                          });
                        },
                        secondary: Icon(
                          Icons.notifications,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 4.0,
                  // margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.quran,
                        ),
                        title: Text(AppLocalizations.of(context).prayertimes),
                        onTap: () {
                          createInterAd()
                            ..load()
                            ..show();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrayerTimesSettings()));
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.language,
                        ),
                        title: Text(AppLocalizations.of(context).langsettings),
                        onTap: () {
                          createInterAd()
                            ..load()
                            ..show();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Languagesettings()));
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.palette,
                        ),
                        title: Text(AppLocalizations.of(context).colortheme),
                        onTap: () {
                          createInterAd()
                            ..load()
                            ..show();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ColorThemeSettings()));
                        },
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 4.0,
                  // margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.solidStar,
                        ),
                        title: Text(AppLocalizations.of(context).rateapp),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => RateApp(),
                          );
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.facebook,
                        ),
                        title: Text('facebook.com/muslimapp'),
                        onTap: () {
                          _launchURL('https://facebook.com/muslimapp');
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.twitter,
                        ),
                        title: Text('twitter.com/muslimapp'),
                        onTap: () {
                          _launchURL('https://twitter.com/muslimapp');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
