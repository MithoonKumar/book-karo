import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DecideUser extends StatefulWidget {
  @override
  _DecideUserState createState() => _DecideUserState();
}

class _DecideUserState extends State<DecideUser> {
  String userCategory; bool isSharedPrefLoaded = false;
  final event = Ioc().use('event');
  dynamic prefs;
  String buttonText = "Next";
  void saveInUserPref(value) async {
    if (!isSharedPrefLoaded) {
      prefs = await SharedPreferences.getInstance();
      isSharedPrefLoaded = true;
    }
    prefs.setString("userRole", value);
  }




  void takeToNextPage() async {
    String navigationPage;
    if (prefs.getString("userRole") == "customer") {
      navigationPage = "/customerPage";
    } else {
      if (prefs.get("AuthToken") != null) {
        navigationPage = "/vehicleOwnerPage";
      } else {
        navigationPage = "/getOtpPage";
      }
    }
    Navigator.pushNamed(context, navigationPage);
  }

  @override
  void initState() {
    super.initState();
    event.sendEvent("decide_user_page");
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Are you a customer or a vehicle owner"),
      ),
      body: Container (
            child: Column(
              children: <Widget>[
                ListTile(
                  title: const Text('Customer'),
                  leading: Radio(
                    value: "customer",
                    groupValue: userCategory,
                    onChanged: (String value) {
                      setState(() { userCategory = value; });
                      saveInUserPref(value);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Vehicle Owner'),
                  leading: Radio(
                    value: "owner",
                    groupValue: userCategory,
                    onChanged: (String value) {
                      setState(() { userCategory = value; });
                      saveInUserPref(value);
                    },
                  ),
                ),
                RaisedButton(
                  onPressed: () async{
                    takeToNextPage();
                  },
                  child: Text('${this.buttonText}',
                      style: TextStyle(fontSize: 20)
                  ),
                )
              ],
        )
      )
    );
  }
}
