import 'dart:convert';

import 'package:book_karo/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VehicleOwner extends StatefulWidget {
  @override
  _VehicleOwnerState createState() => _VehicleOwnerState();
}

class _VehicleOwnerState extends State<VehicleOwner> {
  dynamic prefs, event = Ioc().use('event');
  dynamic config = Ioc().use('config').config;
  List<Vehicle> vehicles = [];
  Card makeVehicleCard(Vehicle vehicle) {
    Card card = Card(
        color: Colors.black26,
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              children: <Widget>[
                Text("${vehicle.nameOfTheOwner}", textAlign: TextAlign.center),
                Text("${vehicle.typeOfVehicle}", textAlign: TextAlign.left,),
                Text("${vehicle.vehicleNumber}"),
                Text("${vehicle.mobileNumber}"),
              ],
            )
        )
    );
    return card;
  }

  @override
  void initState() {
    super.initState();
    this.getOwnVechicles();
    event.sendEvent('vehicle_owner_page');
  }

  getOwnVechicles() async {
    prefs = await SharedPreferences.getInstance();
    String mobileNumber = prefs.getString("mobileNumber");
    String url = config['BASE_URL'] + "getOwnVehicles?mobileNumber=" + mobileNumber;
    final response = await http.get(url, headers: {"AuthToken": prefs.getString("AuthToken")});
    setState(() {
      try {
        Iterable l = json.decode(response.body);
        vehicles = l.map((dynamic vehicle) => Vehicle.fromJson(vehicle)).toList();
      } catch (e) {
        print(e);
      }
    });
  }

  addVehiclesToList(Vehicle vehicle) {
    setState(() {
      vehicles.add(vehicle);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Your Vehicles"),
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/decideUser'))
            )
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: vehicles.map((Vehicle vehicle) { return this.makeVehicleCard(vehicle);}).toList(),
          ),),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed('/addVehicle', arguments: addVehiclesToList);
          },
          label: Text("Add a vehicle"),
          icon: Icon(Icons.add),
          backgroundColor: Colors.green
        ),
    );
  }
}
