import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mulsim_app/settings/settings_screen.dart';
import 'package:connectivity/connectivity.dart';

class SignInWithEmail extends StatefulWidget {
  @override
  _SignInWithEmailState createState() => _SignInWithEmailState();
}

class _SignInWithEmailState extends State<SignInWithEmail> {
  TextEditingController _name = TextEditingController();
  TextEditingController _mail = TextEditingController();
  TextEditingController _pass = TextEditingController();
  var _key = GlobalKey<FormState>();
  bool _autoValidation = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _mail.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).signuporlogin),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidate: _autoValidation,
          key: _key,
          child: Column(
            children: [
              SizedBox(height: 40),
              Container(
                width: MediaQuery.of(context).size.width * 80,
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                alignment: Alignment.center,
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
                        child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'FullName is required';
                        return null;
                      },
                      controller: _name,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
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
                padding: EdgeInsets.only(left: 0.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                      child: Icon(Icons.alternate_email),
                    ),
                    Expanded(
                        child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Email is required';
                        return null;
                      },
                      controller: _mail,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'ahmed@kujiku.net',
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 80,
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 0.0, right: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                      child: Icon(Icons.lock),
                    ),
                    Expanded(
                        child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'Password is required';
                        return null;
                      },
                      controller: _pass,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        // border: InputBorder.none,
                        hintText: '*************',
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: 300,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: _onRegisterClick,
                  child: Text(
                    "Log In",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onRegisterClick() async {
    bool isExist = false;
    if (_mail.text != null && _key.currentState.validate()) {
      try {
        var result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _mail.text, password: '778899');
      } catch (e) {
        if (e is PlatformException) {
          if (e.code != "ERROR_EMAIL_ALREADY_IN_USE" &&
              e.code != "ERROR_WRONG_PASSWORD")
            isExist = false;
          else
            isExist = true;
        }
      }
      check().then((internet) async {
        if (internet != null && internet) {
          if (isExist == true) {
            var result = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _mail.text, password: _pass.text)
                .then((value) => {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsOnePage()))
                    });
          } else {
            var result = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _mail.text, password: _pass.text)
                .then((value) => {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsOnePage()))
                    });
          }
        } else {
          final snackBar = SnackBar(
              content: Text('Please check if there internet available.'));
          Scaffold.of(context).showSnackBar(snackBar);
        }
      });
    }
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
