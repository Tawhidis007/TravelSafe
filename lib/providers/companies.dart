import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'company.dart';

class Companies with ChangeNotifier {
  List<Company> companyData;

  Future<void> setData(String companyName, List<Bus> b, String imageUrl) async {
    const url = 'https://safetravel-bc03a.firebaseio.com/companies.json';
    final response = await http.post(url,
        body: json.encode({
          'companyName': companyName,
          'imageUrl': imageUrl,
          'buses': b
              .map((bdata) => {
                    'busPlate': bdata.busPlate,
                    'lat': bdata.lat,
                    'lng': bdata.lng,
                  })
              .toList(),
        }));
    notifyListeners();
  }

  Future<void> getdata() async {
    try {
      const url = 'https://safetravel-bc03a.firebaseio.com/companies.json';
      final response = await http.get(url);
      List<Company> loadedCompanyData = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      extractedData.forEach((id, data) {
//      print(id);
//      print(data['companyName']);
        loadedCompanyData.add(Company(
            companyName: data['companyName'],
            imgurl: data['imageUrl'],
            id: id,
            buses: (data['buses'] as List<dynamic>)
                .map((bData) => Bus(
                    busPlate: bData['busPlate'],
                    lng: bData['lng'],
                    lat: bData['lat']))
                .toList()));
      });
      companyData = loadedCompanyData;
      //print(companyData.elementAt(1).buses.elementAt(0).busPlate);
      notifyListeners();
    } catch (error) {
      print('Error getting data');
      throw error;
    }
  }

  Future<void> distanceMatrix() async {
    try {
      const url =
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=23.875856,90.379540&destinations=23.868234299999997,90.3993598&key=AIzaSyASeEC_l4CyE4xSAoZ0-VUDjOEITGs4eOQ";
      final response = await http.get(url);
      print(json.decode(response.body));
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Company getCompanyBusListById(String id) {
    return companyData.firstWhere((cId) => cId.id == id);
  }
}
