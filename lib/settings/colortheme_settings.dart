import 'package:flutter/material.dart';
import 'package:muslimapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ColorThemeSettings extends StatefulWidget {
  @override
  _ColorThemeSettingsState createState() => _ColorThemeSettingsState();
}

class _ColorThemeSettingsState extends State<ColorThemeSettings> {
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
  var currentindex = 0;

  @override
  void initState() {
    super.initState();
    loadThemeColor();
  }

  loadThemeColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentindex = prefs.getInt("themecolor") ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).colortheme),
        ),
        body: GridView.builder(
          padding: EdgeInsets.all(20),
          itemCount: colorsThemes.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    currentindex = index;
                  });
                  MyApp.setThemeColor(context, colorsThemes[index]);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt("themecolor", index);
                  prefs.setInt("themename", colorsThemes[index].value);
                },
                child: CircleAvatar(
                  radius: 10,
                  child: currentindex == index
                      ? Icon(
                          Icons.check,
                          size: 30,
                          color: Colors.white,
                        )
                      : Container(),
                  backgroundColor: colorsThemes[index],
                ),
              ),
            );
          },
        ));
  }
}
