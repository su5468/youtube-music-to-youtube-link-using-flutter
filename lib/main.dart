import 'package:flutter/material.dart';
import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share/share.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _musicURL = '';
  String _linkCode = '';
  String _ytURL = '';
  late StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _musicURL = value;
        _linkCode = _musicURL.substring(
            _musicURL.indexOf('watch?v='), _musicURL.indexOf('&'));
        _ytURL = 'https://youtu.be/' + _linkCode;
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        _musicURL = value ?? '';
        _linkCode = _musicURL.substring(
            _musicURL.indexOf('watch?v='), _musicURL.indexOf('&'));
        _ytURL = 'https://youtu.be/' + _linkCode;
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('YT Music to Youtube Link Converter'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(_ytURL),
              OutlinedButton(
                onPressed: () {
                  Share.share(_ytURL);
                },
                child: Icon(Icons.share),
              )
            ],
          ),
        ),
      ),
    );
  }
}
