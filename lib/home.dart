
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shaungyan/search.dart';
import 'main.dart';
import 'error.dart';
import 'package:share/share.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


void main()=>runApp(HomeApp());



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


  final String _title="ရှောင်";

  final String _mTitle="တွဲဖက်၍မစားသုံးသင့်တဲ့အစားအစာများ";


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              IconButton(
                  color: Colors.white70,
                  iconSize: 30,
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext)=>new SearchApp()));
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
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> new HomeApp()));
                },
              ),
              ListTile(
                title: Text("Share App"),
                leading: Icon(Icons.share),
                onTap: (){
                  Share.share("https://play.google.com/store/apps/details?id=com.goldenmawlamyine.shaungyan");
                },
              ),
              ListTile(
                title: Text("Read Me"),
                leading: Icon(Icons.read_more),
                onTap: (){
                  Navigator.of(context).pushNamed('/readme');
                },
              )
            ],
          ),
        ),
        body: Container(

          child: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot s){
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
      ),
    );

  }
}