import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shaungyan/home.dart';
import 'package:page_transition/page_transition.dart';




class ReadmeApp extends StatefulWidget {
  const ReadmeApp({Key? key}) : super(key: key);

  @override
  _ReadmeAppState createState() => _ReadmeAppState();
}

class _ReadmeAppState extends State<ReadmeApp> {
  final String _title="ရှောင်";

  final String _subTitle="တွဲဖက်၍မစားသုံးသင့်တဲ့အစားအစာများ";

  final String _readMeBody="ရှောင် APP ကိုပထမဦးဆုံးအကြိမ်အသုံးပြုခြင်းအတွက် Internet Connection ဖွင့်ထားရန်လိုအပ်ပါသည်၊ လိုအပ်ပါက VPN များချိတ်ဆက်အသုံးပြုရပါမည်။နောက်ပိုင်းအသုံးပြုခြင်းအတွက်  Internet Connection ဖွင့်ထားရန်မလိုအပ်တော့ပါ။ တွဲဖက်၍မစားသုံးသင့်သောအစားအစာများစာရင်းကို Server မှအမြဲတမ်း Update လုပ်ပေးသွားမည်ဖြစ်ပါတယ်။ Server မှ  data အသစ်များကိုရယူရန်အတွက် Search Icon ဘေးနားမှ Update Icon ကိုနှိပ်ပြီး ရယူနိုင်ပါသည်။";



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return await Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: HomeApp()));
      },
     child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_title),
          leading: IconButton(
            onPressed: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: HomeApp()));
            },
            icon: Icon(Icons.arrow_back),
          ),
          bottom: PreferredSize(
            child: Text(_subTitle, style: TextStyle( color: Colors.white70),),
            preferredSize: Size.fromHeight(20),
          ),
          iconTheme: IconThemeData(
              color: Colors.white70
          ),
          backgroundColor: Colors.blueGrey,


        ),

        body: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
           // alignment: Alignment.topCenter,
            child: Text(_readMeBody,
              textAlign: TextAlign.justify,
            )
        ),

      ),
     )
    );
  }
}
