import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class InfoDialog extends StatefulWidget {
  String driverId;

  InfoDialog(String qrInfo) {
    driverId = qrInfo;
  }

  @override
  _InfoDialogState createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  String name;
  String license_validity;
  String busPlate;
  String imgUrl;
  bool isLoading = false;
  var isInit = true;

  Future<void> setDriver() async {
    try {
      final url = 'https://safetravel-bc03a.firebaseio.com/drivers.json';
      final response = await http.post(url,
          body: json.encode({
            'name': 'Sharif Ahmed',
            'license validity': '2022',
            'busplate': 'sho1010',
            'imgUrl':
                'https://pbs.twimg.com/profile_images/661487565648760832/r4N2AzTX.jpg',
          }));
      print(json.decode(response.body));
    } catch (error) {
      print(error);
    }
  }

  Future<void> getInfo() async {
    try {
      final url =
          'https://safetravel-bc03a.firebaseio.com/drivers/${widget.driverId}.json';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      if (extractedData == null) {
        return;
      }
      name = extractedData['name'];
      license_validity = extractedData['license validity'];
      busPlate = extractedData['busplate'];
      imgUrl = extractedData['imgUrl'];
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      getInfo().then((_) {
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
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .8,
                  width: MediaQuery.of(context).size.width * .8,
                  child: Card(
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Image.network(
                              imgUrl,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 4),
                              width: MediaQuery.of(context).size.width * .8,
                              height: 40,
                              color: Colors.amberAccent,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Quick Information',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.done),
                                    color: Colors.white,onPressed: (){
                                      Navigator.of(context).pop();
                                  },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text('Driver'),
                            subtitle: Text(name),
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.info,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.verified_user,
                                color: Colors.deepOrange,
                              ),
                            ),
                            title: Text('License Valid Till '),
                            subtitle: Text(license_validity),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.directions_bus,
                                color: Colors.deepOrange,
                              ),
                            ),
                            title: Text('Bus Plate '),
                            subtitle: Text(busPlate),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
