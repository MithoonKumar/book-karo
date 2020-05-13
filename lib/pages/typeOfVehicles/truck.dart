import 'package:book_karo/models/vehicle.dart';
import 'package:call_number/call_number.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';

class Truck extends StatefulWidget {
  @override
  _truckState createState() => _truckState();
}

class _truckState extends State<Truck> {

  List<Vehicle> vehicles = [];
  dynamic event = Ioc().use('event');
  @override
  void initState() {
    super.initState();
    event.sendEvent("truck_page");
  }

  void callButtonClicked(String param) {
    print(param);
    new CallNumber().callNumber('+91' + param);
  }

  @override
  Widget build(BuildContext context) {
    vehicles = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
            title: Text("Trucks near you"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: vehicles.length == 0 ?  <Widget>[
              Center( child: Text('There are no trucks nearby you')),
            ] : vehicles.map((Vehicle vehicle) { return Vehicle.makeVehicleCardForCustomers(vehicle, this.callButtonClicked);}).toList(),
          ),)
    );
  }
}
