 import 'package:orderapp/info/Items.dart';

class Orders{

  String RefNo;
  DateTime dateTime;
  String Supplier;
  String Notes;
  String type_of_product;
  String Unit;
  double Quantity;
  double Unit_price;
  double Total_price ;

  calc(){
    Total_price = Quantity * Unit_price;
    return Total_price;
  }


  Orders( this.RefNo,
    this.dateTime,
    this.Supplier,
      this.Notes

  );
 /* factory Orders.fromJson(Map<String, dynamic> json) => Orders(
    RefNo: json["title"] == null ? null : json["title"],
  );
*/
  Map<String, dynamic> toJson() => {
    'Ref No': RefNo,
    'Date':dateTime,
    'Supplier': Supplier,
    'Notes':Notes

  };

}
