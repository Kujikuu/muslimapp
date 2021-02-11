import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:muslimapp/screens/featured_screen.dart';
import 'package:share/share.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeatureDetails extends StatelessWidget {
  final title;
  final img;

  const FeatureDetails({Key key, this.title, this.img}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: CachedNetworkImage(
          imageUrl: this.img,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FlatButton.icon(
          padding: EdgeInsets.all(10),
          textColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          color: Theme.of(context).primaryColorDark,
          onPressed: () {
            Share.share(
                "Muslim App \n${title} \n ${img} \n\n Download Muslim app from https://play.google.com/store/apps/details?id=com.kujiku.muslimapp");
          },
          icon: Icon(Icons.share),
          label: Text(AppLocalizations.of(context).share),
        ),
      ),
    );
  }
}
