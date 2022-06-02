import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';


class ProductsRepo {


  Future getAllCategories(int branchID, String token,String language) async {
    print(token);
    var response = await http.get(
      Uri.parse("${Constants.baseURL}branch/$branchID/categories"),
    headers:  {'AUTHORIZATION':'Bearer $token','Language':language},
    );
    if(response.statusCode==200){
      var data = json.decode(response.body);
      return data;
    }
    else return false;

  }


  Future getAllProducts(int branchID,String category, String token,String language) async {
    var response = await http.get(
      Uri.parse("${Constants.baseURL}branch/$branchID/category/$category/products"),
      headers:  {'AUTHORIZATION':'Bearer $token','Language':language},
    );
    if(response.statusCode==200){
      var data = json.decode(response.body);
      return data['data'];
    }
    else return false;
  }



  Future getNotes(String token,String language) async {
    var response = await http.get(
      Uri.parse("${Constants.baseURL}notes"),
      headers:  {'AUTHORIZATION':'Bearer $token','Language': language},
    );
    if(response.statusCode==200){
      var data = json.decode(response.body);
      return data['data'];
    }
    else return false;
  }

  Future deleteFromOrder(String token,String language,int itemId) async {
    print(token);
    var response = await http.post(
      Uri.parse("${Constants.baseURL}order/deleteDetails/$itemId"),
      headers:  {'AUTHORIZATION':'Bearer $token','Language': language},
    );
    print(itemId);
    print(response.body);
    if(response.statusCode==200){
      var data = json.decode(response.body);
      return data;
    }
    else return false;
  }


}