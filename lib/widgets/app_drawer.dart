import 'package:flutter/material.dart';
import 'package:portfolio1/screens/emergency_contacts_screen.dart';
import 'package:portfolio1/screens/qr_demo.dart';
import 'package:portfolio1/widgets/about_widget.dart';

class AppDrawer extends StatelessWidget {
  void modalBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      elevation: 6,
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child: AboutWidget(),
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
          SizedBox(
            height: 2,
          ),
          Card(
            elevation: 1,
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: ListTile(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(EmergencyContactsScreen.routeName);
              },
              leading: Icon(Icons.contact_phone),
              title: Text('Emergency Contacts'),
            ),
          ),
          Card(
            elevation: 1,
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                  Navigator.of(context).pushNamed(QrDemo.routeName);
              },
              leading: Icon(Icons.scanner),
              title: Text('QR Scanner'),
            ),
          ),
          Card(
            elevation: 1,
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: ListTile(
              onTap: () {
                modalBottomSheet(context);
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
