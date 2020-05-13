import 'package:book_karo/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ioc/ioc.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Customer extends StatefulWidget {
  @override
  _CustomerState createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  dynamic prefs, event = Ioc().use('event');
  dynamic config = Ioc().use('config').config, constants = Ioc().use('constants').constants;
  List<Vehicle> vehicles = [];
  List<Vehicle> cars = [], tempos = [], miniTrucks = [], trucks = [];
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
    this.getVehiclesNearby();
    event.sendEvent('customer_page');
  }


  getVehiclesNearby() async {
    prefs = await SharedPreferences.getInstance();
    String latlong = prefs.getString(constants['LAT_LON']);
    String url = config['BASE_URL'] + "getVehiclesNearby?latlong=" + latlong + "&nameOfIndex=car" + "&size=100";
    final response = await http.get(url, headers: {"AuthToken": prefs.getString("AuthToken")});
    setState(() {
      try {
        Iterable l = json.decode(response.body);
        vehicles = l.map((dynamic vehicle)=> Vehicle.fromJson(vehicle)).toList();
        filterVehiclesByType();
      } catch (e) {
        print(e);
      }
    });
  }

  filterVehiclesByType() {
    for (int index = 0 ; index < vehicles.length ; index++) {
      Vehicle tempVehicle = vehicles[index];
      if (tempVehicle.typeOfVehicle == "car") {
        cars.add(tempVehicle);
      } else if (tempVehicle.typeOfVehicle == "tempo") {
        tempos.add(tempVehicle);
      } else if (tempVehicle.typeOfVehicle == "mini_truck") {
        miniTrucks.add(tempVehicle);
      } else if (tempVehicle.typeOfVehicle == "truck") {
        trucks.add(tempVehicle);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicles near you"),
      ),
      body: SingleChildScrollView(
        child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(2),
                        child: Image(image: AssetImage('images/car.png'))
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/car', arguments: cars)
                  )
              ),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(2),
                        child: Image(image: AssetImage('images/tempo.png'))
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/tempo', arguments: tempos)
                  )
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(2),
                        child: Image(image: AssetImage('images/miniTruck.png'))
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/miniTruck', arguments: miniTrucks)
                  )
              ),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(2),
                        child: Image(image: AssetImage('images/truck.png'))
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/truck', arguments: trucks)
                  )
              )
            ],
          )
        ],
      ),

    )
    );
  }
}
