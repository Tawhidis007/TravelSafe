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

  BusTiles(
      {this.busPlate,
      this.lat,
      this.lng,
      this.name});
      //this.locality,
      //this.subLocality});


  @override
  Widget build(BuildContext context) {
    print(name);
    return ListTile(
      subtitle: Text(name,
        style: TextStyle(
          fontSize: 11,
        ),
      ),
      trailing: Container(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FittedBox(child: Text('On Map')),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MapScreen.routeName,
                    arguments: {'lat': lat, 'lng': lng, 'busplate': busPlate});
              },
              tooltip: 'Click to open in map',
              icon: Icon(Icons.location_on,color: Colors.deepOrangeAccent,),
            ),
          ],
        ),
      ),
      title: Text(busPlate),
      leading: CircleAvatar(
        child: Icon(Icons.directions_bus),
      ),
    );
  }
}
