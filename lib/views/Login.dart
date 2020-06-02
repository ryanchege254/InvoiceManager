import 'package:flutter/material.dart';
import 'package:orderapp/views/Dashboard.dart';
import 'package:orderapp/views/ItemList.dart';


class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top:35.0, left:20.0, right:20.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0,80.0, 0.0,0.0) ,
                          child:Text(
                              "Login",
                              style :TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)
                          ),
                        ),


                      ],
                    )
                ),
                Container(
                    padding: EdgeInsets.only(top:35.0, left:20.0, right:20.0),
                    child: Stack(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Email/Username",
                              labelStyle: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey
                              )
                          ),
                        )
                      ],
                    )
                ),

                Container(
                  padding: EdgeInsets.only(top:35.0, left:20.0, right:20.0),
                  child: Stack(
                    children: <Widget>[
                      SizedBox(height: 20.0,),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)
                            )
                        ),
                        obscureText: true,

                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  child: Stack(
                      children:<Widget>[
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(90, 10, 90, 10),
                          onPressed:(){ Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Dashboard()
                          )
                          );
                          },

                          child: Text(
                            "Login", style: TextStyle(fontSize: 17),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:  new BorderRadius.circular(18.0),
                          ),
                        ),

                      ]
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}