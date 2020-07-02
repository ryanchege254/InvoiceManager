import 'package:flutter/material.dart';

class _dataTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return dataTable();
  }
}

class dataTable extends State<_dataTable> {
  Widget bodydata() => DataTable(
        columns: <DataColumn>[
          DataColumn(
            label: Text('Id'),
            numeric: false,
          ),
          DataColumn(
            label: Text('refId'),
            numeric: false,
          ),
          DataColumn(
            label: Text('Product'),
            numeric: false,
          ),
          DataColumn(
            label: Text('Quantity'),
            numeric: false,
          ),
          DataColumn(
            label: Text('UnitPrice'),
            numeric: false,
          ),
          DataColumn(
            label: Text('TotalPrice'),
            numeric: false,
          ),
        ],
        rows: <DataRow>[],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table Preview'),
        actions: <Widget>[],
      ),
      body: Container(
        child: bodydata(),
      ),
    );
  }
}
