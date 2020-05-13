import 'dart:convert';
import 'dart:io';

import 'package:book_karo/models/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class AddVehicle extends StatefulWidget {
  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final _formKey = GlobalKey<FormState>();
  var ownerNameKey = GlobalKey<FormFieldState>();
  var vehicleNumberKey = GlobalKey<FormFieldState>();
  String typeOfVehicle = null;
  dynamic constants = Ioc().use('constants').constants,
      config = Ioc().use('config').config,
      eventImpl = Ioc().use('event');

  void addVehicleDetails() async {
    var prefs = await SharedPreferences.getInstance();
    String nameOfTheOwner = ownerNameKey.currentState.value.toString();
    String vehicleNumber = vehicleNumberKey.currentState.value.toString();
    String mobileNumber = prefs.get("mobileNumber");
    String latlong = prefs.get("latlong");
    String authToken = prefs.get("AuthToken");
    String url = config["BASE_URL"]+ "updateVehicleDetails";
    await http.post(url,
        body: json.encode({
          'nameOfTheOwner': nameOfTheOwner,
          'vehicleNumber': vehicleNumber,
          'mobileNumber': mobileNumber,
          'location': latlong,
          'typeOfVehicle': typeOfVehicle
        }),
        headers: {
          'AuthToken': authToken,
          HttpHeaders.contentTypeHeader: 'application/json'
        });
    Vehicle vehicle =
        Vehicle(nameOfTheOwner, typeOfVehicle, vehicleNumber, mobileNumber);
    Function addVehiclesToList = ModalRoute.of(context).settings.arguments;
    addVehiclesToList(vehicle);
    Navigator.pop(context);
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  void initState() {
    super.initState();
    eventImpl.sendEvent('add_vehicle_page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Add vehicle details"),
      ),
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text("Enter the name of the owner"),
                TextFormField(
                  // Owner's Name
                  key: ownerNameKey,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter the name of Vehicle owner";
                    }
                    return null;
                  },
                ),
                Text("Enter Vehicle's Number"),
                TextFormField(
                  // vehicle's Number
                  key: vehicleNumberKey,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter the vehicle number";
                    }
                    return null;
                  },
                ),
                Text("Choose the type of your vehicle"),
                ListTile(
                  title: const Text('Car'),
                  leading: Radio(
                    value: "car",
                    groupValue: typeOfVehicle,
                    onChanged: (String value) {
                      setState(() {
                        this.typeOfVehicle = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Tempo'),
                  leading: Radio(
                    value: "tempo",
                    groupValue: typeOfVehicle,
                    onChanged: (String value) {
                      setState(() {
                        this.typeOfVehicle = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Mini Truck'),
                  leading: Radio(
                    value: "mini_truck",
                    groupValue: typeOfVehicle,
                    onChanged: (String value) {
                      setState(() {
                        this.typeOfVehicle = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Truck'),
                  leading: Radio(
                    value: "truck",
                    groupValue: typeOfVehicle,
                    onChanged: (String value) {
                      setState(() {
                        this.typeOfVehicle = value;
                      });
                    },
                  ),
                ),
                Container(
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate() &&
                          this.typeOfVehicle != null) {
                        this.addVehicleDetails();
                      } else {
                        this.showToast(
                            "Add vehicleNumber or vehicle owners name or choose the type of vehicle",
                            gravity: Toast.BOTTOM,
                            duration: 5);
                      }
                    },
                    child: Text("Submit"),
                  ),
                )
              ],
            ),
      )),
    );
  }
}
