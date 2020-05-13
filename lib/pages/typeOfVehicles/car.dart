import 'package:book_karo/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:call_number/call_number.dart';

class Car extends StatefulWidget {
  @override
  _carState createState() => _carState();
}

class _carState extends State<Car> {
  List<Vehicle> vehicles = [];
  dynamic config = Ioc().use('config').config, constants = Ioc().use('constants').constants;
  dynamic event = Ioc().use('event');
  void callButtonClicked(String param) async{
    print(param);
    new CallNumber().callNumber('+91' + param);
  }

  @override
  void initState() {
    super.initState();
    event.sendEvent('car_page');
  }

  @override
  Widget build(BuildContext context) {
    vehicles = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
            title: Text("Cars near you"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: vehicles.length == 0 ?  <Widget>[
              Center( child: Text('There are no cars nearby you')),
            ] : vehicles.map((Vehicle vehicle) { return Vehicle.makeVehicleCardForCustomers(vehicle, this.callButtonClicked);}).toList(),
          ),)
    );
  }
}
