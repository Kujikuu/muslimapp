import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muslimapp/screens/feature_details.dart';
import 'package:share/share.dart';

class BuildFeatures extends StatelessWidget {
  const BuildFeatures(this.deviceWidth, this.deviceHeight);

  final double deviceWidth;
  final double deviceHeight;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('features')
        .orderBy('date', descending: true)
        .limit(3)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

      return _buildList(context, snapshot.data.docs);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  // final deviceHeight = MediaQuery.of(context).size.height;
  final deviceWidth = MediaQuery.of(context).size.width;
  final record = Record.fromSnapshot(data);
  return Card(
    elevation: 3,
    // margin: EdgeInsets.only(bottom: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: EdgeInsets.only(top: 15, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                record.of.contains("Verse")
                    ? 'assets/quran.png'
                    : 'assets/hadith.jpg',
                height: 30,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.of.contains("Verse")
                        ? AppLocalizations.of(context).verse
                        : AppLocalizations.of(context).aya,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Divider(),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FeatureDetails(
                          img: record.content, title: record.of)));
            },
            child: CachedNetworkImage(
              imageUrl: record.content,
              fit: BoxFit.cover,
              width: deviceWidth,
            ),
          ),
          Divider(),
          FlatButton.icon(
              minWidth: deviceWidth / 2.6,
              onPressed: () async {
                Share.share(
                    "Muslim App \n${record.of} \n ${record.content} \n\n Download Muslim app from https://play.google.com/store/apps/details?id=com.kujiku.muslimapp");
              },
              icon: Icon(Icons.share),
              label: Text(AppLocalizations.of(context).share))
        ],
      ),
    ),
  );
}

class Record {
  final String content;
  final String of;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['content'] != null),
        assert(map['of'] != null),
        content = map['content'],
        of = map['of'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$content>";
}
