import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutWidget extends StatefulWidget {
  @override
  _AboutWidgetState createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image.asset('assets/images/hri.png'),
        Text(
          'Developed by Tawhid Shahriar',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'This app has been built on the Flutter Framework by Google',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'www.github.com/tawhidis007',
            style: TextStyle(fontSize: 14,decoration: TextDecoration.underline,color: Colors.blue),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
