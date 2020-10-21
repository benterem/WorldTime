/*
 * Custom WorldTime model
 * 
 * Properties: location, flag, url, isDaytime
 *  
 */

import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; //location name for ui
  String time; //time in that location
  String flag; //url to asset flag icon
  String url; //location url for API endpoin
  bool isDaytime; // day => true

  WorldTime({this.location, this.flag, this.url});

  // gets time property, we are requesting from external server
  // so we use Future (promise), and it is async
  Future<void> getTime() async {
    try {
      //make the request
      Response response =
          await get('https://worldtimeapi.org/api/timezone/$url');
      Map data = json.decode(response.body);

      //get properties from data
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);

      //create datetime obj
      DateTime now = DateTime.parse(datetime);
      //set time property
      now = now.add(Duration(hours: int.parse(offset)));
      isDaytime = now.hour > 6 && now.hour < 19 ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      print('caught error: $e');
      time = 'could not get time data';
    }
  }
}
