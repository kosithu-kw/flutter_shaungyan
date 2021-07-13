import 'package:flutter/material.dart';
import 'dart:io';
import 'home.dart';

void main(){
  runApp(
    MaterialApp(
      title: 'Shoung ROUTES',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {

        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => HomeApp(),
      },
    ),
  );
}

class ErrorApp extends StatefulWidget {
  const ErrorApp({Key? key}) : super(key: key);

  @override
  _ErrorAppState createState() => _ErrorAppState();
}

class _ErrorAppState extends State<ErrorApp> {

  checkConnection() async{

    final result = await InternetAddress.lookup('raw.githubusercontent.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      Navigator.pushNamed(context, '/home');
    }

  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Error",
      home: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Text(
                      "အင်တာနက်ဆက်သွယ်မှုများပြတ်တောက်နေပါသည်"
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.refresh_outlined),
                    onPressed: (){
                      checkConnection();
                    },
                    color: Colors.blueGrey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}