import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:mulsim_app/account/signinemail.dart';
import 'package:mulsim_app/account/signinmobile.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:mulsim_app/settings/settings_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context).signuporlogin),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: Column(
            children: [
              Container(
                height: deviceHeight * .15,
                child: Image.asset(
                  'assets/icon/icon.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: deviceHeight * .02),
              InkWell(
                onTap: signInWithGoogle,
                child: Container(
                  width: deviceWidth * .70,
                  height: deviceHeight * .05,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColorLight),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(FontAwesomeIcons.google),
                      Text('sign in with google'.toUpperCase())
                    ],
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * .02),
              InkWell(
                onTap: () {},
                child: Container(
                  width: deviceWidth * .70,
                  height: deviceHeight * .05,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColorLight),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(FontAwesomeIcons.facebook),
                      Text('sign in with facebook'.toUpperCase())
                    ],
                  ),
                ),
              ),
              // SizedBox(height: deviceHeight * .02),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => SignInWithMobile()));
              //   },
              //   child: Container(
              //     width: deviceWidth * .70,
              //     height: deviceHeight * .05,
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //             color: Theme.of(context).primaryColorLight),
              //         borderRadius: BorderRadius.all(Radius.circular(5))),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         Icon(FontAwesomeIcons.mobile),
              //         Text('use mobile number'.toUpperCase())
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: deviceHeight * .02),
              Divider(),
              SizedBox(height: deviceHeight * .02),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignInWithEmail()));
                },
                child: Container(
                  width: deviceWidth * .70,
                  height: deviceHeight * .05,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColorLight),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(FontAwesomeIcons.solidEnvelope),
                      Text('sign in with email'.toUpperCase())
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 20),
              Expanded(
                  child: Container(
                child: Image.asset('assets/islamic.png'),
              ))
            ],
          ),
        ),
      ),
    );
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    // final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // // Obtain the auth details from the request
    // final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;

    // // Create a new credential
    // final credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    // // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance
    //     .signInWithCredential(credential)
    //     .then((value) => {
    //           Navigator.pushReplacement(context,
    //               MaterialPageRoute(builder: (context) => SettingsOnePage()))
    //         });
  }
}
