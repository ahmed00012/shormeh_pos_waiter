import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_waiter/controller/home_controller.dart';
import 'package:shormeh_pos_waiter/controller/tables_controller.dart';
import 'package:shormeh_pos_waiter/models/cart_model.dart';
import 'package:shormeh_pos_waiter/models/notes_model.dart';
import 'package:shormeh_pos_waiter/ui/screens/table_order.dart';
import 'package:shormeh_pos_waiter/ui/widgets/cart_bar.dart';
import 'package:shormeh_pos_waiter/ui/widgets/num_of_guests.dart';

import '../../constants.dart';
import 'cart.dart';
import 'home.dart';


class Tables extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablesController = ref.watch(tablesFuture);
    final homeController = ref.watch(dataFuture);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Container(
          //       height: size.height,
          //       width: size.width * 0.28,
          //       child: Card(
          //           elevation: 5,
          //           clipBehavior: Clip.antiAliasWithSaveLayer,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10.0),
          //           ),
          //           child: HomeController.cartItems.isNotEmpty
          //               ? Cart()
          //               : tablesController.chosenOrder != null
          //               ? TableOrder()
          //               : Container())),
          // ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: tablesController.departments.length,
                            itemBuilder: (context, index) {
                              return ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Center(
                                    child: Text(
                                      tablesController.departments[index].title!,
                                      style: TextStyle(
                                          fontSize: size.height * 0.03,
                                          fontStyle: FontStyle.italic,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  GridView.builder(
                                    itemCount:
                                    tablesController.departments[index].tables!.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 1.2,
                                    ),
                                    itemBuilder: (context, i) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {

                                            if(tablesController.departments[index].tables![i].currentOrder!=null) {
                                              homeController.emptyCardList();
                                              tablesController.getCurrentOrder(
                                                  index, i);
                                              homeController.table =
                                              tablesController
                                                  .departments[index]
                                                  .tables![i];
                                              homeController.table!.numOfGuests = 4;
                                              homeController.table!.department =
                                                  tablesController
                                                      .departments[index].title;
                                              homeController.updateOrder = true;
                                              HomeController.orderUpdatedId =
                                                  tablesController.currentOrder!.currentOrder!.id;
                                              HomeController.total = tablesController
                                                  .currentOrder!.currentOrder!.total!;

                                              tablesController.currentOrder!.currentOrder!.details!
                                                  .forEach((element) {
                                                List<NotesModel> notes = [];

                                                for (int i = 0;
                                                i < element.notes!.length;
                                                i++) {

                                                  notes.add(NotesModel(
                                                    id: element.notes![i].id,
                                                    title: element.notes![i].title,
                                                    price: element.notes![i].price,
                                                  ));

                                                }

                                                HomeController.cartItems.add(CartModel(
                                                    id: element.productId,
                                                    rowId: element.id,
                                                    mainName: element.product!.title,
                                                    extra: notes,
                                                    count: element.quantity,
                                                    total: double.parse(element.total.toString()),
                                                    price:element.product!.newPrice!=0.0? element.product!.newPrice!.toDouble():
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

                                              HomeController.total = tablesController
                                                  .currentOrder!.currentOrder!.total!;


                                              homeController.refresh();
                                              tablesController.refresh();
                                              homeController.tabViewController(1);

                                            }

                                            else
                                            {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                      Constants.scaffoldColor,
                                                      title: Center(
                                                          child: Text(
                                                            'numOfGuests'.tr(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                size.height * 0.025),
                                                          )),
                                                      content:  Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Numpad2()
                                                        ],
                                                      )
                                                    );
                                                  }).then((value) {
                                                if (value != null) {
                                                  homeController.table =
                                                  tablesController
                                                      .departments[index]
                                                      .tables![i];
                                                  homeController.table!.numOfGuests =
                                                      value;
                                                  homeController.table!.department =
                                                      tablesController
                                                          .departments[index].title;
                                                  tablesController.reserveTable(
                                                      index,
                                                      tablesController
                                                          .departments[index]
                                                          .tables![i]);
                                                  homeController.tabViewController(1);
                                                  homeController.refresh();
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: tablesController
                                                    .departments[index]
                                                    .tables![i]
                                                    .currentOrder !=
                                                    null ||
                                                    tablesController.departments[index]
                                                        .tables![i].chosen!
                                                    ? Constants.colorRed
                                                    : Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                                border: Border.all(
                                                    color: tablesController
                                                        .departments[index]
                                                        .tables![i]
                                                        .currentOrder !=
                                                        null ||
                                                        tablesController
                                                            .departments[index]
                                                            .tables![i]
                                                            .chosen!
                                                        ? Colors.red
                                                        : Constants.mainColor,
                                                    width: 1)),
                                            child: Center(
                                              child: Text(
                                                tablesController
                                                    .departments[index].tables![i].title!,
                                                style: TextStyle(
                                                    color: tablesController
                                                        .departments[index]
                                                        .tables![i]
                                                        .currentOrder !=
                                                        null ||
                                                        tablesController
                                                            .departments[index]
                                                            .tables![i]
                                                            .chosen!
                                                        ? Colors.white
                                                        : Constants.mainColor,
                                                    fontSize: size.height * 0.025),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
                if(HomeController.cartItems.isNotEmpty)
                  CartBar()
              ],
            ),
          )

        ],
      ),
    );
  }
}
