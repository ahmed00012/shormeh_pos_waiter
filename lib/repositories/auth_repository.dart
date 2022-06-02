
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';


class AuthRepository {

  Future loginWaiter(Map user,String language) async {
    var response = await http.post(
        Uri.parse("${Constants.baseURL}auth/waiter/login"),body: user,headers: {
    'Language': language
    });
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      return data;
    } else {
      return false;
    }
  }

  Future logoutWaiter(String token,String language) async {
    var response = await http.post(
        Uri.parse("${Constants.baseURL}auth/logout"),
      headers:  {'AUTHORIZATION':'Bearer $token','Language': language},);
    if(response.statusCode==200) {
      var data = json.decode(response.body);
      return data;
    } else {
      return false;
    }
  }


}