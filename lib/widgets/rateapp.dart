import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:launch_review/launch_review.dart';
import 'package:nb_utils/nb_utils.dart';

class RateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      child: Container(
        height: 300,
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(FontAwesomeIcons.solidStar,
                size: 30, color: Colors.orangeAccent),
            10.height,
            Text(
              AppLocalizations.of(context).rateapp,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Expanded(
              child: Text(
                AppLocalizations.of(context).ratesub,
                textAlign: TextAlign.center,
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context).nothanks)),
                OutlineButton(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    shape: StadiumBorder(),
                    child: Text(AppLocalizations.of(context).ok),
                    onPressed: () {
                      LaunchReview.launch(
                          androidAppId: "com.kujiku.muslimapp",
                          iOSAppId: "585027354",
                          writeReview: false);
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
