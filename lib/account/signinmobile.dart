import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInWithMobile extends StatefulWidget {
  @override
  _SignInWithMobileState createState() => _SignInWithMobileState();
}

class _SignInWithMobileState extends State<SignInWithMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).signuporlogin),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width * 80,
              margin: EdgeInsets.only(left: 40.0, right: 40.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.5, style: BorderStyle.solid)),
              ),
              padding: EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                    child: Icon(FontAwesomeIcons.userAlt),
                  ),
                  Expanded(
                      child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Ahmed AbdAllah',
                    ),
                  ))
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 80,
              margin: EdgeInsets.only(left: 40.0, right: 40.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.5, style: BorderStyle.solid)),
              ),
              padding: EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                    child: Icon(Icons.phone),
                  ),
                  Expanded(
                      child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0123456789',
                    ),
                  ))
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: 300,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {},
                child: Text(
                  "Next",
                  // style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
