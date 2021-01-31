import 'package:adhan/adhan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner(
      {Key key,
      @required this.deviceHeight,
      @required this.deviceWidth,
      @required this.prayerTimes,
      @required nxtPrayerName,
      @required nxtPrayerImg,
      @required prayernxt})
      : _nxtPrayerName = nxtPrayerName,
        _nxtPrayerImg = nxtPrayerImg,
        _prayernxt = prayernxt,
        super(key: key);

  final double deviceHeight;
  final double deviceWidth;
  final PrayerTimes prayerTimes;
  final _nxtPrayerName;
  final _nxtPrayerImg;
  final _prayernxt;

  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  bool isMuted = false;
  @override
  void initState() {
    // loadPrefs();
    super.initState();
  }

  // loadPrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'mute';
  //   final value = prefs.getInt(key) ?? 0;
  //   setState(() {
  //     value == 1 ? isMuted = true : isMuted = false;
  //   });
  // }

  // savePrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'mute';
  //   final value = isMuted ? 0 : 1;
  //   prefs.setInt(key, value);
  //   loadPrefs();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.deviceHeight * .23,
      width: widget.deviceWidth,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient:
              LinearGradient(colors: [Color(0xff5b6afa), Color(0xff87ecfe)])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: widget.deviceWidth * .20,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5)),
                          child: GestureDetector(
                            onTap: () {
                              // savePrefs();
                            },
                            child: Icon(
                                isMuted
                                    ? Icons.notifications
                                    : Icons.notifications_off,
                                color: Colors.white),
                          )),
                      Text(isMuted ? 'Ring' : 'Mute',
                          style: TextStyle(color: Colors.white))
                    ]),
              ),
              SizedBox(height: 20),
              Text('Next Prayer',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
              Text(DateFormat.jm().format(widget._prayernxt),
                  style: TextStyle(color: Colors.white, fontSize: 35)),
              SizedBox(height: 5),
              Text(
                widget._prayernxt.difference(DateTime.now()).inHours > 0
                    ? widget._prayernxt
                            .difference(DateTime.now())
                            .inHours
                            .floor()
                            .toString() +
                        ' hours left untill ' +
                        widget._nxtPrayerName
                    : widget._prayernxt
                            .difference(DateTime.now())
                            .inMinutes
                            .floor()
                            .toString() +
                        ' minutes left untill ' +
                        widget._nxtPrayerName,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Container(
            height: 140,
            // transform: Matrix4.translationValues(0.0, -20.0, 0.0),
            child: CachedNetworkImage(imageUrl: widget._nxtPrayerImg),
          )
        ],
      ),
    );
  }
}
