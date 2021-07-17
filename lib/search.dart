import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'error.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_helper.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';


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



  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isInterstitialAdReady = false;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.pop(context);
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
    if (!_isInterstitialAdReady) {
     // _loadInterstitialAd();
    }
    //Timer(Duration(seconds: 3), () => checkConnection());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _interstitialAd?.dispose();

    super.dispose();
  }

  final String _title="အစားအစာနာမည်ဖြင့်ရှာဖွေရန်";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/error' : (context) => ErrorApp(),
        },
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: (){
                  if (_isInterstitialAdReady) {
                    //_interstitialAd?.show();
                  } else {
                    Navigator.pop(context);
                  }


                },
                icon: Icon(Icons.arrow_back_outlined),
              ),
              title: Text(_title,
                style: TextStyle(
                    color: Colors.white

                ),
              ),

              backgroundColor: Colors.blueGrey,

            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: SearchBar(
                  onSearch:(t)=> _getALlFoods(t),
                  loader: Center(
                    child: Text("ရှာဖွေနေသည်..."),
                  ),
                  minimumChars: 1,
                  emptyWidget: Center(
                    child: Text("သင်ရှာသောအစားအစာနာမည်မတွေ့ရှိပါ"),
                  ),
                  hintText: "ရှာဖွေရန်",
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
    );
  }
}

class Food {
    String f, s, h;
    Food(this.f, this.s, this.h);
}
