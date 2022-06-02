import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_waiter/controller/home_controller.dart';
import 'package:shormeh_pos_waiter/controller/tables_controller.dart';
import 'package:shormeh_pos_waiter/models/cart_model.dart';
import 'package:shormeh_pos_waiter/models/notes_model.dart';
import 'package:shormeh_pos_waiter/models/tables_model.dart';
import '../../constants.dart';
import 'home.dart';


class TableOrder extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final tablesController = ref.watch(tablesFuture);
     final homeController = ref.watch(dataFuture);
    Size size = MediaQuery.of(context).size;

    return Container(
      child: tablesController.chosenOrder != null
          ? Column(
        children: [
          // if(viewModel.orders[viewModel.chosenOrder!].orderStatusId!=7)
          //   InkWell(
          //     onTap: (){
          //       viewModel.complain(size, context);
          //     },
          //     child: Container(
          //         height: 35,
          //         color: Colors.red[500],
          //         child:Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Icon(Icons.warning_amber_outlined,color: Colors.white,),
          //             SizedBox(width: 10,),
          //             Text(
          //               'complainOrder'.tr(),
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: size.height*0.02,
          //               ),
          //             ),
          //
          //           ],
          //         )
          //     ),
          //   ),
          SizedBox(height: 40,),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                children: [
                  Text(
                    'orderNumber'.tr()+ ':  ${tablesController.chosenOrderNum!}',
                    style: TextStyle(
                        fontSize: size.height * 0.028,
                        fontWeight: FontWeight.bold,
                        color: Constants.mainColor,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    tablesController.currentOrder!.createdAt!,
                    style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: Constants.mainColor),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    tablesController.currentOrder!.currentOrder!.orderStatus!.title!,
                    style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: Constants.mainColor),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: tablesController.currentOrder!.currentOrder!.details!.length,
                      separatorBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Divider(),
                        );
                      },
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        Details2 product = tablesController.currentOrder!.currentOrder!.details![i];

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: product.product!.title!.length > 20
                                        ? 68
                                        : 25,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black45)),
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      product.quantity.toString() +
                                          'X  ' +
                                          product.product!.title!,
                                      style: TextStyle(
                                        color: Constants.mainColor,
                                        fontSize: size.height * 0.022,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height:product.product!.title!.length > 20
                                        ? 68
                                        : 25,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black45)),
                                    padding: EdgeInsets.only(left: 10),
                                    child: Center(
                                      child: Text(
                        product.product!.newPrice!=null?
                                        product.product!.newPrice! .toString()+ ' SAR':
                        product.product!.price! .toString()+ ' SAR' ,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Constants.mainColor,
                                            fontSize: size.height * 0.022,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (product.notes!.isNotEmpty)
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black45)),
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'extra'.tr(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.height * 0.019,
                                      ),
                                    ),
                                    Column(
                                      children: product.notes!.map((e) {
                                        return Text(e.title!);
                                      }).toList(),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                ],
              ),
            ),
          ),
          // if (tablesController.orders[tablesController.chosenOrder!].orderStatusId !=
          //     5 &&
          //     tablesController.orders[tablesController.chosenOrder!].paymentMethod ==
          //         null)
          //   Container(
          //     height: 50,
          //     child: Row(
          //       children: [
          //         Flexible(
          //           child: InkWell(
          //             onTap: () {
          //               tablesController.cancelOrder(
          //                   tablesController.orders[tablesController.chosenOrder!].id!);
          //               tablesController.orders[tablesController.chosenOrder!]
          //                   .orderStatusId = 5;
          //               tablesController.orders[tablesController.chosenOrder!]
          //                   .orderStatus = 'Order Cancelled';
          //             },
          //             child: Container(
          //               color: Colors.redAccent,
          //               child: Center(
          //                 child: Text(
          //                   'cancelOrder'.tr(),
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: size.height * 0.025,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),

          //       ],
          //     ),
          //   ),
          Container(
            height: size.height * 0.14,
            width: size.width * 0.28,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [


                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'table'.tr(),
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Constants.mainColor),
                    ),
                    Text(
                      tablesController.currentOrder!.title!,
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Constants.mainColor),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'total'.tr(),
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Constants.mainColor),
                    ),
                    Text(
                      tablesController.currentOrder!.currentOrder!
                          .total
                          .toString() +
                          ' SAR ',
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Constants.mainColor),
                    ),
                  ],
                ),



                // if(viewModel.orders[viewModel.chosenOrder!].paymentCustomer!=null)
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Payment Customer',
                //       style: TextStyle(
                //           fontSize: size.height * 0.02,
                //           fontWeight: FontWeight.bold,
                //           color: Constants.mainColor),
                //     ),
                //     Text(
                //       viewModel.orders[viewModel.chosenOrder!].paymentCustomer!,
                //       style: TextStyle(
                //           fontSize: size.height * 0.02,
                //           fontWeight: FontWeight.bold,
                //           color: Constants.mainColor),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: () {
              homeController.updateOrder = true;
              HomeController.orderUpdatedId =
                  tablesController.currentOrder!.currentOrder!.id;
              print(tablesController.currentOrder!.currentOrder!.id);
              HomeController.total = tablesController
                  .currentOrder!.currentOrder!.total!;
              // tablesController
              //     .currentOrder!
              //     .currentOrder!.orderStatus!.id==
              //     6
              //     ? homeController.hold = 1
              //     : homeController.hold = 0;

              tablesController.currentOrder!.currentOrder!.details!
                  .forEach((element) {
                List<NotesModel> notes = [];
                for (int i = 0;
                i < element.notes!.length;
                i++) {
                  notes.add(NotesModel(
                      id: element.notes![i].id,
                      title: element.notes![i].title));
                }

                HomeController.cartItems.add(CartModel(
                    id: element.productId,
                    rowId: element.id,
                    mainName: element.product!.title,
                    extra: notes,
                    count: element.quantity,
                     total: double.parse(element.total.toString()),
                    price:element.product!.newPrice!=null? element.product!.newPrice!.toDouble():
                    element.product!.price!.toDouble(),
                    orderMethod: 'restaurant'.tr(),
                    time: tablesController
                        .currentOrder!
                        .createdAt,
                    orderMethodId: tablesController
                        .currentOrder!
                        .currentOrder!.orderMethodId,
                    orderStatus: tablesController
                        .currentOrder!
                        .currentOrder!.orderStatusId));
              });
              homeController.tabViewController(1);


              homeController.refresh();
              tablesController.refresh();
            },
            child: Container(
              color: Constants.secondryColor,
              width: size.width,
              height: size.height*0.07,
              child: Center(
                child: Text(
                  'editOrder'.tr(),
                  style: TextStyle(
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
            ),
          ),
        ],
      )
          : Container(),
    );
  }
}
