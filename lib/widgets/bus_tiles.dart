import 'package:flutter/material.dart';

//import 'package:portfolio1/providers/company.dart';
import 'package:portfolio1/screens/map_screen.dart';

class BusTiles extends StatelessWidget {
  String busPlate;
  double lat;
  double lng;
  String name;
  String subLocality;

  //String locality;

  BusTiles({this.busPlate, this.lat, this.lng, this.name});

  //this.locality,
  //this.subLocality});

  @override
  Widget build(BuildContext context) {
    print(name);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      subtitle: Text(
        name,
        style: TextStyle(
          fontSize: 11,
        ),
      ),
      trailing: FlatButton(
          child: Text(
            'on Map',
            style: TextStyle(color: Colors.deepPurple),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(MapScreen.routeName,
                arguments: {'lat': lat, 'lng': lng, 'busplate': busPlate});
          },
          padding: EdgeInsets.all(0)),
      title: Text(busPlate),
      leading: CircleAvatar(
        child: Icon(Icons.directions_bus),
      ),
    );
  }
}
