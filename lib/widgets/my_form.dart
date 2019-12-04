import 'package:flutter/material.dart';
import 'package:portfolio1/providers/emergency_contacts.dart';
import 'package:provider/provider.dart';

class MyForm extends StatefulWidget {
  static const routeName = '/edit-create-contact';

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  var editedContact =
      EmergencyContactItem(id: null, name: '', phoneNumber: '', relation: '');
  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final relationFocus = FocusNode();
  final form = GlobalKey<FormState>();
  var isInit = true;
  var isLoading = false;
  var initValue = {
    'Name': '',
    'Relation': '',
    'PhoneNumber': '',
  };

  @override
  void didChangeDependencies() {
    if (isInit) {
      final cId = ModalRoute.of(context).settings.arguments as String;
      if (cId != null) {
        editedContact = Provider.of<EmergencyContacts>(context, listen: false)
            .findById(cId);
        print('pulled out ${editedContact.name}');
        initValue = {
          'Name': editedContact.name,
          'Relation': editedContact.relation,
          'PhoneNumber': editedContact.phoneNumber
        };
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameFocus.dispose();
    phoneFocus.dispose();
    relationFocus.dispose();
    super.dispose();
  }

  void submitForm() async {
    var isValid = form.currentState.validate();
    if (!isValid) {
      return;
    }
    form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (editedContact.id != null) {
      await Provider.of<EmergencyContacts>(context, listen: false)
          .updateContact(editedContact.id, editedContact);
      Navigator.of(context).pop();
    } else {
      await Provider.of<EmergencyContacts>(context, listen: false)
          .addContact(editedContact)
          .catchError((error) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error Occured!'),
                  content: Text('Something went wrong.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('okay'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }).then((_) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit contacts'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              submitForm();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: initValue['Name'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Not filled!';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: 'Enter Name'),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(phoneFocus);
                        },
                        onSaved: (value) {
                          editedContact = EmergencyContactItem(
                              id: editedContact.id,
                              name: value,
                              relation: editedContact.relation,
                              phoneNumber: editedContact.phoneNumber);
                        },
                      ),
                      TextFormField(
                        initialValue: initValue['PhoneNumber'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Not a valid number';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: phoneFocus,
                        decoration:
                            InputDecoration(labelText: 'Enter Phone Number'),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(relationFocus);
                        },
                        onSaved: (value) {
                          editedContact = EmergencyContactItem(
                              name: editedContact.name,
                              id: editedContact.id,
                              relation: editedContact.relation,
                              phoneNumber: value);
                        },
                      ),
                      TextFormField(
                        initialValue: initValue['Relation'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please mention the relationship';
                          }
                          return null;
                        },
                        focusNode: relationFocus,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            labelText: 'Your Relationship With Them'),
                        onFieldSubmitted: (_) {
                          submitForm();
                        },
                        onSaved: (value) {
                          editedContact = EmergencyContactItem(
                              name: editedContact.name,
                              id: editedContact.id,
                              relation: value,
                              phoneNumber: editedContact.phoneNumber);
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
