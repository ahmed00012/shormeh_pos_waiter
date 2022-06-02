import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:shormeh_pos_waiter/controller/home_controller.dart';
import 'package:shormeh_pos_waiter/ui/screens/cart.dart';

import '../../constants.dart';
import '../../local_storage.dart';

class CartBar extends StatelessWidget {
  double ?tax = double.parse(LocalStorage.getData(key: 'tax').toString()) / 100;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return  Positioned(
      bottom: 5,
      left: 0,
      right: 0,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Cart()));
        },
        child: Container(
          height: size.height*0.09,
          width: size.width*0.85,
          color: Colors.transparent,
          child: Center(
            child: Stack(
              children: [


                Center(

                  child: Container(
                      height: size.height*0.07,
                      width: size.width*0.8,

                      decoration: BoxDecoration(
                          color: Constants.mainColor,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Text(
                            'total'.tr() + ':   ',
                            style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
tax!=null?
                          Text(
                            (HomeController.total +
                                HomeController.total*tax!)
                                .toStringAsFixed(2) +
                                ' SAR',
                            style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ):
Text(
  (HomeController.total)
        .toStringAsFixed(2) +
        ' SAR',
  style: TextStyle(
        fontSize: size.height * 0.025,
        color: Colors.white,
        fontWeight: FontWeight.w500),
),
                        ],
                      )
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left:  10,
                  child: Container(
                    height: size.height*0.08,
                    width: size.width*0.2,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Constants.mainColor,
                        border: Border.all(color: Colors.white,width: 2)
                    ),
                    child: Center(
                      child: Text(HomeController.cartItems.length.toString(),
                        style: TextStyle(
                            fontSize: size.height * 0.025,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),),
                    ),
                  ),
                ),

              ],
            ),
          ),

        ),
      ),
    );
  }
}
