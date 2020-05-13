import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestPermission extends StatefulWidget {
  @override
  _RequestPermissionState createState() => _RequestPermissionState();
}

class _RequestPermissionState extends State<RequestPermission> {

  Location location = Location();
  dynamic prefs;
  final constants =  Ioc().use('constants').constants;
  final eventImpl = Ioc().use('event');
  void getTheLocation() async {
    try {
      var imei = await DeviceId.getID;
      print(imei);
      prefs = await SharedPreferences.getInstance();
      LocationData locationData = await location.getLocation();
      prefs.setString(constants["LAT_LON"], locationData.latitude.toString() + "," + locationData.longitude.toString());
      Navigator.pushReplacementNamed(context, '/decideUser', arguments: {
        constants["LAT"]: locationData.latitude.toString(),
        constants["LON"]: locationData.longitude.toString()
      });
    } catch (e) {
      print("error" + e.toString() );
      eventImpl.sendEvent(constants["ERROR_EVENT"], null, e.toString());
    }

  }

  void getLocationAndSendEvent() async {
    await getTheLocation();
    eventImpl.sendEvent(constants["REQUEST_VERIFICATION_PAGE"], null, null);
  }

  @override
  void initState() {
    super.initState();
    getLocationAndSendEvent();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Book Karo'),
      ),
    );
  }
}
