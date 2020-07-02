import 'package:sqflite/sqflite.dart';

class Items{
  String type_of_product;
  String Unit;
  double Quantity;
  double Unit_price;
  double Total_price ;

   calc(){
    Total_price = Quantity * Unit_price;
    return Total_price;
}

  Items(
      this.type_of_product,
      this.Unit,
      this.Quantity,
      this.Unit_price

      );

  Map<String, dynamic> toJson() => {
    'Type of product': type_of_product,
    'Unit Price':Unit_price,
    'Quantity': Quantity,
    'Total price':Total_price

  };
  Map<String, dynamic> toMap()  {
    var map =Map<String, dynamic>();
    map['Type of product']= type_of_product;
    map['Unit Price']= Unit_price;
    map['Quantity']= Quantity;
    map['Total price']= Total_price;
  }

}