import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mulsim_app/main.dart';
import 'package:mulsim_app/screens/featured_screen.dart';
import 'package:mulsim_app/ulit/constants.dart';
import 'package:mulsim_app/widgets/home_banner.dart';
import 'package:mulsim_app/widgets/home_features.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var addressName;
  final location = new Location();
  var coordinates;

  @override
  void initState() {
    getLocationData().then((locationData) {
      if (!mounted) {
        return;
      }
      if (locationData != null) {
        loadLocationName(locationData.latitude, locationData.longitude);
      }
    });
    setState(() {
      _loading = false;
    });
    super.initState();
  }

  bool _loading = true;
  Future<LocationData> getLocationData() async {
    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  void loadLocationName(double i, double u) async {
    final coordinates = new Coordinates(i, u);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    await setAdreesName(first.locality);
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    // var currntPrayer = PrayerTimes(coordinates, dateComponents, calculationParameters)
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, d MMMM').format(DateTime.now()),
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        HijriCalendar.now().toFormat('dd, MMM yyyy'),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  !_loading
                      ? Row(
                          children: [
                            Icon(Icons.location_pin),
                            Text(
                              addressName,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      : Center(child: CircularProgressIndicator())
                ],
              ),
              SizedBox(height: 10),
              HomeBanner(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context).featured, style: featTxt),
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeaturedScreen())),
                      child: Text(AppLocalizations.of(context).viewall,
                          style: viewAllTxt)),
                ],
              ),
              SizedBox(height: 10),
              Expanded(child: BuildFeatures(deviceWidth, deviceHeight))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setAdreesName(String value) async {
    setState(() {
      _loading = false;
    });
    setState(() {
      addressName = value;
    });
  }
}
