import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:shormeh_pos_waiter/models/products_model.dart';
import 'package:shormeh_pos_waiter/models/tables_model.dart';
import '../constants.dart';
import '../local_storage.dart';
import '../models/cart_model.dart';
import '../models/categories_model.dart';
import '../repositories/products_repository.dart';

final dataFuture =
    ChangeNotifierProvider.autoDispose<HomeController>((ref) => HomeController());

class HomeController extends ChangeNotifier {
  ProductsRepo productsRepo = ProductsRepo();
  var categories = [];
  static List<CartModel> cartItems = [];
  static double total = 0.0;
  static String discount = '';
  static double totalAfterDiscount = 0.0;
  // var selectedTab = SelectedTab.tables;
  // Widget current = Tables();
  bool addMore = false;
  int? chosenItem;
  bool itemWidget = false;
  late double tax = double.parse(LocalStorage.getData(key: 'tax').toString()) / 100;
 late String branchName = LocalStorage.getData(key: 'branchName');
  bool options = false;

  static int? categoryID;
  List<ProductModel> products = [];
  List<ProductModel> optionsList = [];
  bool loading = true;
   int branch = LocalStorage.getData(key: 'branch');
  bool updateOrder = false;
  static int? orderUpdatedId;

   TextEditingController customerName = TextEditingController();
   TextEditingController customerPhone = TextEditingController();
  String lan = 'en';
  // TextEditingController notes =TextEditingController();

  bool tablesWidget =true;
  bool homeWidget = false;

TableModel ?table ;

  HomeController() {
      getCategories();
      getNotes();
      getLanguage();
  }



  refresh(){
    notifyListeners();
  }

tabViewController(int i){
    if(i==0) {
      tablesWidget = true;
      homeWidget = false;
    }
    else{
      tablesWidget = false;
      homeWidget = true;
    }
    notifyListeners();
  }

  void removeCartItem(int i) {
    if (updateOrder) {
      if(cartItems[i].rowId!=null)
      deleteFromOrder(cartItems[i].rowId!);
      // totalEditing = totalEditing - cardItems[i].total!.toDouble();

    }

    total = 0.0;
    cartItems.removeAt(i);
    if(cartItems.isNotEmpty){
      cartItems[0].updated=true;
    }
    cartItems.forEach((element) {
      total = total + element.price!;
    });
    if(cartItems.isEmpty){
      table=null;
    }
    switchToCardItemWidget(false);

    notifyListeners();
  }

  void emptyCardList() {
    cartItems = [];
    total = 0.0;
    discount = '';
    totalAfterDiscount = 0.0;
    itemWidget = false;
    updateOrder = false;
    table=null;
    notifyListeners();
  }
  void switchToCardItemWidget(bool switchTo, {int? i}) {
    itemWidget = switchTo;
    chosenItem = i;
    notifyListeners();
  }

  void minusController(int i) {
    double totalOptions = 0.0;
    cartItems[i].extra!.forEach((element) {
      totalOptions = totalOptions + element.price!;
    });
    if (cartItems[i].count! > 1) {
      cartItems[i].count = cartItems[i].count! - 1;
      cartItems[i].total =
          cartItems[i].price! * cartItems[i].count! + totalOptions;
      total = total - (cartItems[i].price! + totalOptions);
      if (updateOrder) {
        cartItems[i].updated = true;
      }
      notifyListeners();
    }
    else if(cartItems[i].count! == 1)
    {
      cartItems.removeAt(i);
      // cartItems[i].count = cartItems[i].count! - 1;
      // cartItems[i].total =
      //     cartItems[i].price! * cartItems[i].count! + totalOptions;
      // total = total - (cartItems[i].price! + totalOptions);
      // if (updateOrder) {
      //   cartItems[i].updated = true;
      // }
      notifyListeners();
    }
  }

  void plusController(int i) {
    double totalOptions = 0.0;
    cartItems[i].extra!.forEach((element) {
      totalOptions = totalOptions + element.price!;
    });
    cartItems[i].count = cartItems[i].count! + 1;
    cartItems[i].total =
        cartItems[i].price! * cartItems[i].count! + totalOptions;
    total = total + cartItems[i].price! + totalOptions;
    if (updateOrder) {
      cartItems[i].updated = true;
    }

    notifyListeners();
  }

  void textCountController(int i) {
    total = total - cartItems[i].total!;
    // totalEditing =totalEditing - cardItems[i].total! ;
    double totalOptions = 0.0;
    cartItems[i].extra!.forEach((element) {
      totalOptions = totalOptions + element.price!;
    });
    cartItems[i].total =
        cartItems[i].price! * cartItems[i].count! + totalOptions;
    total = total + cartItems[i].total!;

    if (updateOrder) {
      cartItems[i].updated = true;
      // totalEditing = totalEditing + cardItems[i].total!;
    }
    notifyListeners();
  }

  void switchLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future getCategories() async {
    switchLoading(true);
    List<String> categoriesId = [];
    var data = await productsRepo.getAllCategories(
        LocalStorage.getData(key: 'branch'),
        LocalStorage.getData(key: 'token'),
        LocalStorage.getData(key: 'language'));
    log(data.toString());
    categories = data['data']
        .map((category) => CategoriesModel.fromJson(category))
        .toList();

    categories.forEach((element) {
      categoriesId.add(element.id.toString());
    });
    LocalStorage.saveList(key: 'categoriesId', value: categoriesId);

    getProducts(categories[0].id);
    categories[0].chosen = true;

    notifyListeners();
  }

  void chooseCategory(int i) {
    if (i == 0) {
      categories.forEach((element) {
        element.chosen = false;
      });
      options = true;
    } else {
      categories.forEach((element) {
        element.chosen = false;
      });
      categories[i - 1].chosen = true;
    }
    notifyListeners();
  }



  void synchronize(BuildContext context) {
    List cats = LocalStorage.getList(key: 'categoriesId');
    cats.forEach((element) {
      LocalStorage.removeData(key: 'products${int.parse(element)}');
    });
    if (LocalStorage.getData(key: 'orderMethods') != null)
      LocalStorage.removeData(key: 'orderMethods');
    if (LocalStorage.getData(key: 'options') != null)
      LocalStorage.removeData(key: 'options');
    if (LocalStorage.getData(key: 'categoriesId') != null)
      LocalStorage.removeData(key: 'categoriesId');
    if (LocalStorage.getData(key: 'paymentMethods') != null)
      LocalStorage.removeData(key: 'paymentMethods');
    if (LocalStorage.getData(key: 'orderStatus') != null)
      LocalStorage.removeData(key: 'orderStatus');
    if (LocalStorage.getData(key: 'paymentCustomers') != null)
      LocalStorage.removeData(key: 'paymentCustomers');
    if (LocalStorage.getData(key: 'coupons') != null)
      LocalStorage.removeData(key: 'coupons');
    if (LocalStorage.getData(key: 'printers') != null)
      LocalStorage.removeData(key: 'printers');

    notifyListeners();
  }

  String getLanguage() {
    lan = LocalStorage.getData(key: 'language');
    notifyListeners();
    return lan;
  }

  changeLanguage(String language) {
    LocalStorage.saveData(key: 'language', value: language);
    lan = language;
    notifyListeners();
  }

  Future getProducts(int id) async {

    switchLoading(true);
    products = [];
    if (LocalStorage.getData(key: 'products$id') == null) {
      final data = await productsRepo.getAllProducts(
          LocalStorage.getData(key: 'branch'),
        id.toString(),
        LocalStorage.getData(key: 'token'),
          LocalStorage.getData(key: 'language')
      );
      LocalStorage.saveData(key: 'products$id', value: json.encode(data));
      products = List<ProductModel>.from(
          data.map((product) => ProductModel.fromJson(product)));
    } else {
      products = List<ProductModel>.from(json
          .decode(LocalStorage.getData(key: 'products$id'))
          .map((product) => ProductModel.fromJson(product)));
    }

    switchLoading(false);
    notifyListeners();
  }

  Future getNotes() async {
    if (LocalStorage.getData(key: 'options') == null) {
      final data =
          await productsRepo.getNotes(LocalStorage.getData(key: 'token'), LocalStorage.getData(key: 'language'));
      LocalStorage.saveData(key: 'options', value: json.encode(data));
      optionsList =
          List<ProductModel>.from(data.map((e) => ProductModel.fromJson(e)));
    } else {
      optionsList = List<ProductModel>.from(json
          .decode(LocalStorage.getData(key: 'options'))
          .map((e) => ProductModel.fromJson(e)));
    }
    notifyListeners();
    // }
  }

  Future deleteFromOrder(int itemId) async {
    var data = await productsRepo.deleteFromOrder(
        LocalStorage.getData(key: 'token'), LocalStorage.getData(key: 'language'), itemId);
    print(data);
    notifyListeners();
  }



  void displayToastMessage(var toastMessage, bool alert) {
    showSimpleNotification(
        Container(
          height: 50,
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
