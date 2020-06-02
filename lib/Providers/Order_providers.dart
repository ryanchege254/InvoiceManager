
import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:orderapp/views/ItemList.dart';
import 'package:flutter/material.dart';
import 'package:orderapp/views/Dashboard.dart';


class OrderProvider  {

  static Database db;

   static Future open() async {
    db = await openDatabase(
        join(await getDatabasesPath(), 'orders.db'),
        version: 3,
        onCreate: (Database db, int version) async {
          await db.execute('''
        create table Orders(
        id integer primary key autoincrement, 
        Ref text not null,
        OrderDate text not null,
        Supplier text not null,
        Notes text not null,
        Month text not null,
        Year text not null
        );
        ''');
          await db.execute('''
        create table Items(
        id integer primary key autoincrement, 
        refID text not null,
        Quantity float not null,
        Unit text not null,
        TypeOfProduct text not null, 
        UnitPrice float not null,
        TotalPrice float not null
        );
        ''');
        }
    );
  }

  static int id; //ID of order from table 'Orders'

  static Future <List<Map<String, dynamic>>> getOrderList() async {
    if (db == null) {
      await open();
    }
    return await db.rawQuery('select * from Orders order by id desc'); }

  static Future <List<Map<String, dynamic>>> getItemList() async {
    if (db == null) {
      await open();
    }
    return await db.rawQuery('select * from Items where refID = ?',[]);
  }

    static Future insertOrder(Map<String, dynamic> order) async {
    await db.insert("Orders", order);
  }

  static  Future insertItem(Map<String, dynamic> item) async {
    await db.insert("Items", item);
  }

  static Future updateOrder(Map<String, dynamic> order) async {
    await db.update(
        "Orders",
        order,
        where: 'id = ?',
        whereArgs: [order['id']]);
  }



   static Future updateItems(Map<String, dynamic> item) async {
    await db.update(
        "Items",
        item,
        where: 'id = ?',
        whereArgs: [item['id']]);
  }

   static Future deleteOrder(int id) async {
    await db.delete(
        "Orders",
        where: 'id = ?',
        whereArgs: [id]
    );
  }

   static Future deleteItems(int id) async {
    await db.delete(
        "Items",
        where: 'id = ?',
        whereArgs: [id]
    );
  }

   Future calculateTotal() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'select total(TotalPrice) as ItemTotal from Items');
    int value = result[0]['sum(TotalPrice)'];
    return result.toList();
  }
  int _total;

  /* void _calcTotal() async{
    var total = (await db.calculateTotal())[0]['ItemTotal'];
    print(total);
  }*/




}