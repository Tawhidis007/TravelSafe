import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portfolio1/providers/location_work.dart';
import 'package:portfolio1/widgets/my_form.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:provider/provider.dart';

class ContactTiles extends StatelessWidget {
  String message;
  String myLocName;
  String myLocSubloc;
  LatLng myLatLng;
  List<String> recipents = [];
  final bool editOn;
  final String id;
  final String name;
  final String relation;
  final String phoneNumber;

  ContactTiles({
    this.editOn,
    this.id,
    this.name,
    this.relation,
    this.phoneNumber,
  });

  Future<void> _sendSMS(String message, List<String> recipents) async {
    String _result =
        await FlutterSms.sendSMS(message: message, recipients: recipents)
            .then((val) {})
            .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  @override
  Widget build(BuildContext context) {
    var locData = Provider.of<LocationWorks>(context);
    double c_width = MediaQuery.of(context).size.width * 0.4;
    return Card(
      elevation: 4,
      //margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: editOn
            ? ListTile(
                //contentPadding: EdgeInsets.symmetric(horizontal: 10),
                subtitle: Text(relation),
                leading: CircleAvatar(
                  child: Icon(Icons.person_pin),
                ),
                trailing: Container(
                  width: c_width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(MyForm.routeName, arguments: id);
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {},
                        color: Theme.of(context).errorColor,
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
                title: Text(name),
              )
            : ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                subtitle: Text(relation),
                leading: CircleAvatar(
                  child: Icon(Icons.person_pin),
                ),
                trailing: Container(
                  width: c_width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.notifications),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          locData.getMyLoc().then((val) {
                            myLatLng = locData.getMyLatLng();
                            locData
                                .calMyLocNameAndSubLocality(
                                    myLatLng.latitude, myLatLng.longitude)
                                .then((val) {
                              myLocName = locData.getMyLocName();
                              myLocSubloc = locData.getMyLocSubLocality();
                              message =
                                  'I am currently located at ${myLocName},${myLocSubloc}. Please reach out for me.';
                              recipents.add(phoneNumber);
                              _sendSMS(message, recipents).then((val) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Success!'),
                                ));
                              }).catchError((error) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Operation Failed!'),
                                ));
                              });
                              recipents = [];
                            });
                          });
                        },
                      )
                    ],
                  ),
                ),
                title: Text(name),
              ),
      ),
    );
  }
}
