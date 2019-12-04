import 'package:flutter/material.dart';
import 'package:portfolio1/providers/emergency_contacts.dart';
import 'package:portfolio1/widgets/contact_tiles.dart';
import 'package:portfolio1/widgets/my_form.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EmergencyContactsScreen extends StatefulWidget {
  static const routeName = '/emergency-contacts-screen';

  @override
  _EmergencyContactsScreenState createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  var isInit = true;
  var isLoading = false;
  var editOn = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<EmergencyContacts>(context).fetchAndSetContacts().then((_) {
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
    final contactData = Provider.of<EmergencyContacts>(context);
    return Scaffold(
      body: isLoading
          ? Center(child: SpinKitFadingFour(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? Colors.deepOrange : Colors.amber,
                  ),
                );
              },
            ))
          : editOn
              ? ListView.builder(
                  itemBuilder: (_, i) => ContactTiles(
                    editOn: true,
                    id: contactData.contactList[i].id,
                    name: contactData.contactList[i].name,
                    phoneNumber: contactData.contactList[i].phoneNumber,
                    relation: contactData.contactList[i].relation,
                  ),
                  itemCount: contactData.contactList.length,
                )
              : ListView.builder(
                  itemBuilder: (_, i) => ContactTiles(
                    editOn: false,
                    id: contactData.contactList[i].id,
                    name: contactData.contactList[i].name,
                    phoneNumber: contactData.contactList[i].phoneNumber,
                    relation: contactData.contactList[i].relation,
                  ),
                  itemCount: contactData.contactList.length,
                ),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: editOn
                ? Icon(
                    Icons.edit,
                    color: Colors.black26,
                  )
                : Icon(Icons.edit),
            onPressed: () {
              setState(() {
                editOn = !editOn;
              });
            },
          ),
        ],
        title: editOn
            ? Text(
                'Now Editing',
                style: TextStyle(fontSize: 16),
              )
            : Text(
                'Your Emergency contacts',
                style: TextStyle(fontSize: 16),
              ),
      ),
      floatingActionButton: editOn
          ? null
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(MyForm.routeName);
              },
            ),
    );
  }
}
