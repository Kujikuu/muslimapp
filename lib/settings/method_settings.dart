import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muslimapp/settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MethodSettings extends StatefulWidget {
  @override
  _MethodSettingsState createState() => _MethodSettingsState();
}

class _MethodSettingsState extends State<MethodSettings> {
  var _method;
  String translatedMadhab;
  String madhabsubtitle;
  @override
  void initState() {
    loadsettings;
    super.initState();
  }

  loadsettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _method = prefs.getString("madhab");
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
                title: Text(AppLocalizations.of(context).hanafi),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("madhab", "hanafi");
                  setState(() {
                    _method = 'hanafi';
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
                title: Text(AppLocalizations.of(context).shafi),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("madhab", "shafi");
                  setState(() {
                    _method = 'shafi';
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
