import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:http/http.dart' as http;

class GetOtpPage extends StatefulWidget {
  @override
  _GetOtpPageState createState() => _GetOtpPageState();
}

class _GetOtpPageState extends State<GetOtpPage> {

  final event = Ioc().use('event');
  final constants = Ioc().use('constants').constants;
  final config = Ioc().use('config').config;
  final myController = TextEditingController();

  void getOtp() {
    String url = config['BASE_URL'] + "getOtp?mobileNumber=" + this.myController.text;
    http.get(url);
    Navigator.pushNamed(context, '/verifyOtpPage', arguments: this.myController.text);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Put Your mobile number")
      ),
      body:  Column(
        children: <Widget>[
          TextField(
            controller: myController,
          ),
          RaisedButton(
            onPressed: () {
              this.getOtp();
            },
            child: Text('Get Otp',
                style: TextStyle(fontSize: 20)
            ),
          )
        ],
      ),
        backgroundColor: Colors.grey,
    );
  }
}
