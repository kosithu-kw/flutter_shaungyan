import 'dart:convert';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchApp extends StatelessWidget {


  Future<List<Food>> _getALlFoods(String text) async {
    var res=await http.get(Uri.https('raw.githubusercontent.com', "kosithu-kw/flutter_shoung_data/master/data_list.json"));
    var jsonData=jsonDecode(res.body);
    List<Food> foods = [];

    for (var food in jsonData) {
      if(food['f'].toLowerCase().contains(text.toLowerCase()) || food['s'].toLowerCase().contains(text.toLowerCase())){
        foods.add(Food(food['f'], food['s'], food['h']));
      }

    }
    return foods;
  }

  const SearchApp({Key? key}) : super(key: key);
  final String _title="အစားအစာများရှာဖွေရန်";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title: Text(_title,
            style: TextStyle(
                color: Colors.white

            ),
          ),

          backgroundColor: Colors.blueGrey,

        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SearchBar(
                onSearch:(t)=> _getALlFoods(t),
              loader: Text("Loading..."),
              hintText: "ရှာဖွေရန်",
              onItemFound: (Food food, int i){
                  return Container(
                      child: Card(
                        child: ListTile(

                            title: Text(
                              food.h,
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: new Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(food.f),
                                      )
                                  ),
                                ),
                                Expanded(
                                  child: new Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(food.s),
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
    );
  }
}

class Food {
    String f, s, h;
    Food(this.f, this.s, this.h);
}
