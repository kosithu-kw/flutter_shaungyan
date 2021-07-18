import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shaungyan/home.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:page_transition/page_transition.dart';


class SearchApp extends StatefulWidget {
  const SearchApp({Key? key}) : super(key: key);

  @override
  _SearchAppState createState() => _SearchAppState();
}

class _SearchAppState extends State<SearchApp> {
  @override

  checkConnection() async{
    try {
      final result = await InternetAddress.lookup('raw.githubusercontent.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
       // Navigator.pushNamed(context, '/search');
      }
    } on SocketException catch (_) {
      Navigator.pushNamed(context, '/error');
    }
  }

  String InterstitialId="";
  bool showInter=false;

  _getAdId() async{
    var result=await http.get(Uri.https("raw.githubusercontent.com", "kosithu-kw/flutter_shoung_data/master/ads.json"));
    var jsonData=await jsonDecode(result.body);
    //print(jsonData['int']);

    setState(() {
      InterstitialId=jsonData['int'];
      if(jsonData['showInter']=="true"){
          setState(() {
            showInter=true;
          });
      }else{
        setState(() {
          showInter=false;
        });
      }
    });
  }


  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isInterstitialAdReady = false;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: InterstitialId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: HomeApp()));

            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  Future<List<Food>> _getALlFoods(String text) async {

      var result=await DefaultCacheManager().getSingleFile("https://raw.githubusercontent.com/kosithu-kw/flutter_shoung_data/master/data_list.json");
      var file=await result.readAsString();
      var jsonData=jsonDecode(file);
      List<Food> foods = [];
      for (var food in jsonData) {
        if(food['f'].toLowerCase().contains(text.toLowerCase()) || food['s'].toLowerCase().contains(text.toLowerCase())){
        foods.add(Food(food['f'], food['s'], food['h']));
        }
      }
      return foods;
  }


  @override
  void initState() {
    // TODO: implement initState
    _getAdId();

    Timer(Duration(seconds: 3), () {
      if(showInter){
        if (!_isInterstitialAdReady) {
          _loadInterstitialAd();
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(showInter){
      _interstitialAd?.dispose();
    }

    super.dispose();
  }

  final String _title="အစားအစာနာမည်ဖြင့်ရှာရန်";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return await  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: HomeApp()));

        },

        child : MaterialApp(
            home : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(_title,
                style: TextStyle(
                    color: Colors.white

                ),
              ),

              backgroundColor: Colors.blueGrey,

            ),

            floatingActionButton: FloatingActionButton(
              onPressed: (){
                  if(showInter && _isInterstitialAdReady){
                      _interstitialAd?.show();
                  }else{
                    Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: HomeApp()));
                  }
              },
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.home),
            ),

            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: SearchBar(
                  onSearch:(t)=> _getALlFoods(t),
                  loader: Center(
                    child: Text("ရှာနေသည်..."),

                  ),
                  minimumChars: 1,
                  emptyWidget: Center(
                    child: Text("သင်ရှာသောအစားအစာနာမည်မတွေ့ရှိပါ"),
                  ),
                  hintText: "ရှာမည်",
                  onItemFound: (Food food, int i){

                    return Container(
                        child: Card(
                          child: ListTile(

                              title: Text(
                                food.h,
                                textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.redAccent)
                              ),
                              subtitle: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: new Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Text(food.f, style: TextStyle(color: Colors.black)),
                                        )
                                    ),
                                  ),
                                  Expanded(
                                    child: new Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Text(food.s, style: TextStyle(color: Colors.black)),
                                        )
                                    ),
                                  ),
                                ],
                              )
                          ),
                        )
                    );
                  },

                ),
              ),
            )
        )
        ),
    );
  }
}

class Food {
    String f, s, h;
    Food(this.f, this.s, this.h);
}
