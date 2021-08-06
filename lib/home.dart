
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shaungyan/readme.dart';
import 'package:shaungyan/search.dart';
import 'ad_helper.dart';
import 'error.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';



class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<HomeApp> {

  getData() async{
    var result=await DefaultCacheManager().getSingleFile("https://raw.githubusercontent.com/kosithu-kw/flutter_shoung_data/master/data_list.json");
    var file=await result.readAsString();
    var jsonData=jsonDecode(file);
    return jsonData;
  }

  bool _isUpdate=false;

  _updateData() async{
    await DefaultCacheManager().emptyCache().then((value){
      setState(() {
        _isUpdate=true;

      });
      Timer(Duration(seconds: 3), () {
        setState(() {
          _isUpdate=false;
        });
      });
    });
  }


  // TODO: Add _bannerAd
  late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  _callBanner(){
    // TODO: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!_isBannerAdReady){
      _callBanner();
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _bannerAd.dispose();
    super.dispose();
  }

  final String _title="ရှောင်";

  final String _mTitle="တွဲဖက်၍မစားသုံးသင့်တဲ့အစားအစာများ";


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
          return await exit(0);
      },
      child: MaterialApp(
      title: _title,
      theme: ThemeData(fontFamily: 'uni'),
      home: Scaffold(
        appBar: AppBar(

          title: Text(_title,
            style: TextStyle(
                color: Colors.white

            ),
          ),
          actions: [
            IconButton(onPressed: (){
              _updateData();
            },
              icon: Icon(Icons.cloud_download),
            ),
              IconButton(
                  color: Colors.white70,
                  iconSize: 30,
                  onPressed: (){
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SearchApp()));
                  },
                  icon: Icon(Icons.search_rounded))
          ],
          bottom: PreferredSize(
            child: Text(_mTitle,
                style: TextStyle(
                    color: Colors.white70,
                    height: 3.0
                )),
            preferredSize: Size.fromHeight(30),

          ),
          iconTheme: IconThemeData(
              color: Colors.white70
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,

        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text("App Version"),
                subtitle: Text("1.0.0"),
                leading: Icon(Icons.settings_accessibility),
              ),
              /*
              ListTile(
                title: Text("Share App"),
                leading: Icon(Icons.share),
                onTap: (){
                  Share.share("https://play.google.com/store/apps/details?id=com.goldenmawlamyine.shaungyan");
                },
              ),

               */
              ListTile(
                title: Text("Read Me"),
                leading: Icon(Icons.read_more),
                onTap: (){
                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: ReadmeApp()));
                },
              )
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: _isBannerAdReady ? BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 70,
                            color: Colors.white70
                        )
                    )
                ) : null,
                child: FutureBuilder(
                  future: _isUpdate ? getData() : getData(),
                  builder: (context, AsyncSnapshot s){

                    if(_isUpdate)
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 120, right: 120),
                              child: LinearProgressIndicator(),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("Updating data from server..."),
                            )
                          ],
                        ),
                      );

                    if(s.hasData){

                      return ListView.builder(
                        itemCount: s.data.length,
                        itemBuilder: (context, i){
                          return Card(
                            child: ListTile(

                                title: Text(
                                    s.data[i]['h'],
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
                                            child: Text(s.data[i]['f'], style: TextStyle(color: Colors.black),),
                                          )
                                      ),
                                    ),
                                    Expanded(
                                      child: new Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Center(
                                            child: Text(s.data[i]['s'],style: TextStyle(color: Colors.black)),
                                          )
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          );
                        },

                      );

                    }else if(s.hasError) {
                      return Center(
                          child: IconButton(
                            onPressed: (){
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => new ErrorApp()));
                            },
                            icon: Icon(Icons.refresh_outlined),
                            color: Colors.blueGrey,
                          )
                      );
                      // return Center(
                      //  child: CircularProgressIndicator(),
                      //);
                    }
                    else{
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blueGrey,
                        ),
                      );
                    }
                  },
                ),
              ),
              if (_isBannerAdReady)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                ),
            ],
          ),
        )
      ),
      )
    );

  }
}