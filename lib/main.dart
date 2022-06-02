
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shormeh_pos_waiter/ui/screens/home.dart';
import 'package:shormeh_pos_waiter/ui/screens/login.dart';


import 'constants.dart';
import 'local_storage.dart';
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext ?context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main()async{

 WidgetsFlutterBinding.ensureInitialized();
 await LocalStorage.init();
 await EasyLocalization.ensureInitialized();
 HttpOverrides.global = new MyHttpOverrides();
  runApp(ProviderScope(child:  EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp())));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      LocalStorage.saveData(key: 'language', value: context.locale.languageCode);
        return OverlaySupport.global(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
               fontFamily: 'RobotoCondensed',
              scaffoldBackgroundColor: Constants.scaffoldColor,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: Constants.mainColor,
                selectionColor: Constants.mainColor,
                selectionHandleColor:Constants.mainColor,
              ),
            ),
            home:LocalStorage.getData(key: 'token')==null? Login():Home(),
          ),
        );

  }
}


