import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeaturedScreen extends StatefulWidget {
  @override
  _FeaturedScreenState createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(AppLocalizations.of(context).featured),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: _buildBody(context),
        )));
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('features')
        .orderBy('date', descending: true)
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
  final deviceHeight = MediaQuery.of(context).size.height;
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
          borderRadius: BorderRadius.circular(10)),
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
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$content>";
}
