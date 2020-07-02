import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:orderapp/info/Items.dart';
import 'package:orderapp/Providers/Order_providers.dart';

class ItemListState extends StatefulWidget {
  int order;
  ItemListState({this.order});

  @override
  State<StatefulWidget> createState() => _Items();
}

class _Items extends State<ItemListState> with SingleTickerProviderStateMixin {
  List<String> unitmeasurement = [
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

  getDropDownItem() {
    setState(() {
      holder = dropDownValue;
    });
    return holder;
  }

  getTotalPrice() {
    setState(() {
      total = Items(
              _typeController.text,
              holder,
              double.parse(_quantityController.text),
              double.parse(_unitpriceController.text))
          .calc();
    });
    return total;
  }

  @override
  void initState() {
    _total = total;
    _calcTotal();
    super.initState();
  }

  @override
  void dispose() {
    _typeController.dispose();
    _quantityController.dispose();
    _unitpriceController.dispose();
    super.dispose();
  }

  getItems(int orderId) async {
    var items = await OrderProvider.getItemList(orderId);
    //print resut
    print("################items " + "$items");
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text("Items", style: TextStyle(color: Colors.white)),
      ),
      body: showItems(),
      // ItemList(key: _key),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _displayDialog(context);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<String> suggestionList;

//find and create list of matched strings
  List<String> _getSuggestions(String query) {
    List<String> matches = List();

    matches.addAll(suggestionList);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  //get suggestion from db
  void _getSuggestionList() async {
    suggestionList = await OrderProvider.getItemSuggestion();
  }

  _displayDialog(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add your Items'),
          content: Container(
            child: Center(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: this._typeController,
                  autocorrect: true,
                  decoration: InputDecoration(hintText: "Product Name"),
                ),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: this._typeController,
                    autocorrect: true,
                    autofocus: true,
                    decoration: InputDecoration(hintText: "Product Name"),
                  ),
                  suggestionsCallback: (suggestion) async {
                    return _getSuggestions(suggestion);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    this._typeController.text = suggestion;
                  },
                ),
                TextField(
                  controller: _unitpriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Unit Price"),
                ),
                Row(
                  children: <Widget>[
                    Container(
                        width: 100,
                        child: TextField(
                          controller: _quantityController,
                          decoration: InputDecoration(hintText: "Quantity"),
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ], // Only
                          keyboardType:
                              TextInputType.number, // numbers can be entered,
                        )),
                    DropdownButton<String>(
                        value: dropDownValue,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 20,
                        elevation: 15,
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String data) {
                          dropDownValue = data;
                          setState(() {
                            dropDownValue = data;
                          });
                        },
                        items: unitmeasurement.map((unitmeasurement) {
                          return DropdownMenuItem<String>(
                            child: Text(unitmeasurement),
                            value: unitmeasurement,
                          );
                        }).toList())
                  ],
                ),
              ],
            )),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.lightGreen,
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: Colors.lightGreen,
              child: Text(
                'ADD',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                OrderProvider.insertItem({
                  'refID': widget.order, //fetch refID from Order item selected
                  'Quantity': _quantityController.text,
                  'Unit': getDropDownItem().toString(),
                  'TypeOfProduct': _typeController.text,
                  'UnitPrice': _unitpriceController.text,
                  'TotalPrice': getTotalPrice()
                });
                _calcTotal();
                Navigator.of(context).pop();
                setState(() {});
              },
            )
          ],
        );
      },
    );
  }

  double _total;

  void _calcTotal() async {
    var total =
        (await OrderProvider().calculateTotal(widget.order))[0]['Total'];
    print(total);

    setState(() {
      _total = total;
    });
  }

  Widget showItems() {
    return Container(
        color: Colors.blueGrey,
        child: Column(children: <Widget>[
          Container(
              color: Colors.amberAccent,
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Center(
                child: Text(
                  "Total Amount: Kshs ${_total != null ? _total : 'waiting ...'} ",
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )),
          FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final item = snapshot.data;
                if (item < 1) {
                  return Center(
                    child: Text('No Items!, Create New one'),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: item.length,
                      itemBuilder: (BuildContext context, index) {
                        return new GestureDetector(
                            child: Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 4.0),
                                          child: Row(children: <Widget>[
                                            Text(
                                              "${item[index]['Quantity']} "
                                              "${item[index]['Unit']} "
                                              "${item[index]['TypeOfProduct']}",
                                              style:
                                                  new TextStyle(fontSize: 20.0),
                                            ),
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, bottom: 8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "KSHS:${item[index]['UnitPrice']}",
                                                    style: new TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    "KSHS:${item[index]['TotalPrice']}",
                                                    style: new TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.green),
                                                  ),
                                                  Spacer(),
                                                  IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      _displayDialogUpdate(
                                                          context, item, index);
                                                    },
                                                  ),
                                                  IconButton(
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () async {
                                                        OrderProvider
                                                            .deleteItems(
                                                                item[index]
                                                                    ['id']);
                                                        _calcTotal();
                                                        setState(() {});
                                                      })
                                                ],
                                              ),
                                            )
                                          ]))
                                    ]))));
                      }),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )
        ]));
  }

  _displayDialogUpdate(BuildContext context, item, index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add your Items'),
          content: Container(
            child: Center(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _typeController,
                  decoration: InputDecoration(hintText: "Product Name"),
                ),
                TextField(
                  controller: _unitpriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Unit Price"),
                ),
                Row(
                  children: <Widget>[
                    Container(
                        width: 100,
                        child: TextField(
                          controller: _quantityController,
                          decoration: InputDecoration(hintText: "Quantity"),
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ], // Only
                          keyboardType:
                              TextInputType.number, // numbers can be entered,
                        )),
                    DropdownButton<String>(
                        value: dropDownValue,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 20,
                        elevation: 15,
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String data) {
                          dropDownValue = data;
                          setState(() {
                            dropDownValue = data;
                          });
                        },
                        items: unitmeasurement.map((unitmeasurement) {
                          return DropdownMenuItem<String>(
                            child: Text(unitmeasurement),
                            value: unitmeasurement,
                          );
                        }).toList())
                  ],
                ),
              ],
            )),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.lightGreen,
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: Colors.lightGreen,
              child: Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                OrderProvider.updateItems({
                  'id': item[index]['id'],
                  'Quantity': double.parse(_quantityController.text),
                  'Unit': holder.toString(),
                  'TypeOfProduct': _typeController.text,
                  'UnitPrice': double.parse(
                    _unitpriceController.text,
                  ),
                  'TotalPrice': getTotalPrice()
                });
                _calcTotal();
                /*_key.currentState.
                addItem(Items(
                    _typeController.text,
                    dropDownValue,
                    double.parse(_quantityController.text),
                    double.parse(_unitpriceController.text)));*/
                await Navigator.of(context).pop();
                setState(() {});
              },
            )
          ],
        );
      },
    );
  }
}

class _update extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Updated();
  }
}

class Updated extends State<_update> {
  @override
  Widget build(BuildContext context) {
    var item, index;
    return _displayDialogUpdate(context, item, index);
  }

  List<String> unitmeasurement = [
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

  getDropDownItem() {
    setState(() {
      holder = dropDownValue;
    });
    return holder;
  }

  getTotalPrice() {
    setState(() {
      total = Items(
              _typeController.text,
              holder,
              double.parse(_quantityController.text),
              double.parse(_unitpriceController.text))
          .calc();
    });
    return total;
  }

  @override
  void dispose() {
    _typeController.dispose();
    _quantityController.dispose();
    _unitpriceController.dispose();
    super.dispose();
  }

  _displayDialogUpdate(BuildContext context, item, index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add your Items'),
          content: Container(
            child: Center(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _typeController,
                  decoration: InputDecoration(hintText: "Product Name"),
                ),
                TextField(
                  controller: _unitpriceController,
                  decoration: InputDecoration(hintText: "Unit Price"),
                ),
                Column(
                  children: <Widget>[
                    Container(
                        width: 100,
                        child: TextField(
                          controller: _quantityController,
                          decoration: InputDecoration(hintText: "Quantity"),
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ], // Only
                          keyboardType:
                              TextInputType.number, // numbers can be entered,
                        )),
                    DropdownButton<String>(
                        value: dropDownValue,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 20,
                        elevation: 15,
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String data) {
                          dropDownValue = data;
                          setState(() {
                            dropDownValue = data;
                          });
                        },
                        items: unitmeasurement.map((unitmeasurement) {
                          return DropdownMenuItem<String>(
                            child: Text(unitmeasurement),
                            value: unitmeasurement,
                          );
                        }).toList())
                  ],
                ),
              ],
            )),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.lightGreen,
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: Colors.lightGreen,
              child: Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                OrderProvider.updateItems({
                  'id': item[index]['id'],
                  'Quantity': double.parse(_quantityController.text),
                  'Unit': holder.toString(),
                  'TypeOfProduct': _typeController.text,
                  'UnitPrice': double.parse(
                    _unitpriceController.text,
                  ),
                });
                /*_key.currentState.
                addItem(Items(
                    _typeController.text,
                    dropDownValue,
                    double.parse(_quantityController.text),
                    double.parse(_unitpriceController.text)));*/
                await Navigator.of(context).pop();
                setState(() {});
              },
            )
          ],
        );
      },
    );
  }
}
