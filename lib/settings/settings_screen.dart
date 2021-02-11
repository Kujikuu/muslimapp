import 'dart:io';
import 'dart:math';

import 'package:apk_admin/apk_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muslimapp/main.dart';
import 'package:muslimapp/settings/colortheme_settings.dart';
import 'package:muslimapp/settings/lang_settings.dart';
import 'package:muslimapp/settings/prayertimes_screen.dart';
import 'package:muslimapp/widgets/rateapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:muslimapp/ulit/adsmanager.dart';
import 'package:firebase_admob/firebase_admob.dart';

class SettingsOnePage extends StatefulWidget {
  @override
  _SettingsOnePageState createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<SettingsOnePage> {
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: AdManager.bannerAdUnitId, size: AdSize.fullBanner);
  }

  InterstitialAd createInterAd() {
    return InterstitialAd(adUnitId: AdManager.interstitialAdUnitId);
  }

  bool _dark;
  bool _isMuted = false;
  var isAds = 0;

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: AdManager.appId);
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    super.initState();
    loadPrefs();
    _dark = false;
    var rgn = Random();
    setState(() {
      isAds = rgn.nextInt(3);
    });
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  User user;
  void loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = FirebaseAuth.instance.currentUser;
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
            icon: _dark
                ? Icon(CupertinoIcons.moon_fill)
                : Icon(CupertinoIcons.moon),
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
                // Card(
                //   elevation: 4.0,
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10.0)),
                //   child: Column(
                //     children: <Widget>[
                //       user != null
                //           ? ListTile(
                //               leading: Icon(
                //                 CupertinoIcons.person_alt,
                //               ),
                //               title: Text(
                //                   AppLocalizations.of(context).signuporlogin),
                //               onTap: () {
                //                 Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (context) => AccountScreen()));
                //               },
                //             )
                //           : ListTile(
                //               leading: Icon(
                //                 CupertinoIcons.person_alt,
                //               ),
                //               title: Text('Ahmed AbdAllah'),
                //               onTap: () {
                //                 Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (context) => AccountScreen()));
                //               },
                //             )
                //     ],
                //   ),
                // ),
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
                          CupertinoIcons.bell_fill,
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
                          if (isAds == 3)
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
                          if (isAds == 3)
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
                          if (isAds == 3)
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
                          CupertinoIcons.star_circle_fill,
                        ),
                        title: Text(AppLocalizations.of(context).rateapp),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => RateApp(),
                          );
                        },
                      ),
                      if (Platform.isAndroid) _buildDivider(),
                      if (Platform.isAndroid)
                        ListTile(
                          leading: Icon(
                            CupertinoIcons.share,
                          ),
                          title: Text(AppLocalizations.of(context).shareapp),
                          onTap: () async {
                            ApkExporter apkExporter = ApkExporter();
                            await apkExporter
                                .shareAppViaBluetooth("com.kujiku.muslimapp");
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
