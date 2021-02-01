import 'package:flutter/material.dart';

class buildFeatures extends StatelessWidget {
  const buildFeatures(this.deviceWidth, this.deviceHeight);

  final double deviceWidth;
  final double deviceHeight;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
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
