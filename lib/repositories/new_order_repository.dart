import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../constants.dart';


class NewOrderRepository {



  Future getTables(String token, String language, int branch) async {
    var response = await http.get(
        Uri.parse("${Constants.baseURL}branch/$branch/tables"),
        headers: {'AUTHORIZATION': 'Bearer $token', 'Language': language});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['data'];
    } else {
      return false;
    }
  }


  Future confirmOrder(String token, String language, Map data) async {
    var response = await http.post(Uri.parse("${Constants.baseURL}orders"),
        headers: {
          'AUTHORIZATION': 'Bearer $token',
          'Language': language,
          "Accept": "application/json",
          'Content-type': 'application/json',
        },
        body: jsonEncode(data));
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['data'];
    } else {
      return false;
    }
  }

  Future updateFromOrder(String token,String language,int itemId,Map data) async {
    var response = await http.post(
      Uri.parse("${Constants.baseURL}order/$itemId/updateDetails"),
      body:jsonEncode(data) ,
      headers:  {'AUTHORIZATION':'Bearer $token','Language': language,
        "Accept": "application/json",
        'Content-type': 'application/json',},
    );
    if(response.statusCode==200){
      var data = json.decode(response.body);
      return data;
    }
    else return false;
  }


  Future getPrinters(String token,String branch) async {
    var response = await http.get(
        Uri.parse("${Constants.baseURL}branch/$branch/printers"),
        headers: {'AUTHORIZATION': 'Bearer $token'});
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['data'];
    } else {
      return false;
    }
  }

}
