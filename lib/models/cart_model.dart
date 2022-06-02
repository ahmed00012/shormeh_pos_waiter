

import 'notes_model.dart';

class CartModel {
  int? id;
  int? rowId;
  String? departmentId;
  String? image;
  String? mainName;
  String? mainNameNewLine;
  double? price;
  String? size;
  String? drink;
  int? count;
  List<NotesModel>? extra;
  String? extraNotes;
  double? total;
  String? orderMethod;
  int? orderMethodId;
  int? table;
  String? time;
  bool updated;
  int? orderStatus;
  String? payment ;
  String? selectCustomer ;


  CartModel(
      {this.id,
        this.rowId,
        this.departmentId,
        this.image,
        this.mainName,
        this.mainNameNewLine,
        this.price,
        this.count,
        this.size,
        this.drink,
        this.extra,
        this.extraNotes,
        this.total,
        this.orderMethod,
        this.time,
        this.table,this.updated=false,this.orderMethodId,this.orderStatus,
        this.payment,this.selectCustomer,
      });
}



