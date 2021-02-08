import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:muslimapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Languagesettings extends StatefulWidget {
  @override
  _LanguagesettingsState createState() => _LanguagesettingsState();
}

class _LanguagesettingsState extends State<Languagesettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).langsettings),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context).arabic),
            leading: SvgPicture.asset('assets/lang/ar.svg', height: 20),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () async {
              Locale newLocale = Locale('ar', '');
              MyApp.setLocale(context, newLocale);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("lan", "ar");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).english),
            leading: SvgPicture.asset('assets/lang/en.svg', height: 20),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () async {
              Locale newLocale = Locale('en', '');
              MyApp.setLocale(context, newLocale);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("lan", "en");
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
