import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:portfolio1/providers/companies.dart';
import 'package:portfolio1/providers/emergency_contacts.dart';
import 'package:portfolio1/providers/location_work.dart';
import 'package:portfolio1/screens/bus_screen.dart';
import 'package:portfolio1/screens/emergency_contacts_screen.dart';
import 'package:portfolio1/screens/map_screen.dart';
import 'package:portfolio1/screens/my_home_page.dart';
import 'package:portfolio1/screens/qr_demo.dart';
import 'package:portfolio1/widgets/my_form.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (ctx) => Companies(),
        ),
        ChangeNotifierProvider(
          builder: (ctx) => LocationWorks(),
        ),
        ChangeNotifierProvider(
          builder: (ctx) => EmergencyContacts(),
        ),
      ],
      child: MaterialApp(
        title: 'SafeTravel',
        theme: ThemeData(
          primaryColor: Colors.amber,
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light()
                .textTheme
                .copyWith(title: TextStyle(fontSize: 20)),
          ),
          fontFamily: 'Lato',
          accentColor: Colors.black,
          primarySwatch: Colors.amber,
        ),
        home: MyHomePage(),
        routes: {
          QrDemo.routeName:(ctx)=> QrDemo(),
          MyForm.routeName : (ctx) => MyForm(),
          EmergencyContactsScreen.routeName: (ctx) => EmergencyContactsScreen(),
          MapScreen.routeName: (ctx) => MapScreen(),
          BusScreen.routeName: (ctx) => BusScreen(),
          //QrScreen.routeName : (ctx) => QrScreen(),
        },
      ),
    );
  }
}
