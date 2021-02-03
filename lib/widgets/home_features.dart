import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    stream: Firestore.instance
        .collection('features')
        .orderBy('date', descending: true)
        .limit(3)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

      return _buildList(context, snapshot.data.documents);
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
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      width: deviceWidth,
      // height: deviceHeight * 0.25,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: deviceWidth * 0.45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  height: 30,
                  imageUrl:
                      'https://images-na.ssl-images-amazon.com/images/I/41APHvabE0L.png',
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.of,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      record.name,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(record.content, style: TextStyle(color: Colors.white)),
          // SizedBox(height: 5),
          Divider(color: Colors.white),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton.icon(
                  minWidth: deviceWidth / 2.6,
                  onPressed: () async {},
                  textColor: Colors.white,
                  icon: Icon(Icons.read_more),
                  label: Text(AppLocalizations.of(context).read)),
              FlatButton.icon(
                  minWidth: deviceWidth / 2.6,
                  onPressed: () {},
                  textColor: Colors.white,
                  icon: Icon(Icons.share),
                  label: Text(AppLocalizations.of(context).share)),
            ],
          )
        ],
      ),
    ),
  );
}

class Record {
  final String name;
  final String content;
  final String of;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['content'] != null),
        assert(map['of'] != null),
        name = map['name'],
        content = map['content'],
        of = map['of'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$content>";
}
/*
Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        width: deviceWidth,
        height: deviceHeight * 0.25,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: deviceWidth * 0.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CachedNetworkImage(
                    height: 30,
                    imageUrl:
                        'https://images-na.ssl-images-amazon.com/images/I/41APHvabE0L.png',
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verse of the day',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Al-Jumu`a',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text(
                'But never will they express their desire ( for Death), beacause of th (deeds) their hands have sent on before them! and Allah knows well those that do wrong!',
                style: TextStyle(color: Colors.white)),
            // SizedBox(height: 5),
            Divider(color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton.icon(
                    minWidth: deviceWidth / 2.6,
                    onPressed: () async {},
                    textColor: Colors.white,
                    icon: Icon(Icons.read_more),
                    label: Text('Read')),
                FlatButton.icon(
                    minWidth: deviceWidth / 2.6,
                    onPressed: () {},
                    textColor: Colors.white,
                    icon: Icon(Icons.share),
                    label: Text('Share')),
              ],
            )
          ],
        ),
      ),
    )
*/
