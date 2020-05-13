import 'package:book_karo/models/vehicle.dart';
import 'package:call_number/call_number.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';

class Tempo extends StatefulWidget {
  @override
  _tempoState createState() => _tempoState();
}

class _tempoState extends State<Tempo> {

  List<Vehicle> vehicles = [];
  dynamic event = Ioc().use('event');

  @override
  void initState() {
    super.initState();
    event.sendEvent("tempo_page");
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
            title: Text("Tempos near you"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: vehicles.length == 0 ?  <Widget>[
              Center( child: Text('There are no tempos nearby you')),
            ] : vehicles.map((Vehicle vehicle) { return Vehicle.makeVehicleCardForCustomers(vehicle, this.callButtonClicked);}).toList(),
          ),)
    );
  }
}
