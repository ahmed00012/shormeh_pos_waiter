
import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:enough_convert/windows/windows1256.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:image/image.dart' as img;
import 'package:shormeh_pos_waiter/models/details_model.dart';
import '../constants.dart';
import '../local_storage.dart';
import '../models/cart_model.dart';
import '../models/printers_model.dart';
import '../models/tables_model.dart';
import '../repositories/new_order_repository.dart';
import 'home_controller.dart';

final tablesFuture = ChangeNotifierProvider.autoDispose<TablesController>(
        (ref) => TablesController());

class TablesController extends ChangeNotifier {

  NewOrderRepository repo = NewOrderRepository();

  TableModel? chosenTable = TableModel();
  List<Department> departments = [];
  bool loading = false;
  List<PrinterModel> printers = [];
  List<CartModel> cardItemsCopy = [];
  int? chosenOrder;
  int? chosenDepartment;
  String? chosenOrderNum;
  TableModel? currentOrder;


  TablesController(){
    getTables();
  }

  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
  }


  getCurrentOrder(int index,int i){
    chosenDepartment=index;
    chosenOrder = i;
    chosenOrderNum = departments[index].tables![i].currentOrder!.uuid;
     currentOrder= departments[chosenDepartment!].tables![chosenOrder!];
    notifyListeners();
  }

  void refresh(){
    notifyListeners();
  }

  void reserveTable(int i, TableModel table) {
    chosenTable = table;
    departments[i].tables!.forEach((element) {element.chosen=false;});
    table.chosen = true;
    notifyListeners();
  }

  void getTables() async {

    var data = await repo.getTables(
        LocalStorage.getData(key: 'token'),
        LocalStorage.getData(key: 'language'),
        LocalStorage.getData(key: 'branch'));
    departments = List<Department>.from(data.map((e) => Department.fromJson(e)));
    departments.forEach((element) {element.tables!.forEach((element) {element.chosen=false;});});
    print(departments[0].tables![0].title);
    // tables.forEach((element) {
    //   element.chosen = false;
    // });
    notifyListeners();
  }



  Future getPrinters() async {
    if (LocalStorage.getData(key: 'printers') == null) {
      var data = await repo.getPrinters(LocalStorage.getData(key: 'token'),
          LocalStorage.getData(key: 'branch').toString());
      LocalStorage.saveData(key: 'printers', value: json.encode(data));
      printers =
      List<PrinterModel>.from(data.map((e) => PrinterModel.fromJson(e)));
    }
    else {
      printers = List<PrinterModel>.from(json
          .decode(LocalStorage.getData(key: 'printers'))
          .map((e) => PrinterModel.fromJson(e)));
    }
    notifyListeners();
  }

  Future confirmOrder(int numOfGuests,String customerPhone,String customerName,TableModel table) async {
    List<Map> details = [];
    List<CartModel> cardItemsCopy=List.from(HomeController.cartItems);
    cardItemsCopy[0].orderMethod = 'restaurant'.tr();
    switchLoading(true);
    await getPrinters();
    HomeController.cartItems.forEach((element) {
      List<String>? notes = [];
      if (element.extra != null) {
        element.extra!.forEach((e) {
          notes.add(e.id.toString());
        });
      }
      details.add(Details(
        id: element.id,
        quantity: element.count,
        notes: notes,
      ).toJson());
    });
    var data = await repo.confirmOrder(LocalStorage.getData(key: 'token'),
        LocalStorage.getData(key: 'language'), {
          "phone":customerPhone ,
          "name": customerName,
          "order_method_id": 2,
          "details": details,
          "payment_status": 0,
          "table_id": table.id,
          "clients_count":numOfGuests,
        });
    if (data != false) {
      displayToastMessage(
          'order'.tr() + ' ${data['uuid']} ' + 'createdSuccessfully'.tr(),
          false);

      testPrint(
        time: DateTime.now().toString().substring(0, 16),
        orderNo: data['uuid'].toString(),
        discount: data['discount'].toString(),
        tax: data['tax'].toString(),
        total: data['total'].toString(),
        amount: data['paid_amount'].toString(),
        notes: data['notes']??'',
        cart: cardItemsCopy,
        customerName: customerName,
        customerNumber: customerPhone,
      );

      closeOrder();
      switchLoading(false);
    } else {
      displayToastMessage('orderFailed'.tr(), true);
      switchLoading(false);
    }

    return data;
  }



  Future updateFromOrder(
      int itemId, BuildContext context,String customerPhone,String customerName,) async {
    switchLoading(true);
    List<CartModel> cardItemsCopy=List.from(HomeController.cartItems);

    List<Map> details = [];
    List<int> notes = [];

    if(printers.isNotEmpty) {
      HomeController.cartItems.forEach((element) {
        notes = [];
        if (element.updated) {
          element.extra!.forEach((e) {
            notes.add(e.id!);
          });
          details.add({
            'product_id': element.id,
            'quantity': element.count.toString(),
            'notes': notes,
          });
        }
      });

      var data = await repo.updateFromOrder(LocalStorage.getData(key: 'token'),
          LocalStorage.getData(key: 'language'), itemId, {
            'details': details,
            'payment_status': 0,
            'finish':  0 ,
            "phone":customerPhone,
            "name":customerName
          });
      if (data != false) {
        displayToastMessage(
            'order'.tr() +
                ' ${data['data']['uuid']} ' +
                'updatedSuccessfully'.tr(),
            false);
        await testPrint(
          time: DateTime.now().toString().substring(0, 16),
            orderNo: data['data']['uuid'].toString(),
            discount: data['data']['discount'].toString(),
            tax: data['data']['tax'].toString(),
            total: data['data']['total'].toString(),
            amount: data['data']['paid_amount'].toString(),
          notes: data['data'][
          'notes']??'',
          cart: cardItemsCopy,
          customerName: customerName,
          customerNumber: customerPhone,
        );
        closeOrder();

        switchLoading(false);
      }
    }
  }

  void closeOrder() {
    HomeController.cartItems = [];
    departments.forEach((element) {element.tables!.forEach((element) {element.chosen=false;});});
    HomeController.totalAfterDiscount = 0.0;
    HomeController.discount = '';
    chosenTable = null;
    notifyListeners();
  }

  mainNameItem(){
    cardItemsCopy = HomeController.cartItems;
    for(int i =0 ; i< cardItemsCopy.length ;i++) {
      if (cardItemsCopy[i].mainName!.length > 17) {
        for (int j = 14; j <= cardItemsCopy[i].mainName!.length; j++) {
          if (cardItemsCopy[i].mainName![j] == ' ') {
            cardItemsCopy[i].mainNameNewLine =
                cardItemsCopy[i].mainName!.substring(j);
            cardItemsCopy[i].mainName =
                cardItemsCopy[i].mainName!.substring(0, j);
          }
        }
      }

      else
        cardItemsCopy[i].mainName = cardItemsCopy[i].mainName!;

    }
    notifyListeners();

  }



  Uint8List textEncoder(String word){
    return Uint8List.fromList(Windows1256Codec(allowInvalid: false).encode(word));
  }




  void testReceiptKitchen(
      NetworkPrinter printer,
      String time,
      String orderNo,
      List<CartModel> products,
      String orderTotal,
      String notes
      ) async {
    printer.setGlobalCodeTable('CP775');

    printer.hr(ch: '_');
    printer.textEncoded(textEncoder('orderNumber'.tr() + ' ' + orderNo),
        styles: PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    printer.hr(ch: '_', linesAfter: 1);

    printer.textEncoded(
        textEncoder(
          LocalStorage.getData(key: 'branchName'),
        ),
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
        ));
    printer.text(time,
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
        ));


    printer.hr(ch: '_');
    if (LocalStorage.getData(key: 'language') == 'en')
    {

      printer.row([
        PosColumn(
          text: '',
          width: 1,
        ),
        PosColumn(
            textEncoded: textEncoder('qty'.tr()),
            width: 3,
            styles: PosStyles(
                bold: true,
                align: PosAlign.left
            )),
        PosColumn(
            textEncoded: textEncoder('item'.tr()),
            width:  8,
            styles: PosStyles(bold: true, align: PosAlign.left)),
      ]);
      printer.hr(ch: '_');
      products.forEach((element) {
        printer.row([
          PosColumn(
            text: '',
            width: 1,
          ),
          PosColumn(
              text: element.count.toString(),
              width: 3,
              styles: PosStyles(align: PosAlign.left,bold: true)),
          PosColumn(
              textEncoded: textEncoder(element.mainName!),
              width: 8,
              styles: PosStyles(align: PosAlign.left,bold: true)),

        ]);
        if (element.extra!.isNotEmpty) {
          element.extra!.forEach((option) {
            printer.row([
              PosColumn(
                text:  ' ',
                width:  4,
              ),
              PosColumn(
                  textEncoded: textEncoder(option.title!),
                  width:  8,
                  styles: PosStyles(
                      align:  PosAlign.left)),

            ]);
          });
        }
        if(element.extraNotes!=null)
          printer.row([
            PosColumn(text: '', width: 4),
            PosColumn(
                textEncoded: textEncoder(element.extraNotes!),
                width: 8,
                styles: PosStyles(
                    align:  PosAlign.left)),

          ]);
        printer.emptyLines(1);
      });}
    else
    {

      printer.row([

        PosColumn(
            textEncoded: textEncoder('item'.tr()),
            width:  8,
            styles: PosStyles(bold: true, align: PosAlign.right)),


        PosColumn(
            textEncoded: textEncoder('qty'.tr()),
            width: 3,
            styles: PosStyles(
                bold: true,
                align: PosAlign.right
            )),
        PosColumn(
          text: '',
          width: 1,
        ),

      ]);
      printer.hr(ch: '_');
      products.forEach((element) {
        printer.row([


          PosColumn(
              textEncoded: textEncoder(element.mainName!),
              width: 8,
              styles: PosStyles(align: PosAlign.right,bold: true)),
          PosColumn(
              text: element.count.toString(),
              width: 3,
              styles: PosStyles(align: PosAlign.right,bold: true)),
          PosColumn(
            text: '',
            width: 1,
          ),

        ]);
        if (element.extra!.isNotEmpty) {
          element.extra!.forEach((option) {
            printer.row([
              PosColumn(
                  textEncoded: textEncoder(option.title!),
                  width:  8,
                  styles: PosStyles(
                      align:  PosAlign.right)),
              PosColumn(
                text:  ' ',
                width:  4,
              ),


            ]);
          });
        }
        if(element.extraNotes!=null)
          printer.row([
            PosColumn(
                textEncoded: textEncoder(element.extraNotes!),
                width: 8,
                styles: PosStyles(
                    align:  PosAlign.right)),
            PosColumn(text: '', width: 4),


          ]);
        printer.emptyLines(1);
      });}
    if(notes.isNotEmpty)
      printer.hr();
    if(notes.isNotEmpty)
      printer.textEncoded(
          textEncoder(
              'notes'.tr()
          ),
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
          ));
    printer.textEncoded(
        textEncoder(
            notes
        ),
        styles: PosStyles(
          align: PosAlign.center,
        ));
    printer.hr(ch: '_');

    printer.feed(2);
    printer.cut();
  }

  Future testPrint(
      {String? time,
        String? orderNo,
        String? discount,
        String? tax,
        String? total,
        String? amount,
        List<CartModel>? cart,
        String ?notes,
        String ?customerName,
        String? customerNumber}) async {

    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    printers.forEach((element) async {
      print(element.ip);
      PosPrintResult res = await printer.connect(element.ip!, port: 9100);
      if (element.typeName == 'CASHIER'  ) {

        if (res == PosPrintResult.success) {
          // testReceipt(printer, time!, orderNo!, discount!, tax!, total!, amount!,
          //     cart, customerName!,customerNumber!,notes!,false);
          printer.disconnect();
        }

        print('Print result: ${res.msg}');
      }
      else if (element.typeName == 'Deliver' ) {
        if (res == PosPrintResult.success) {
          print('from Deliver ' + element.ip.toString()+element.typeName!);
            testReceiptKitchen(printer, time!, orderNo!, cart!, total!,notes!);
          printer.disconnect();

        }
        print('Print result: ${res.msg}');
      }
      else {

        if (res == PosPrintResult.success) {

          print('from kitchen ' + element.ip.toString());
          List<CartModel> newList = [];
          cart!.forEach((product) {
            if (element.departmentId == product.departmentId) {
              newList.add(product);
              print(product.mainName);
            }
          });
          if (newList.isNotEmpty) {
            testReceiptKitchen(printer, time!, orderNo!, newList,total!,notes!);
          }
          printer.disconnect();
        }
        print('Print result: ${res.msg}');
      }

    });

    notifyListeners();
  }

  void displayToastMessage(var toastMessage, bool alert) {
    showSimpleNotification(
        Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                toastMessage,
                style: TextStyle(
                    color: alert ? Colors.white : Constants.mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        duration: Duration(seconds: 3),
        elevation: 2,
        background: alert ? Colors.red[500] : Constants.secondryColor);
  }
}