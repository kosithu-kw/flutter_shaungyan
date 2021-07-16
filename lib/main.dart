import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shaungyan/readme.dart';
import 'home.dart';
import 'error.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main(){
  runApp(
    MaterialApp(
      title: 'Shoung Routes',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.

      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MainApp(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => HomeApp(),
        '/error' : (context) => ErrorApp(),
        '/readme':(context)=> ReadmeApp()
      },
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MainApp> {

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {// Not first time
      Navigator.pushNamed(context, "/home");
      //print("Not first time");

    } else {// First time
      prefs.setBool('first_time', false);

      checkConnection();
      //print("first time");
    }
  }

  final String _title="ရှောင်";

  final String _mTitle="တွဲဖက်၍မစားသုံးသင့်တဲ့အစားအစာများ";


  checkConnection() async{
    try {
      final result = await InternetAddress.lookup('raw.githubusercontent.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Navigator.pushNamed(context, '/home');
      }
    } on SocketException catch (_) {
      Navigator.pushNamed(context, '/error');
    }


  }


  @override
  void initState() {
    // TODO: implement initState

    Timer(Duration(seconds: 3), () => startTime());
    //checkConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_title, style: TextStyle(color: Colors.white, fontSize: 40),),
                Text(_mTitle, style: TextStyle(color: Colors.white70),),

                SizedBox(height: 200,),
                Container(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.white70,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}