import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shaungyan/home.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(
      MaterialApp(
        home: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              home: Splash()
          );
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            home: HomeApp(),
          );
        }
      },
    );
  }
}

class Splash extends StatelessWidget {

  static const colorizeTextStyle = TextStyle(
    fontSize: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
          child: Stack(
            children: [
              Center(
                child: Container(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 50.0,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ScaleAnimatedText('ရှောင်'),

                      ],
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
                )
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 50, left: 180, right: 180),
                  child: LinearProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.grey,
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(Duration(seconds: 4));
  }
}