import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mulsim_app/settings/lang_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimesSettings extends StatefulWidget {
  @override
  _PrayerTimesSettingsState createState() => _PrayerTimesSettingsState();
}

class _PrayerTimesSettingsState extends State<PrayerTimesSettings> {
  bool _autoSelected = true;
  var _madhab;
  var _method;
  @override
  void initState() {
    loadSettings();
    super.initState();
  }

  loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _madhab = prefs.getString("madhab") ?? 'egyptian';
      _method = prefs.getString("methos") ?? 'shafi';
    });
  }

  String translatedMadhab;
  String madhabsubtitle;
  String translatedMethod;

  @override
  Widget build(BuildContext context) {
    switch (_method) {
      case 'shafi':
        translatedMethod = AppLocalizations.of(context).shafi;
        break;
      case 'hanafi':
        translatedMethod = AppLocalizations.of(context).hanafi;
        break;
    }

    switch (_madhab) {
      case 'egyptian':
        setState(() {
          translatedMadhab = AppLocalizations.of(context).egyptian;
          madhabsubtitle = "Fajr angle: 19.5, Isha angle: 17.5";
        });
        break;
      case 'muslim_world_league':
        setState(() {
          translatedMadhab = AppLocalizations.of(context).muslim_world_league;
          madhabsubtitle = "Fajr angle: 18, Isha angle: 17";
        });
        break;
      case 'karachi':
        setState(() {
          translatedMadhab = AppLocalizations.of(context).karachi;
          madhabsubtitle = "Fajr angle: 18, Isha angle: 18";
        });
        break;
      case 'umm_al_qura':
        setState(() {
          translatedMadhab = AppLocalizations.of(context).umm_al_qura;
          madhabsubtitle = "Fajr angle: 18, Isha interval: 90";
        });
        break;
      case 'dubai':
        setState(() {
          translatedMadhab = AppLocalizations.of(context).dubai;
          madhabsubtitle = "Fajr angle: 18.2, Isha angle: 18.2";
        });
        break;
      case 'qatar':
        setState(() {
          translatedMadhab = AppLocalizations.of(context).qatar;
          madhabsubtitle = "Fajr angle: 18, Isha interval: 90";
        });
        break;
      case 'kuwait':
        setState(() {
          translatedMadhab = AppLocalizations.of(context).kuwait;
          madhabsubtitle = "Fajr angle: 18, Isha angle: 17.5";
        });
        break;
      case 'singapore':
        setState(() {
          translatedMadhab = AppLocalizations.of(context).singapore;
          madhabsubtitle = "Fajr angle: 20, Isha angle: 18";
        });
        break;
      case 'north_america':
        setState(() {
          translatedMadhab = AppLocalizations.of(context).north_america;
          madhabsubtitle = "Fajr angle: 15, Isha angle: 15";
        });
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).prayertimes),
      ),
      body: ListView(
        children: [
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: <Widget>[
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).autosettings),
                  subtitle: _autoSelected ? Text(translatedMadhab) : null,
                  value: _autoSelected,
                  selected: _autoSelected,
                  onChanged: (value) {
                    setState(() {
                      _autoSelected = value;
                    });
                  },
                ),
                if (!_autoSelected)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      ListTile(
                        title:
                            Text(AppLocalizations.of(context).methodsettings),
                        subtitle: Text(translatedMethod),
                        onTap: () {},
                      ),
                      Divider(),
                      ListTile(
                        isThreeLine: true,
                        title:
                            Text(AppLocalizations.of(context).madhabsettings),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translatedMadhab,
                                style: TextStyle(fontSize: 15)),
                            Text(madhabsubtitle, style: TextStyle(fontSize: 12))
                          ],
                        ),
                        onTap: () {},
                      ),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
