
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orderapp/views/ItemList.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:orderapp/Providers/Order_providers.dart';
import 'package:side_header_list_view/side_header_list_view.dart';
import 'package:orderapp/main.dart';



class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


DateTime dateTime = DateTime.now();
var formated = DateFormat.yMMMMd('en_US');
var month = DateFormat.MMM('en_US');
var year = DateFormat.y('en_US');


  TextEditingController _refController = new TextEditingController();
  TextEditingController _supplierController = new TextEditingController();
  TextEditingController _additionalNotes =new TextEditingController();

@override
void initState() {
  _refController = new TextEditingController();
  _supplierController = new TextEditingController();
  _additionalNotes = new TextEditingController();

  super.initState();
}


@override
void dispose() {
  _refController = new TextEditingController();
  _supplierController = new TextEditingController();
  _additionalNotes = new TextEditingController();

  super.dispose();
}

final GlobalKey<orderlist> _key = GlobalKey();

  Future displayDateRangePicker(BuildContext context)async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: new DateTime(DateTime.now().year -50),
        lastDate: new DateTime(DateTime.now().year +50));
    if(picked != null && picked != dateTime){
      setState(() {
        dateTime = picked;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text("Orders",style: TextStyle(color: Colors.white)),
        actions: <Widget>[
        ],
      ),
      body: OrderList(
        key: _key,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _displayDialog(context ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );

  }
  _displayDialog( BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
            title: Text('Add your order'),
            content: Container(
              child: Center(
                child:SingleChildScrollView(
        child:
                 Column(
                  children: <Widget>[
                    TextField(
                      controller: _refController,
                      decoration: InputDecoration(
                          hintText: "Ref No"),
                    ),
                    TextField(
                      controller: _supplierController,
                      decoration: InputDecoration(
                          hintText: "Supplier"),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: ()  {
                             displayDateRangePicker(context);
                          },
                        ),
                        Text("${DateFormat('dd/MM/yyyy').format(_DashboardState().dateTime).toString()}"),
                      ],
                    ),

                    TextFormField(
                      controller: _additionalNotes,
                      decoration: InputDecoration(
                          hintText: "Additional Notes"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                  ],
                ),
                )
              ),
            ),
          actions: <Widget>[


            FlatButton(
              color: Colors.lightGreen,
              child: Text('ADD',style: TextStyle(color: Colors.white),),
              onPressed: () async {
                 OrderProvider.insertOrder({
                  'Ref': _refController.text,
                  'OrderDate':formated.format(dateTime).toString(),
                  'Supplier': _supplierController.text,
                  'Notes':_additionalNotes.text,
                   'Month':month.format(dateTime).toString(),
                   'Year':year.format(dateTime).toString()
                }); //insert from database

              await  Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Dashboard()
              ));
              setState(() {});
              },
            ),
            FlatButton(
              color: Colors.lightGreen,
              child: Text('CANCEL',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
      );
  }

}
class OrderList extends StatefulWidget{
  OrderList({Key key, Text widget}): super(key:key);

  @override
  orderlist createState() => orderlist();
}



class orderlist extends State<OrderList> {
bool monthly;
bool yearly;

TextEditingController _refController = new TextEditingController();
TextEditingController _supplierController = new TextEditingController();
TextEditingController _additionalNotes =new TextEditingController();


  _displayDialog( BuildContext context, order){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Update your order'),
            content: Container(
              child: Center(
                  child:SingleChildScrollView(
                    child:
                    Column(
                      children: <Widget>[
                        TextField(
                          controller: _DashboardState()._refController,
                          decoration: InputDecoration(
                              hintText: "Ref No"),
                        ),
                        TextField(
                          controller: _DashboardState()._supplierController,
                          decoration: InputDecoration(
                              hintText: "Supplier"),
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: ()  {
                                _DashboardState(). displayDateRangePicker(context);
                              },
                            ),
                            Text("${DateFormat('dd/MM/yyyy').format(_DashboardState().dateTime).toString()}"),
                          ],
                        ),

                        TextFormField(
                          controller: _DashboardState()._additionalNotes,
                          decoration: InputDecoration(
                              hintText: "Additional Notes"),
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                        ),
                      ],
                    ),
                  )
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.lightGreen,
                child: Text('Update',style: TextStyle(color: Colors.white),),
                onPressed: () async {
                  OrderProvider.updateOrder({
                    'id':order['id'],
                    'Ref':_refController.text,
                    'OrderDate':_DashboardState().formated.format(_DashboardState().dateTime).toString(),
                    'Supplier':_supplierController.text,
                    'Notes':_additionalNotes.text,
                    'Month':_DashboardState().month.format(_DashboardState().dateTime).toString(),
                    'Year':_DashboardState().year.format(_DashboardState().dateTime).toString()

                  }); //update from database

                  await  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Dashboard()
                  ));
                  setState(() {});
                },
              ),
              FlatButton(
                color: Colors.lightGreen,
                child: Text('CANCEL',style: TextStyle(
                  color: Colors.white
                ),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child:FutureBuilder(
                  future: OrderProvider.getOrderList(),
                  // ignore: missing_return
                  builder:(context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                    }
                    else if(snapshot.hasError){
                    return Center(
                    child: Text('Error ${snapshot.error}')
                    );
                    }
                    else if(snapshot.connectionState == ConnectionState.done) {
                      final order = snapshot.data;
                      bool monthly;
                      bool yearly;
                      if(snapshot.data ==null){
                        return Center(
                          child:Text('No Data!') ,
                        );
                      }else {
                        if (snapshot.data.length < 1) {
                          return Center(
                            child: Text('No Orders!, Create New one'),
                          );
                        }
                        return SideHeaderListView(
                            itemCount: order.length,
                            itemExtend: 230.0,
                            headerBuilder: (BuildContext context, index) {
                              return new SizedBox(
                                child: Text(order[index]['Month'],
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0),),);
                            },
                            hasSameHeader: (int a, int b) {
                                return order[a]['Month'] ==
                                    order[b]['Month'];

                            },
                            itemBuilder: (BuildContext context, index) {
                              return new GestureDetector(
                                  //onLongPress: _showPopupMenu(),
                                  onTap: () {
                                    _getOrderID(order, index);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ItemListState(order: order[index]['id'],))
                                    );
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 4.0),
                                            child: Row(children: <Widget>[
                                              Text(order[index]['Ref'],
                                                style: new TextStyle(
                                                    fontSize: 20.0),),
                                              Spacer(),
                                            ]),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4.0, bottom: 60.0),
                                            child: Row(children: <Widget>[
                                              Text(
                                                  "${(order[index]['OrderDate'])}"),
                                              Spacer(),
                                            ]),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 8.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text("${order[index]['Supplier']
                                                    .toString()}",
                                                  style: new TextStyle(
                                                      fontSize: 20.0),),
                                                Spacer(),
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    _displayDialog(
                                                        context, order[index]);
                                                  },
                                                ),
                                                PopupMenuButton(
                                                  itemBuilder: (BuildContext context){
                                                    return <PopupMenuEntry>[
                                                      PopupMenuItem<String>(
                                                        value: "Delete",
                                                        child:Row(children: <Widget>[
                                                          IconButton(icon: Icon(Icons.delete),color: Colors.red,)
                                                          ,Text('Delete')
                                                        ],),
                                                      ),
                                                      PopupMenuItem<String>(
                                                    value: "Edit",
                                                        child: Row(children: <Widget>[
                                                    IconButton(icon: Icon(Icons.edit),color: Colors.blue,),
                                                          Text('Edit')
                                                    ],),
                                                    ),
                                                      PopupMenuItem<String>(
                                                        value: "Note",
                                                        child:Row(children: <Widget>[
                                                          IconButton(icon: Icon(Icons.note),color: Colors.blue,)
                                                          ,Text('View Extra Note')
                                                        ],),
                                                      ),
                                                      PopupMenuItem<String>(
                                                        value:"PDF",
                                                        child: Row(children: <Widget>[
                                                          IconButton(icon: Icon(Icons.insert_drive_file),color: Colors.blue,)
                                                          ,Text('View PDF')
                                                        ],),
                                                      ),
                                                    ];
                                                  },
                                                  onSelected:(value){
                                                    _onSelect(value,index,order);
                                                  }

                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                            }
                        );
                      }
                    }
                  },
                ),
              ),
            )
          ]
      ),
    );
  }

  _onSelect(value,int index, final order) {
    switch(value) {
      case 'Delete':
        delete(index,order);
        break;
      case 'Edit':
        _displayDialog(
            context, order[index]);
        break;
      case 'Note':
        displayNote(index,order);
        break;
      case'PDF':
        break;
      default:
        print("NOT WORKING");
break;
    }
  }
  _getOrderID(final order, index) {
    return order[index]['Ref'];
  }
  delete(int index, final order) async {
    {
      OrderProvider.deleteOrder (
          order[index]['id'] );
      await Navigator.of ( context )
          .push ( MaterialPageRoute (
          builder: (context) =>
              Dashboard ( )
      ) );
      setState ( () {} );
    }
  }
  displayNote(int index, final order) {
    Widget dialog = new AlertDialog(
      content: Text('${order[index]['Notes']}'),
    );
    return dialog;
  }

}


