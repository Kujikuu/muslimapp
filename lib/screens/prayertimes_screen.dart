import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrayerTimesSettings extends StatefulWidget {
  @override
  _PrayerTimesSettingsState createState() => _PrayerTimesSettingsState();
}

class _PrayerTimesSettingsState extends State<PrayerTimesSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).prayertimes),
      ),
      body: Container(),
    );
  }
}
