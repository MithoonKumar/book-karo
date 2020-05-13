import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class VerifyOtpPage extends StatefulWidget {
  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {

  final event = Ioc().use('event');
  final constants = Ioc().use('constants').constants;
  final config = Ioc().use('config').config;
  final myController = TextEditingController();
  String mobileNumber;

  void verifyOtp() async{
    String url = config['BASE_URL']  + "verifyOtp?mobileNumber=" + mobileNumber + "&otp=" + this.myController.text;
    final response = await http.post(url);
    if (response.statusCode == 200) {
      var prefs = await SharedPreferences.getInstance();
      final key = 'AuthToken';
      final value = jsonDecode(response.body)['AuthToken'];
      prefs.setString(key, value);
      prefs.setString("mobileNumber", mobileNumber);
      Navigator.pushNamed(context, '/vehicleOwnerPage');
    } else {
      otpVerificationFailedToast(jsonDecode(response.body)['err'].toString());
    }
  }

  void otpVerificationFailedToast(msg) {
    Toast.show(msg, context, duration: 5, gravity: Toast.CENTER);
  }

  @override
  Widget build(BuildContext context) {
    mobileNumber = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: new AppBar(
        title: Text("Put you otp here")
      ),
      body:  Column(
        children: <Widget>[
          TextField(
            controller: myController,
          ),
          RaisedButton(
            onPressed: () {
              this.verifyOtp();
            },
            child: Text('Submit Otp',
                style: TextStyle(fontSize: 20)
            ),
          )
        ],
      ),
        backgroundColor: Colors.grey,
    );
  }
}
