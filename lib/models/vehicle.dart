import 'package:flutter/material.dart';

class Vehicle {

  String nameOfTheOwner, typeOfVehicle, vehicleNumber, mobileNumber;

  Vehicle(String nameOfTheOwner, String typeOfVehicle, String vehicleNumber, String mobileNumber) {
    this.nameOfTheOwner = nameOfTheOwner;
    this.typeOfVehicle = typeOfVehicle;
    this.vehicleNumber = vehicleNumber;
    this.mobileNumber = mobileNumber;
  }

  factory Vehicle.fromJson(dynamic json) {
    return Vehicle(json['nameOfTheOwner'] as String, json['typeOfVehicle'] as String, json['vehicleNumber'] as String, json['mobileNumber'] as String);
  }

  static Card makeVehicleCardForCustomers (Vehicle vehicle, [Function callButtonClicked = null]) {
    Card card = Card(
        color: Colors.black26,
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              children: <Widget>[
                Text("${vehicle.nameOfTheOwner}", textAlign: TextAlign.center),
                Text("${vehicle.vehicleNumber}"),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: () => { callButtonClicked(vehicle.mobileNumber)},
                    ),
                    Text("${vehicle.mobileNumber}")
                  ],
                )
              ],
            )
        )
    );
    return card;
  }
}
