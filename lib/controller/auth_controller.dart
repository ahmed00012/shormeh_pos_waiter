import 'dart:convert';

import 'package:easy_localization/src/public_ext.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shormeh_pos_waiter/local_storage.dart';
import 'package:shormeh_pos_waiter/repositories/auth_repository.dart';
import 'package:shormeh_pos_waiter/ui/screens/home.dart';
import 'package:shormeh_pos_waiter/ui/screens/login.dart';

import '../constants.dart';


final loginFuture = ChangeNotifierProvider.autoDispose<LoginController>(
        (ref) => LoginController());

class LoginController extends ChangeNotifier {

  bool loading = false;
  final AuthRepository _authRepository = AuthRepository();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;


  void loadingSwitch(bool load) {
    loading = load;
    notifyListeners();
  }


  Future logout(BuildContext context) async {
    var data = await _authRepository.logoutWaiter(
        LocalStorage.getData(key: 'token'),
        LocalStorage.getData(key: 'language'));
    print(data);
    if (data != false) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => Login()), (route) => false);
      LocalStorage.removeData(key: 'token');
      LocalStorage.removeData(key: 'branch');
    }
    notifyListeners();
  }


  void login(BuildContext context) async {
    loadingSwitch(true);
    var data = await _authRepository.loginWaiter(
        {'email': phoneController.text, 'password': passwordController.text},
        LocalStorage.getData(key: 'language'));
    if (data != false) {

      LocalStorage.saveData(key: 'token', value: data['data']['access_token']);
      Constants.btok=data['data']['access_token'];
      LocalStorage.saveData(
          key: 'username', value: data['data']['employee']['name']);
      LocalStorage.saveData(
          key: 'branch', value: data['data']['employee']['branch_id']);
      LocalStorage.saveData(key: 'tax', value: data['data']['tax']);
      LocalStorage.saveData(key: 'branchName', value: data['data']['branch']);
      phoneController.text = '';
      passwordController.text = '';
      Navigator.push(context,
          MaterialPageRoute(builder: (_) =>Home()));
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Finance()));
      loadingSwitch(false);
    } else {
      displayToastMessage('wrongNameOrPassword'.tr());
      loadingSwitch(false);
    }

    notifyListeners();
  }





  void displayToastMessage(var toastMessage) {
    showSimpleNotification(
        Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                toastMessage,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        duration: Duration(seconds: 3),
        elevation: 2,
        background: Colors.red[500]);
  }
}
