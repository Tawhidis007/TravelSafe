import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as prefix1;
import 'package:location/location.dart' as prefix0;
import 'package:portfolio1/providers/companies.dart';
import 'package:portfolio1/providers/company.dart';
import 'package:portfolio1/screens/bus_screen.dart';
import 'package:portfolio1/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class MyHomePage extends StatefulWidget {
  final String dog = "dog";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Company> companyData;
  var isInit = true;
  var isLoading = false;
  List<Bus> bl = [];

  addbuses() {
    bl.add(Bus(busPlate: 'GDH1011', lat: 23.875854, lng: 90.379540));
    bl.add(Bus(busPlate: 'GDH1012', lat: 23.875853, lng: 90.379541));
    bl.add(Bus(busPlate: 'GDH1013', lat: 23.875853, lng: 90.379543));
    bl.add(Bus(busPlate: 'GDH1014', lat: 23.875852, lng: 90.379544));
    bl.add(Bus(busPlate: 'GDH1015', lat: 23.875851, lng: 90.379545));
    bl.add(Bus(busPlate: 'GDH1016', lat: 23.875855, lng: 90.379546));
    bl.add(Bus(busPlate: 'GDH1017', lat: 23.875857, lng: 90.379548));
    bl.add(Bus(busPlate: 'GDH1018', lat: 23.875856, lng: 90.379547));
  }

  Future<void> getLocation() async {
    var currentLoc = LocationData;
    var location = new Location();
    try {
      currentLoc = await location.getLocation().then((loc) {
        print(loc.speed);
      });
    } catch (error) {
      print(error);
    }
  }

  _getCurrentPosition() async {
    GeolocationStatus geolocationStatus =
    await Geolocator().checkGeolocationPermissionStatus();
    print(geolocationStatus.value.toString());

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: prefix1.LocationAccuracy.high);
    print(position.latitude);

    prefix1.Geolocator()
        .distanceBetween(
        position.latitude, position.longitude, 23.875855, 90.379540)
        .then((meter) {
      print(meter / 1000);
    });

    prefix1.Geolocator().placemarkFromPosition(position).then((val) {
      print(val
          .elementAt(0)
          .subLocality);
    });
  }

  @override
  void initState() {
    //addbuses();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Companies>(context).getdata().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    companyData = Provider
        .of<Companies>(context)
        .companyData;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        elevation: 8,
        title: Text('Available Services',),
      ),
      body: Container(
        color: Colors.white60,
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme
                .of(context)
                .accentColor,
          ),
        )
            : Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CarouselSlider(
                autoPlay: true,
                autoPlayAnimationDuration: Duration(milliseconds: 400),
                pauseAutoPlayOnTouch: Duration(seconds: 3),
                height: 420.0,
                items: companyData.map((comp) {
                  String busCount = comp.buses.length.toString();
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        //padding: EdgeInsets.all(5),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Card(
                          elevation: 6,
                          child: GridTile(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    BusScreen.routeName,
                                    arguments: {
                                      'compName': comp.companyName,
                                      'compBuses': comp.buses
                                    });
                              },
                              child: Image.network(
                                comp.imgurl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            footer: Container(
                              //margin: EdgeInsets.symmetric(vertical: 6,horizontal: 6),
                              height: 100,
                              child: GridTileBar(trailing: IconButton(
                                icon: Icon(Icons.more_vert), onPressed: () {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Something should happen',textAlign: TextAlign.center,),
                                  duration: Duration(seconds: 1),));
                              },),
                                leading: Container(
                                  child: Icon(
                                    Icons.directions_bus,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Container(
                                  child: Text(
                                    'Company Buses : $busCount',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                                title: Container(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      comp.companyName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.amber,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
//                  FlatButton(
//                      child: Text('Click me'),
//                      onPressed: () {
//                        _getCurrentPosition();
            //getLocation();
            //Provider.of<Companies>(context).distanceMatrix();
//                companies.getdata().then((_) {
//                  print(companies.companyData.elementAt(0));
//                 // companyData = companies.companyData;
//                });
            //Provider.of<Companies>(context).setData('Green Line', bl, 'https://i.pinimg.com/736x/05/c7/fd/05c7fd41e3bd7fd9a42d83bdddc7716b.jpg');
//                      })
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
