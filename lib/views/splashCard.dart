import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orderapp/views/Dashboard.dart';
import 'package:orderapp/views/Login.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Splash();
  }

class Splash extends State<SplashScreen>{

@override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),()=> Navigator.push(context,
    MaterialPageRoute(builder: (context) => Dashboard())));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.greenAccent),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex:2,
              child: Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor:Colors.white,
                    radius: 50,
                    child: Icon(
                      Icons.account_balance,
                      color: Colors.redAccent,
                      size: 50,
                    ),),
                    Padding(padding: EdgeInsets.only(top:10.0),
                    ),
                    Text(
                      'My Invoice App', style:TextStyle(color: Colors.white,fontSize: 24.0, fontWeight: FontWeight.bold),
                    )
                                ],
                                ),
                                ),
                                Expanded(flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircularProgressIndicator(backgroundColor: Colors.redAccent,),
                                    Padding(padding: EdgeInsets.only(top:20.0),
                                    ),
                                    Text(
                                      'Easy to use \nFor Everyone',style:TextStyle(color:Colors.white,fontSize:18,fontWeight: FontWeight.bold),
                                    )
                                  ],),)
          ],
        )
      ],
      ),
    );
  }

}