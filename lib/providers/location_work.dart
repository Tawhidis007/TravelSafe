import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:portfolio1/providers/company.dart';

class LocationWorks with ChangeNotifier {
  double lat;
  double lng;
  List<Bus> busList;
  Map<String, String> name = {};
  Map<String, String> subLocality = {};

  Future<Position> getMyLoc() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    lng = position.longitude;
    notifyListeners();
    return position;
  }

  Future<void> calcName(List<Bus> buslist) async {
    //name = {};
    buslist.forEach((e) async {
      await Geolocator()
          .placemarkFromPosition(Position(latitude: e.lat, longitude: e.lng))
          .then((val) {
            if(name.containsKey(e.busPlate)){
              name.update(e.busPlate, (existingItem)=>val.elementAt(0).name);
            }else{
              name.putIfAbsent(e.busPlate,()=>val.elementAt(0).name);
            }
            //print(localities[e.busPlate]);
      });
     // notifyListeners();
    });

  }
  Future<void> calcSubLoc(List<Bus> buslist) async {
    //subLocality = {};
    buslist.forEach((e) async {
      await Geolocator()
          .placemarkFromPosition(Position(latitude: e.lat, longitude: e.lng))
          .then((val) {
        subLocality.putIfAbsent(e.busPlate,()=>val.elementAt(0).subLocality);
        //print(subLocality[e.busPlate]);
      });
    });
  }

  void clean(){
    subLocality = {};
    name = {};
  }
}
