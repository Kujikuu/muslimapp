import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mulsim_app/main.dart';
import 'package:mulsim_app/screens/lang_settings.dart';
import 'package:mulsim_app/screens/prayertimes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsOnePage extends StatefulWidget {
  @override
  _SettingsOnePageState createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<SettingsOnePage> {
  bool _dark;

  @override
  void initState() {
    super.initState();
    _dark = false;
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
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.solidUserCircle,
                        ),
                        title: Text(AppLocalizations.of(context).signuporlogin),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Languagesettings()));
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
                      ListTile(
                        leading: Icon(
                          Icons.notifications,
                        ),
                        title: Text(AppLocalizations.of(context).notifications),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Languagesettings()));
                        },
                      )
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Languagesettings()));
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
                          FontAwesomeIcons.quran,
                        ),
                        title: Text(AppLocalizations.of(context).rateapp),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrayerTimesSettings()));
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
