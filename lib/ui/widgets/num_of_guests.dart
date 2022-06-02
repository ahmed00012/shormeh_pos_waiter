import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';



class Numpad2 extends StatefulWidget {

  @override
  _Numpad2State createState() => _Numpad2State();
}

class _Numpad2State extends State<Numpad2> {
  String text = '';
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Container(
              height: size.height*0.08,
              width: size.width*0.65,
              color: Colors.white,
              child: Center(
                child: Text(text,
                    style: TextStyle(fontSize: size.height * 0.025)),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [1, 2, 3]
              .map((e) => InkWell(
            onTap: () {
              setState(() {
               text=text+e.toString();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: size.height*0.09,
                width: size.width*0.19,
                color: Colors.white,
                child: Center(
                  child: Text(
                    e.toString(),
                    style: TextStyle(fontSize: size.height * 0.022),
                  ),
                ),
              ),
            ),
          ))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [4, 5, 6]
              .map((e) => InkWell(
            onTap: () {
              setState(() {
                text=text+e.toString();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: size.height*0.09,
                width: size.width*0.19,
                color: Colors.white,
                child: Center(
                  child: Text(
                    e.toString(),
                    style: TextStyle(fontSize: size.height * 0.022),
                  ),
                ),
              ),
            ),
          ))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [7, 8, 9]
              .map((e) => InkWell(
            onTap: () {
              setState(() {
               text=text+e.toString();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: size.height*0.09,
                width: size.width*0.19,
                color: Colors.white,
                child: Center(
                  child: Text(
                    e.toString(),
                    style: TextStyle(fontSize: size.height * 0.022),
                  ),
                ),
              ),
            ),
          ))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {

                if (text.isNotEmpty)
                 setState(() {
                   text = text.substring(0,text.length-1);
                 });
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: size.height*0.09,
                  width: size.width*0.19,
                  color: Colors.red[500],
                  child: Center(
                    child: Icon(
                      Icons.backspace_outlined,
                      size: size.height * 0.025,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (text.isNotEmpty)
                 setState(() {
                   text=text+'0';
                 });
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: size.height*0.09,
                  width: size.width*0.19,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      '0',
                      style: TextStyle(fontSize: size.height * 0.022),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () {
                  if(text!='') {

                Navigator.pop(context,int.parse(text));
              }
                  else{
                    showSimpleNotification(
                       Container(
                          height: 60,
                          child:  Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Center(
                              child: Text(
                                'numOfGuestsAlert'.tr(),
                                style: TextStyle(
                                    color: Colors.white ,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        duration: Duration(seconds: 3),
                        elevation: 2,
                        background: Colors.red[500] );
                  }

              // if (ordersScreen == null) {
                  //   HomeController.cardItems[viewModel.chosenItem!].count =
                  //       int.parse(viewModel.countText.join());
                  //   viewModel.textCountController(viewModel.chosenItem!);
                  // } else {
                  //   ordersController.searchOrder(int.parse(viewModel.countText.join())) ;
                  // }
                  //
                  // viewModel.countText = [];
                  //
                },
                child: Container(
                  height: size.height*0.08,
                  width: size.width*0.19,
                  color: Colors.green,
                  child: Center(
                    child: Icon(
                      Icons.check,
                      size: size.height * 0.025,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}




