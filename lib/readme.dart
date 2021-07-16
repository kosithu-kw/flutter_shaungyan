import 'dart:convert';
import 'package:flutter/material.dart';




class ReadmeApp extends StatefulWidget {
  const ReadmeApp({Key? key}) : super(key: key);

  @override
  _ReadmeAppState createState() => _ReadmeAppState();
}

class _ReadmeAppState extends State<ReadmeApp> {
  final String _title="ရှောင်";

  final String _subTitle="တွဲဖက်၍မစားသုံးသင့်တဲ့အစားအစာများ";

  final String _readMeBody="ရှောင် APP ကိုပထမဦးဆုံးအကြိမ်အသုံးပြုခြင်းအတွက် Internet Connection ဖွင့်ထားရန်လိုအပ်ပါသည်၊ လိုအပ်ပါက VPN များချိတ်ဆက်အသုံးပြုရပါမည်။နောက်ပိုင်းအသုံးပြုခြင်းအတွက်  Internet Connection ဖွင့်ထားရန်မလိုအပ်တော့ပါ။ တွဲဖက်၍မစားသုံးသင့်သောအစားအစာများစာရင်းကို Server မှအမြဲတမ်း Update လုပ်ပေးသွားမည်ဖြစ်ပါတယ်။";



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_title),
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed("/home");
            },
            icon: Icon(Icons.arrow_back),
          ),
          bottom: PreferredSize(
            child: Text(_subTitle, style: TextStyle( color: Colors.white70),),
            preferredSize: Size.fromHeight(20),
          ),

        ),

        body: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(_readMeBody)
        ),

      ),
    );
  }
}
