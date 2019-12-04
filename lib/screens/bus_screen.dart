import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portfolio1/providers/companies.dart';
import 'package:portfolio1/providers/company.dart';
import 'package:portfolio1/providers/location_work.dart';
import 'package:portfolio1/widgets/bus_tiles.dart';
import 'package:provider/provider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
class BusScreen extends StatefulWidget {
  static const routeName = '/bus-screen';

//  String companyName;
//
//  BusScreen(this.companyName);

  @override
  _BusScreenState createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  int count=  0;
  String locality;
  Map<String, String> names;
  List<Bus> busList;
  String compName;
  String id;
  //Map<String, String> subLocalities = {};


  Future<void> _refreshLoc() async {
    await Provider.of<Companies>(context).getdata();
    busList = Provider.of<Companies>(context).getCompanyBusListById(id).buses;
    await Provider.of<LocationWorks>(context).calcName(busList);
    setState(() {
      names = Provider.of<LocationWorks>(context).name;
    });
  }


  Future<String> getLocality(lat,lng) async{
    await Geolocator().placemarkFromPosition(Position(latitude: lat,longitude: lng)).then((val){
      locality = val.elementAt(0).locality;
    });
  }

  @override
  void initState() {
    count++;
    print('rebuilt $count');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var proData = Provider.of<LocationWorks>(context);
    var compData = Provider.of<Companies>(context);
    final comp =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    id = comp['id'];
    compName = comp['compName'];
    busList = compData.getCompanyBusListById(id).buses;
    proData.calcName(busList).then((val){
      setState(() {
        names = proData.name;
      });
    });
    //proData.calcSubLoc(busList);
    //subLocalities = proData.subLocality;
    return Scaffold(
      body: LiquidPullToRefresh(
        springAnimationDurationInMilliseconds: 600,
        showChildOpacityTransition: false,
        height: 80,
        color: Colors.amber,
        backgroundColor: Colors.white,
        onRefresh: ()=>_refreshLoc(),
        child: ListView.builder(
          itemBuilder: (_, i) => Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: BusTiles(
              busPlate: busList.elementAt(i).busPlate,
              lat: busList.elementAt(i).lat,
              lng: busList.elementAt(i).lng,
              name:names[busList.elementAt(i).busPlate],
            ),
          ),
          itemCount: busList.length,
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
        ],
        title: Text(comp['compName']),
      ),
    );
  }
}
