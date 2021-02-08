import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muslimapp/settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MadhabSettings extends StatefulWidget {
  @override
  _MadhabSettingsState createState() => _MadhabSettingsState();
}

class _MadhabSettingsState extends State<MadhabSettings> {
  var _madhab;
  String translatedMadhab;
  String madhabsubtitle;
  @override
  void initState() {
    loadsettings;
    super.initState();
  }

  loadsettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _madhab = prefs.getString("madhab");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).madhabsettings),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 60),
        child: Card(
          elevation: 4.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context).egyptian),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Fajr angle: 19.5, Isha angle: 17.5')],
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("madhab", "egyptian");
                  setState(() {
                    _madhab = 'egyptian';
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsOnePage(),
                      ));
                },
              ),
              Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context).muslim_world_league),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Fajr angle: 18, Isha angle: 17')],
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("madhab", "muslim_world_league");
                  setState(() {
                    _madhab = 'muslim_world_league';
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsOnePage(),
                      ));
                },
              ),
              Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context).karachi),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Fajr angle: 18, Isha angle: 18')],
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("madhab", "karachi");
                  setState(() {
                    _madhab = 'karachi';
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsOnePage(),
                      ));
                },
              ),
              Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context).umm_al_qura),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Fajr angle: 18, Isha interval: 90')],
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("madhab", "umm_al_qura");
                  setState(() {
                    _madhab = 'umm_al_qura';
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsOnePage(),
                      ));
                },
              ),
              Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context).dubai),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Fajr angle: 18.2, Isha angle: 18.2')],
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("madhab", "dubai");
                  setState(() {
                    _madhab = 'dubai';
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsOnePage(),
                      ));
                },
              ),
              Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context).qatar),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Fajr angle: 18, Isha interval: 90')],
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("madhab", "qatar");
                  setState(() {
                    _madhab = 'qatar';
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsOnePage(),
                      ));
                },
              ),
              Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context).kuwait),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Fajr angle: 18, Isha angle: 17.5')],
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("madhab", "kuwait");
                  setState(() {
                    _madhab = 'kuwait';
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsOnePage(),
                      ));
                },
              ),
              Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context).singapore),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Fajr angle: 20, Isha angle: 18')],
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("madhab", "singapore");
                  setState(() {
                    _madhab = 'singapore';
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsOnePage(),
                      ));
                },
              ),
              Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context).north_america),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Fajr angle: 15, Isha angle: 15')],
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("madhab", "north_america");
                  setState(() {
                    _madhab = 'north_america';
                  });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsOnePage(),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
