import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portfolio1/providers/location_work.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;
  bool diffMap = false;

  LatLng thisBusLoc;
  Position myPosition = Position(latitude: 0, longitude: 0);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    moveCamToBusLoc();
  }

  void moveCamToBusLoc() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: thisBusLoc, zoom: 17.15192604064941)));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationWorks>(context).getMyLoc().then((val) {
      myPosition = Position(latitude: val.latitude, longitude: val.longitude);
    });
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    double lat = data['lat'];
    double lng = data['lng'];
    String busPlate = data['busplate'];
    thisBusLoc = LatLng(lat, lng);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          toolbarOpacity: .8,
          centerTitle: true,
          title: Text('Locating $busPlate'),
          backgroundColor: Colors.green[700],
        ),
        body: diffMap
            ? GoogleMap(
                mapType: MapType.normal,
                markers: {
                  Marker(
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                      markerId: MarkerId('bus'),
                      infoWindow: InfoWindow(title: busPlate,snippet: 'This is your Bus'),
                      onTap: () {},
                      position: thisBusLoc),
                  Marker(
                    visible: true,
                    markerId: MarkerId('you'),
                    position: LatLng(myPosition.latitude, myPosition.longitude),
                    onTap: () {},
                    infoWindow: InfoWindow(title: 'You',snippet: 'You are here.'),
                  )
                },
                trafficEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: thisBusLoc,
                  zoom: 11.0,
                ),
              )
            : GoogleMap(
                mapType: MapType.hybrid,
                markers: {
                  Marker(
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                      markerId: MarkerId('Bus'),
                      infoWindow: InfoWindow(title: busPlate,snippet: 'This is your Bus'),
                      onTap: () {},
                      position: thisBusLoc),
                  Marker(
                    visible: true,
                    markerId: MarkerId('you'),
                    position: LatLng(myPosition.latitude, myPosition.longitude),
                    onTap: () {},
                      infoWindow: InfoWindow(title: 'You',snippet: 'You are here.'),
                  )
                },
                trafficEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: thisBusLoc,
                  zoom: 11.0,
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Switch View'),
          onPressed: () {
            print(busPlate);
            print(thisBusLoc.latitude);
            print(thisBusLoc.longitude);
            setState(() {
              diffMap = !diffMap;
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
