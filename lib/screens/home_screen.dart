import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
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
    super.initState();
    getLocationData().then((locationData) {
      if (!mounted) {
        return;
      }
      if (locationData != null) {
        loadLocationName(locationData.latitude, locationData.longitude);
      }
    });
  }

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
    setAdreesName(first.locality);
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    // var currntPrayer = PrayerTimes(coordinates, dateComponents, calculationParameters)
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Locale newLocale = Locale('ar', '');
                      MyApp.setLocale(context, newLocale);
                    },
                    child: Text(
                      AppLocalizations.of(context).appName,
                      style: titleTxt,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_pin),
                      Text(
                        addressName,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 30),
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

  void setAdreesName(String value) {
    setState(() {
      addressName = value;
    });
  }
}
