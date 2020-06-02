import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:orderapp/info/Items.dart';
import 'package:orderapp/info/Orders.dart';
import 'package:orderapp/views/Dashboard.dart';
import 'package:orderapp/Providers/Order_providers.dart';
import 'package:sqflite/sqflite.dart';

class ItemListState extends StatefulWidget{

  final int order;
  ItemListState( { this.order});

  @override
  State<StatefulWidget> createState() => _Items();

  }
 // final Map<String ,dynamic>  orders;



class _Items extends State<ItemListState> {
  final GlobalKey<itemlist> _key = GlobalKey();
  List <String> unitmeasurement =[
    'Kg',
   'Punnets',
    'Packets',
    'Bunches',
   'Grams',
    'Pieces'
  ];
int id;
TextEditingController _typeController = new TextEditingController();
  TextEditingController _quantityController = new TextEditingController();
  TextEditingController _unitpriceController = new TextEditingController();
  String dropDownValue;
  String holder = "";
  double total;

   getDropDownItem(){
   setState(() {
    holder=dropDownValue;
    }
    );
   return holder;
  }
  getTotalPrice(){
     setState(() {
       total = Items(_typeController.text,
           holder,
           double.parse(_quantityController.text),
           double.parse(_unitpriceController.text)).calc();
     });
     return total;
  }

  /*void addItem (Items items){

    itemList.add(items);
  }*/

  @override
  void dispose() {

    _typeController.dispose();
    _quantityController.dispose();
    _unitpriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text("Items", style: TextStyle(color: Colors.white)),
        ),
        body:ItemList(
          key: _key
        ),
        floatingActionButton:
             FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  _displayDialog(context);
                }
            ),



      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }

  _displayDialog( BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Add your Items'),
          content: Container(
            child: Center(
                child:Expanded(
                  child:
                  Column(
                    children: <Widget>[
                      TextField(
                        controller: _typeController,
                        decoration: InputDecoration(
                            hintText: "Product Name"),
                      ),
                      TextField(
                        controller: _unitpriceController,
                          keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Unit Price"),

                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width:100,
                              child:
                          TextField(
                            controller: _quantityController,
                            decoration: InputDecoration(
                                hintText: "Quantity"),
                            inputFormatters:<TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                            ], // Only
                            keyboardType: TextInputType.number,// numbers can be entered,
                          )
                          ),
                          DropdownButton<String>(
                            value: dropDownValue,
                            icon: Icon(Icons.arrow_drop_down_circle),
                            iconSize: 20,
                            elevation: 15,
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String data){
                              dropDownValue=data;
                              setState(() {
                                dropDownValue=data;
                              });
                            },
                            items: unitmeasurement.map((unitmeasurement){
                              return DropdownMenuItem<String>(
                                child:  Text(unitmeasurement),
                                value: unitmeasurement,
                              );
                            }).toList()

                          )

                        ],
                      ),
                    ],
                  ),
                )
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.lightGreen,
              child: Text('CANCEL',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: Colors.lightGreen,
              child: Text('ADD',style: TextStyle(color: Colors.white),),
              onPressed: () async {
                OrderProvider.insertItem({
                  'refID':, //fetch refID from Order item selected
                  'Quantity': _quantityController.text,
                  'Unit': getDropDownItem().toString(),
                  'TypeOfProduct': _typeController.text,
                  'UnitPrice':_unitpriceController.text,
                  'TotalPrice':getTotalPrice()
                });
                Navigator.of(context).pop();
                setState(() {});
              },
            )
          ],
        );
      },
    );
  }
}
class ItemList extends StatefulWidget{
  ItemList( {Key key}): super(key:key);

  @override
  itemlist createState() => itemlist();
}

class itemlist extends State<ItemList> {
  _displayDialog( BuildContext context,item){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Add your Items'),
          content: Container(
            child: Center(
                child:Flexible(
                  child:
                  Column(
                    children: <Widget>[
                      TextField(
                        controller:_Items(). _typeController,
                        decoration: InputDecoration(
                            hintText: "Product Name"),
                      ),
                      TextField(
                        controller:_Items(). _unitpriceController,
                        decoration: InputDecoration(
                            hintText: "Unit Price"),

                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width:100,
                              child:
                              TextField(
                                controller: _Items()._quantityController,
                                decoration: InputDecoration(
                                    hintText: "Quantity"),
                                inputFormatters:<TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ], // Only
                                keyboardType: TextInputType.number,// numbers can be entered,
                              )
                          ),
                          DropdownButton<String>(
                              value: _Items().dropDownValue,
                              icon: Icon(Icons.arrow_drop_down_circle),
                              iconSize: 20,
                              elevation: 15,
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String data){
                                _Items(). dropDownValue=data;
                                setState(() {
                                  _Items(). dropDownValue=data;
                                });
                              },
                              items: _Items().unitmeasurement.map((unitmeasurement){
                                return DropdownMenuItem<String>(
                                  child:  Text(unitmeasurement),
                                  value: unitmeasurement,
                                );
                              }).toList()

                          )

                        ],
                      ),
                    ],
                  ),
                )
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.lightGreen,
              child: Text('CANCEL',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: Colors.lightGreen,
              child: Text('Update',style: TextStyle(color: Colors.white),),
              onPressed: () async {
                OrderProvider.updateItems({
                  'id':item['id'],
                  'Quantity': double.parse(_Items()._quantityController.text),
                  'Unit':_Items(). holder.toString(),
                  'TypeOfProduct':_Items(). _typeController.text,
                  'UnitPrice':double.parse(_Items()._unitpriceController.text,),
                });
                /*_key.currentState.
                addItem(Items(
                    _typeController.text,
                    dropDownValue,
                    double.parse(_quantityController.text),
                    double.parse(_unitpriceController.text)));*/
                await  Navigator.of(context).pop();

                setState(() {});
              },
            )
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child:Center(
                child: Column(
          children: <Widget>[
            SizedBox(child: Text(
          "TOTAL ITEM PRICE:  ",
              style:TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,color: Colors.blue),),
            ),Container(
              child:  FutureBuilder(
                future: OrderProvider.getItemList(),
                // ignore: missing_return
                builder:(context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Error ${snapshot.error}')
                    );
                  }
                  else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.length < 1) {
                      return Center(
                        child: Text('No Orders!, Create New one'),
                      );
                    }
                    final item = snapshot.data;
                    return Flexible(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: item.length,
                          itemBuilder: (BuildContext context, index) {
                            return new GestureDetector(
                                child:Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                          child: Row(children: <Widget>[
                                            Text("${item[index]['Quantity']} "
                                                "${item[index]['Unit']} "
                                                "${item[index]['TypeOfProduct']}",
                                              style: new TextStyle(fontSize: 20.0),),
                                            Spacer(),
                                          ]),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text("KSHS:${item[index]['UnitPrice']}", style: new TextStyle(fontSize: 15.0),),
                                              Spacer(),
                                              Text("KSHS:${item[index]['TotalPrice']}", style: new TextStyle(fontSize: 15.0),),
                                              Spacer(),
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: (){
                                                  _displayDialog(context, item);
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () async {
                                                  OrderProvider.deleteItems(
                                                      item[index]['id']);
                                                  setState(() {});
                                                },

                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            );
                          }

                      ),
                    );
                  }
                  else{
                    return Center(child: CircularProgressIndicator());
                  }
                }

            ),
            )

        ],
      ),)

              ),

            )
          ]
      ),

    );

        }


}

