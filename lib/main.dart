import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'home.dart';
import 'error.dart';

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
    Timer(Duration(seconds: 3), () => checkConnection());
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