import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  var proData;
  var compData;
  String locality;
  Map<String, String> names;
  List<Bus> busList;
  String compName;
  String id;
  var isInit = true;
  var isLoading = false;

  Future<void> _refreshLoc() async {
    await Provider.of<Companies>(context).getdata();
    busList = Provider.of<Companies>(context).getCompanyBusListById(id).buses;
    await Provider.of<LocationWorks>(context).calcName(busList);
    setState(() {
      names = Provider.of<LocationWorks>(context).name;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      proData = Provider.of<LocationWorks>(context);
      compData = Provider.of<Companies>(context);
      final comp =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      id = comp['id'];
      compName = comp['compName'];
      busList = compData.getCompanyBusListById(id).buses;
      proData.calcName(busList).then((_) {
        setState(() {
          names = proData.name;
        });
      });
      setState(() {
        isLoading = false;
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: SpinKitFadingFour(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? Colors.deepOrange : Colors.amber,
                  ),
                );
              },
            ),
          )
        : Scaffold(
            body: LiquidPullToRefresh(
              springAnimationDurationInMilliseconds: 600,
              showChildOpacityTransition: false,
              height: 80,
              color: Colors.amber,
              backgroundColor: Colors.white,
              onRefresh: () => _refreshLoc(),
              child: ListView.builder(
                itemBuilder: (_, i) => Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: BusTiles(
                    busPlate: busList.elementAt(i).busPlate,
                    lat: busList.elementAt(i).lat,
                    lng: busList.elementAt(i).lng,
                    name: names[busList.elementAt(i).busPlate],
                  ),
                ),
                itemCount: busList.length,
              ),
            ),
            appBar: AppBar(
              actions: <Widget>[],
              title: Text(compName),
            ),
          );
  }
}
