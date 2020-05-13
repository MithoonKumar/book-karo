import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ioc/ioc.dart';
class Event {
  //Todo: create a unique connection to send all events
  //https://pub.dev/packages/http
  final config =  Ioc().use('config').config;
  sendEvent(String screenName, [String actionName, String error]) async {
    try {
      final url = config["BASE_URL"] + config["SEND_EVENT_PATH"];
      final body = { 'screenName': screenName, 'actionName': actionName, 'error': error };
      final response = await http.post(url, body: json.encode(body), headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print(e.toString());
    }

  }

}