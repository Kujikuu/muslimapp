import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mulsim_app/screens/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mulsim_app/screens/settings_screen.dart';
import 'package:mulsim_app/widgets/qebla_screen.dart';

class Main_Screen extends StatefulWidget {
  @override
  _Main_ScreenState createState() => _Main_ScreenState();
}

class _Main_ScreenState extends State<Main_Screen> {
  int _currentIndex = 0;
  List<Widget> _pages = [HomeScreen(), HomeScreen(), QeblaScreen()];
  Widget _currentPage;

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  @override
  void initState() {
    _currentIndex = 0;
    _currentPage = _pages[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appName),
        centerTitle: false,
        actions: [
          IconButton(
              icon: Icon(FontAwesomeIcons.cog),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsOnePage()));
              }),
        ],
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.bars),
          onPressed: () {},
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // fixedColor: Theme.of(context).primaryColor,
        // // showUnselectedLabels: false,
        // unselectedItemColor: Theme.of(context).accentColor,
        onTap: (index) => changeTab(index),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppLocalizations.of(context).today),
          BottomNavigationBarItem(
              icon: Icon(Icons.timelapse),
              label: AppLocalizations.of(context).prayers),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.solidCompass),
              label: AppLocalizations.of(context).qebla),
        ],
      ),
    );
  }
}
