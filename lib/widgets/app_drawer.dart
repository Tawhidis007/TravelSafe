import 'package:flutter/material.dart';
import 'package:portfolio1/screens/emergency_contacts.dart';
import 'package:portfolio1/widgets/about_widget.dart';

class AppDrawer extends StatelessWidget {

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      elevation: 6,
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child:  AboutWidget() ,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            elevation: 3,
            title: Text('Travel Safe!'),
            automaticallyImplyLeading: false,
          ),
          Image.asset(
            'assets/images/wal.jpg',
            fit: BoxFit.cover,
          ),
          SizedBox(height: 2,),
          Card(
            elevation: 1,
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(EmergencyContacts.routeName);
              },
              leading: Icon(Icons.contact_phone),
              title: Text('Emergency Contacts'),
            ),
          ),
          Card(
            elevation: 1,
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: ListTile(
              onTap: () {},
              leading: Icon(Icons.scanner),
              title: Text('QR Scanner'),
            ),
          ),
          Card(
            elevation: 1,
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: ListTile(
              onTap: () {
                _startAddNewTransaction(context);
              },
              leading: Icon(Icons.info),
              title: Text('About'),
            ),
          ),
        ],
      ),
    );
  }
}
