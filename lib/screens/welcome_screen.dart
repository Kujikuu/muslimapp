import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mulsim_app/ulit/constants.dart';

import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
            padding: EdgeInsets.only(top: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(appName, style: welcomeMain),
                SizedBox(height: 10),
                Text(welcomeSubtitle, style: welcomeSub, maxLines: 2),
                SizedBox(height: 30),
                Container(
                  // width: deviceWidth * 0.85,
                  height: deviceHeight * 0.65,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          'https://image.freepik.com/free-vector/purple-islamic-background-with-mosque_1055-529.jpg',
                    ),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -25.0, 0.0),
                  width: deviceWidth * 0.50,
                  height: 50,
                  child: RaisedButton(
                    elevation: 0,
                    color: Color(0xfff9b090),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    child: Text("Get Started"),
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