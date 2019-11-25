import 'package:flutter/material.dart';

class Company {
  String id;
  String imgurl;
  String companyName;
  List<Bus> buses;

  Company({this.id,this.imgurl, this.companyName,this.buses});

  @override
  String toString() {
    // TODO: implement toString
    return companyName;
  }
}

class Bus {
  String busPlate;
  double lat;
  double lng;

  Bus({this.busPlate,this.lat,this.lng});
}
