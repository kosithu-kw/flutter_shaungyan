
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shaungyan/search.dart';
import 'main.dart';
import 'error.dart';


void main()=>runApp(HomeApp());



class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<HomeApp> {

  getData() async{
    var res=await http.get(Uri.https('raw.githubusercontent.com', "kosithu-kw/flutter_shoung_data/master/data_list.json"));
    var jsonData=jsonDecode(res.body);
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
                        ),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: new Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(s.data[i]['f']),
                                )
                              ),
                            ),
                            Expanded(
                              child: new Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(s.data[i]['s']),
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