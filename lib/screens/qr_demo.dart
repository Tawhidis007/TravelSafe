import 'package:flutter/material.dart';
import 'package:portfolio1/widgets/info_dialog.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class QrDemo extends StatefulWidget {
  static const routeName = '/qr-demo';

  @override
  _QrDemoState createState() => _QrDemoState();
}

class _QrDemoState extends State<QrDemo> {
  String _qrInfo = 'Scan a Code';
  bool _camState = false;

  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  @override
  void initState() {
    _camState = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return QrCamera(
      onError: (context, error) => Text(
        error.toString(),
        style: TextStyle(color: Colors.red),
      ),
      qrCodeCallback: (code) {
        _qrCallback(code);
      },
    );
  }

  void _qrCallback(String code) {
    setState(() {
      _camState = false;
      _qrInfo = code;
      print(_qrInfo);
      Navigator.of(context).pop();
      if (_qrInfo != null) {
        showDialog(
          context: context,
          builder: (_) => InfoDialog(_qrInfo),
        );
      }
    });
  }
}
