import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ioc/ioc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
//refractor this and create 2 separate widget. One for get otp and other to verify otp
//Need to add phone numnber validation. Otp request should not be sent to invalid numbers

class OtpVerificationPage extends StatefulWidget {
  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  String appBarText, buttonText, mobileNumber;
  bool otpRequestSent; dynamic prefs;
  final event = Ioc().use('event');
  final constants = Ioc().use('constants').constants;
  final config = Ioc().use('config').config;
  final myController = TextEditingController();


  @override
  void initState() {
    super.initState();
    this.setInitialValues();
    event.sendEvent("otp_verification_page");
  }

  void setInitialValues() {
    this.appBarText = "Enter your mobile number";
    this.buttonText = "Get Otp";
    this.otpRequestSent = false;
  }

  void getOtp(String mobileNumber) async {
    String url = config['BASE_URL'] + "getOtp?mobileNumber=" + mobileNumber;
    http.get(url);
  }

  void verifyOtp(String mobileNumber, String otp) async {
    String url = config['BASE_URL']  + "verifyOtp?mobileNumber=" + mobileNumber + "&otp=" + otp;
    final response = await http.post(url);
    if (response.statusCode == 200) {
      prefs = await SharedPreferences.getInstance();
      final key = 'AuthToken';
      final value = jsonDecode(response.body)['AuthToken'];
      prefs.setString(key, value);
      prefs.setString("mobileNumber", mobileNumber);
      Navigator.pushReplacementNamed(context, '/vehicleOwnerPage');
    } else {
      otpVerificationFailedToast(jsonDecode(response.body)['err'].toString());
    }
    this.myController.text = "";
  }


  void getAndVerifyOtp() {
    if (!this.otpRequestSent) {
      String number  = this.myController.text;
      this.mobileNumber = number;
      getOtp(number);
      this.myController.text = "";
      this.otpRequestSent = true;
      setState(() {
        this.buttonText = "send otp";
        this.appBarText = "Enter the otp received";
      });
    } else {
      sendRequestToVerifyOtp();
    }
  }

  void otpVerificationFailedToast(msg) {
    Toast.show(msg, context, duration: 5, gravity: Toast.CENTER);
  }

  void changeToSendOtpState() {
    if (!this.otpRequestSent) {
      print(context);
      Navigator.pushReplacementNamed(context, '/decideUser');
    }
    this.otpRequestSent = false;
    setState(() {
      this.buttonText = "Get otp";
      this.appBarText = "Enter your mobile number";
    });
  }

  void sendRequestToVerifyOtp() {
    verifyOtp(this.mobileNumber, this.myController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${this.appBarText}"),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => changeToSendOtpState(),
          )
      ),
      body: Column(
        children: <Widget>[
          TextField(
              controller: myController,
          ),
          RaisedButton(
            onPressed: () {
              this.getAndVerifyOtp();
            },
            child: Text('${this.buttonText}',
                style: TextStyle(fontSize: 20)
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey,
    );
  }
}

