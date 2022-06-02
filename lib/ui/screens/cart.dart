import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shormeh_pos_waiter/controller/home_controller.dart';
import 'package:shormeh_pos_waiter/controller/tables_controller.dart';
import 'package:shormeh_pos_waiter/ui/screens/single_item.dart';

import '../../constants.dart';

class Cart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(dataFuture);
    final tablesController = ref.watch(tablesFuture);
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 3,
      color: Color(0xfff8f9fa),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        // alignment: Alignment.center,
        // fit: StackFit.expand,
        children: [
          //////////////////cnacel order button////////////////////////

         Row(
           children: [
             Expanded(
               flex: 2,
               child: InkWell(onTap: (){
                 Navigator.pop(context);
               },

                 child: Container(
                   height: size.height * 0.06,

                   decoration: BoxDecoration(
                       color: Constants.secondryColor,
                       ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(Icons.arrow_back,color: Colors.white,),

                     ],
                   ),
                 ),
               ),
             ),
             Expanded(
               flex: 8,
               child: InkWell(
                 onTap: () {
                   viewModel.emptyCardList();
                   Navigator.pop(context);
                   viewModel.tabViewController(0);

                 },
                 child: Container(
                   height: size.height * 0.06,

                   decoration: BoxDecoration(
                       color: Colors.red[500],
                     ),
                   child: Center(
                       child: Text(
                         viewModel.updateOrder?'cancelEditing'.tr():
                         'cancelOrder'.tr(),
                         style: TextStyle(
                             color: Colors.white,
                             fontSize: size.height*0.02
                         ),
                       )),
                 ),
               ),
             ),

           ],
         ),

/////////////////////card products/////////////////////////////////
          if (viewModel.table != null)
            Expanded(
              child: GridView.builder(
                itemCount: HomeController.cartItems.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, i) {
                  return Card(
                    elevation: 3,
                    child: InkWell(
                      onTap: () {
                        // viewModel.switchToCardItemWidget(true, i: i);
                        viewModel.addMore = false;
                        viewModel.chosenItem = i;
                        viewModel.refresh();


                        showDialog(context: context, builder: (context){
                          return AlertDialog(
                            backgroundColor: Constants.scaffoldColor,
                            content: SingleItem(),
                          );
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            HomeController.cartItems[i].count.toString() +
                                'X ' +
                                HomeController.cartItems[i].mainName!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.height * 0.015,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            HomeController.cartItems[i].total.toString() +
                                ' SAR',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Constants.secondryColor,
                                fontSize: size.height * 0.015,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      viewModel.plusController(i);
                                    },
                                    child: Container(
                                      height: size.height * 0.04,
                                      color: Constants.mainColor,
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      viewModel.minusController(i);
                                    },
                                    child: Container(
                                      height: size.height * 0.04,
                                      color: Constants.mainColor,
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        '__',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ),
                              // IconButton(
                              //     alignment: Alignment.bottomRight,
                              //     onPressed: () {
                              //       viewModel.minusController(i);
                              //     },
                              //     icon: Icon(
                              //       Icons.indeterminate_check_box_outlined,
                              //       color: Constants.mainColor,
                              //     ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          ////////////////////////////////////summary////////////////////////////////////////
          if (viewModel.table != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'department'.tr() + ': ',
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Colors.black45),
                      ),
                      Spacer(),
                      Text(
                        viewModel.table!.department!,
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'table'.tr() + ': ',
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Colors.black45),
                      ),
                      Spacer(),
                      Text(
                        viewModel.table!.title!,
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'guests'.tr() + ': ',
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Colors.black45),
                      ),
                      Spacer(),
                      Text(
                        viewModel.table!.numOfGuests.toString(),
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'totalBeforeTax'.tr() + ': ',
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Colors.black45),
                      ),
                      Spacer(),
                      Text(
                        HomeController.total.toString() + ' SAR',
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'tax'.tr() + ': ',
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Colors.black45),
                      ),
                      Spacer(),
                      Text(
                        (HomeController.total * viewModel.tax)
                                .toStringAsFixed(2) +
                            ' SAR',
                        style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                if (HomeController.discount != '')
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          'discount'.tr() + ': ',
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              color: Colors.black45),
                        ),
                        Spacer(),
                        Text(
                          HomeController.discount,
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              color: Colors.black45),
                        )
                      ],
                    ),
                  ),
                if (HomeController.discount != '')
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          'totalAfterDiscount'.tr() + ': ',
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              color: Colors.black45),
                        ),
                        Spacer(),
                        Text(
                          (HomeController.totalAfterDiscount +
                                      HomeController.total * viewModel.tax)
                                  .toStringAsFixed(2) +
                              ' SAR ',
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              color: Colors.black45),
                        )
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),

//////////////////////////////////////////checkout button////////////////////////////////

          if (viewModel.table != null)
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Constants.scaffoldColor,
                        title: Center(
                            child: Text(
                          'confirmOrder'.tr(),
                          style: TextStyle(fontSize: size.height * 0.025),
                        )),
                        content: SingleChildScrollView(
                          child: Container(
                            height: size.height * 0.32,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: size.height * 0.065,
                                  width: size.width * 0.8,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextField(
                                        controller: viewModel.customerName,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'clientName'.tr(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: size.height * 0.065,
                                  width: size.width * 0.8,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextField(
                                        controller: viewModel.customerPhone,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'clientPhone'.tr(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                InkWell(
                                  onTap: () {
                                    tablesController
                                        .confirmOrder(
                                            viewModel.table!.numOfGuests!,
                                            viewModel.customerPhone.text,
                                        viewModel.customerName.text,
                                        viewModel.table!)
                                        .then((value) {
                                      if (value != false) {
                                        viewModel.customerPhone.text = '';
                                        viewModel.customerName.text = '';
                                        viewModel.table = null;
                                        viewModel.emptyCardList();
                                        viewModel.refresh();
                                        int count = 0;
                                        Navigator.popUntil(context, (route) {
                                          return count++ == 2;
                                        });
                                        tablesController.getTables();
                                        viewModel.tabViewController(0);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: size.height * 0.065,
                                    width: size.width * 0.5,
                                    decoration: BoxDecoration(
                                        color: Constants.mainColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        'confirmOrder'.tr(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.025),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                height: size.height * 0.06,
                width: size.width,
                decoration: BoxDecoration(
                    color: Constants.mainColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.2,
                        child: Text(
                          'pay'.tr(),
                          style: TextStyle(
                              fontSize: size.height * 0.025,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        width: 2,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'total'.tr() + ': ',
                        style: TextStyle(
                            fontSize: size.height * 0.025,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      if (HomeController.discount != '')
                        Text(
                          (HomeController.totalAfterDiscount +
                                      HomeController.total * viewModel.tax)
                                  .toStringAsFixed(2) +
                              ' SAR ',
                          style: TextStyle(
                              fontSize: size.height * 0.025,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      if (HomeController.discount == '')
                        Text(
                          (HomeController.total +
                                      HomeController.total * viewModel.tax)
                                  .toStringAsFixed(2) +
                              ' SAR',
                          style: TextStyle(
                              fontSize: size.height * 0.025,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
