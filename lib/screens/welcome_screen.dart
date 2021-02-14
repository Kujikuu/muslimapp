import 'package:flutter/material.dart';
import 'package:muslimapp/screens/main_screen.dart';
import 'package:muslimapp/ulit/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: deviceHeight,
          width: deviceWidth,
          child: Container(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context).appName, style: welcomeMain),
                SizedBox(height: 10),
                Text(AppLocalizations.of(context).welcomeSubtitle,
                    style: welcomeSub, maxLines: 2),
                SizedBox(height: 30),
                Container(
                  // width: deviceWidth * 0.85,
                  height: deviceHeight * 0.65,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Image.asset(
                      'assets/welcome.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -25.0, 0.0),
                  width: deviceWidth * 0.50,
                  height: 50,
                  child: RaisedButton(
                    elevation: 0,
                    // color: Color(0xfff9b090),
                    // textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    onPressed: () async {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Main_Screen()));

                      // FirebaseUser user =
                      //     await FirebaseAuth.instance.currentUser();
                      // Navigator.pushReplacement(context, MaterialPageRoute(
                      //   builder: (context) {
                      //     if (user == null) {
                      //       return LoginScreen();
                      //     } else
                      //       return LoginScreen();
                      //   },
                      // ));
                    },
                    child: Text(AppLocalizations.of(context).getStart),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
