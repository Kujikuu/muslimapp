import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

import 'loading_indicator.dart';
import 'qebla_maps.dart';
import 'qiblah_compass.dart';

class QeblaScreen extends StatefulWidget {
  @override
  _QeblaScreenState createState() => _QeblaScreenState();
}

class _QeblaScreenState extends State<QeblaScreen> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _deviceSupport,
        builder: (_, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return LoadingIndicator();
          if (snapshot.hasError)
            return Center(
              child: Text("Error: ${snapshot.error.toString()}"),
            );

          if (snapshot.data)
            return QiblahCompass();
          else
            return QiblahMaps();
        },
      ),
    );
  }
}
