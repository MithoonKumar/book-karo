import 'package:book_karo/iocLocator/iocLocator.dart';
import 'package:book_karo/pages/getOtpPage.dart';
import 'package:book_karo/pages/typeOfVehicles/miniTruck.dart';
import 'package:book_karo/pages/typeOfVehicles/tempo.dart';
import 'package:book_karo/pages/verifyOtpPage.dart';
import 'package:flutter/material.dart';
import 'package:book_karo/pages/requestPermission.dart';
import 'package:book_karo/pages/otpVerificationPage.dart';
import 'package:book_karo/pages/customer.dart';
import 'package:book_karo/pages/decideUser.dart';
import 'package:book_karo/pages/vehicleOwner.dart';
import 'package:book_karo/pages/addVehicle.dart';
import 'package:book_karo/pages/typeOfVehicles/car.dart';
import 'package:book_karo/pages/typeOfVehicles/truck.dart';

void main() {
  iocLocator();
  runApp( new MaterialApp(
    routes: {
      '/' : (context) => RequestPermission(),
      '/getOtpPage' : (context) => GetOtpPage(),
      '/verifyOtpPage' : (context) => VerifyOtpPage(),
      '/otpVerificationPage' : (context) => OtpVerificationPage(),
      '/decideUser': (context) => DecideUser(),
      '/customerPage' : (context) => Customer(),
      '/vehicleOwnerPage': (context) => VehicleOwner(),
      '/addVehicle' : (context) => AddVehicle(),
      '/car': (context) => Car(),
      '/tempo': (context) => Tempo(),
      '/miniTruck': (context) => MiniTruck(),
      '/truck': (context) => Truck()
    },));
}