import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_waiter/controller/home_controller.dart';
import 'package:shormeh_pos_waiter/models/cart_model.dart';
import 'package:shormeh_pos_waiter/models/notes_model.dart';
import 'package:shormeh_pos_waiter/ui/widgets/cart_bar.dart';

import '../../constants.dart';
import 'cart.dart';



class NewHome extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(dataFuture);
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        // UpperRow(),
        SizedBox(height: 20,),

        Expanded(
          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      height: size.height*0.06,

                      child: ListView.builder(
                          itemCount: viewModel.categories.length+1,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return   i == 0
                                ? InkWell(
                              onTap: () {
                                viewModel.options = true;
                                viewModel.chooseCategory(0);
                                // viewModel.getNotes();
                              },
                              child: Container(

                                width: 80,
                                color:viewModel.options? Colors.amber: Constants.mainColor,
                                child: Center(
                                  child: Text(
                                    'options'.tr(),
                                    style: TextStyle(
                                        fontSize: size.height * 0.02,
                                        color:viewModel.options? Constants.mainColor : Colors.white),
                                  ),
                                ),
                              ),
                            )
                                : InkWell(
                              onTap: () {

                                viewModel
                                    .getProducts(viewModel.categories[i-1].id);
                                viewModel.chooseCategory(i);
                                viewModel.options = false;
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Container(
                                  height: size.height*0.06,

                                  decoration: BoxDecoration(
                                      color: Colors.white,

                                      border: Border(
                                          bottom: BorderSide(
                                              color: viewModel.categories[i-1].chosen
                                                  ? Colors.amber
                                                  : Constants.mainColor,
                                              width: 4))),
                                  child: Center(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        viewModel.categories[i-1].name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: size.height * 0.015,
                                            color: Constants.mainColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 20,),
                    Expanded(
                        child:viewModel.loading?
                        Center(
                          child: CircularProgressIndicator(
                            color: Constants.mainColor,
                            strokeWidth: 4 ,
                          ),
                        ):  GridView.builder(
                            itemCount:viewModel.options ? viewModel.optionsList.length :viewModel.products.length,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.9   ,
                            ),
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  if(viewModel.table!=null) {
                                    if (!viewModel.options) {
                                      if (viewModel.products[i].newPrice ==
                                          '0') {
                                        HomeController.total = double.parse(
                                            viewModel.products[i].price!);
                                        HomeController.cartItems
                                            .forEach((element) {
                                          HomeController.total =
                                              HomeController.total +
                                                  element.total!;
                                        });
                                        HomeController.cartItems.add(CartModel(
                                          id: int.parse(
                                              viewModel.products[i].id!),
                                          departmentId: viewModel
                                              .products[i].departmentId,
                                          price: double.parse(viewModel
                                              .products[i].price
                                              .toString()),
                                          mainName: viewModel.products[i].title,
                                          size: '',
                                          extra: [],
                                          count: 1,
                                          drink: '',
                                          total: double.parse(viewModel
                                              .products[i].price
                                              .toString()),
                                          updated: viewModel.updateOrder,
                                        ));
                                      } else {
                                        HomeController.total = double.parse(
                                            viewModel.products[i].newPrice!);
                                        HomeController.cartItems
                                            .forEach((element) {
                                          HomeController.total =
                                              HomeController.total +
                                                  element.total!;
                                        });
                                        HomeController.cartItems.add(CartModel(
                                          id: int.parse(
                                              viewModel.products[i].id!),
                                          departmentId: viewModel
                                              .products[i].departmentId,
                                          price: double.parse(viewModel
                                              .products[i].newPrice
                                              .toString()),
                                          mainName: viewModel.products[i].title,
                                          extra: [],
                                          count: 1,
                                          total: double.parse(
                                              viewModel.products[i].newPrice!),
                                          updated: viewModel.updateOrder,
                                        ));
                                      }
                                      // if(viewModel.updateOrder) {
                                      //   HomeController.totalEditing =
                                      //       HomeController.totalEditing +
                                      //               double.parse(viewModel
                                      //                   .productsPaginated[i].price
                                      //                   .toString());
                                      //     }
                                    } else {
                                      NotesModel note = NotesModel(
                                        title: viewModel.optionsList[i].title!,
                                        id: int.parse(
                                            viewModel.optionsList[i].id!),
                                        price: double.parse(
                                            viewModel.optionsList[i].price!),
                                      );
                                      List notesID = [];
                                      HomeController.cartItems.last.extra!
                                          .forEach((element) {
                                        notesID.add(element.id);
                                      });

                                      if (!notesID.contains(int.parse(
                                          viewModel.optionsList[i].id!))) {
                                        HomeController.cartItems.last.extra!
                                            .add(note);
                                        HomeController.cartItems.last.total =
                                            HomeController
                                                .cartItems.last.total! +
                                                note.price!;
                                        // if(viewModel.updateOrder) {
                                        //   HomeController.totalEditing =
                                        //       HomeController.totalEditing +
                                        //           note.price!;
                                        // }
                                      }
                                    }
                                    viewModel.refresh();
                                  }
                                  else{
                                    viewModel.displayToastMessage('reserveTableFirst'.tr(), true);
                                  }


                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                  child: Container(


                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(viewModel.options?
                                          viewModel
                                              .optionsList[i].title!:
                                          viewModel
                                              .products[i].title!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: size.height * 0.018),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          viewModel.options?
                                          Text(
                                            viewModel
                                                .optionsList[i].price
                                                .toString()+
                                                ' SAR',
                                            style: TextStyle(
                                                fontSize: size.height * 0.015,
                                                color: Constants.secondryColor,
                                                fontWeight: FontWeight.bold),
                                          ):
                                          Text(
                                            viewModel
                                                .products[i].newPrice=='0'?
                                            viewModel
                                                .products[i].price! +
                                                ' SAR':viewModel
                                                .products[i].newPrice!
                                                +
                                                ' SAR',
                                            style: TextStyle(
                                                fontSize: size.height * 0.018,
                                                color: Constants.secondryColor,
                                                fontWeight: FontWeight.bold),
                                          ),

                                          if(!viewModel.options&&  viewModel
                                              .products[i].newPrice!='0')
                                            Text(

                                              viewModel
                                                  .products[i].price!+
                                                  ' SAR',

                                              style: TextStyle(
                                                  fontSize: size.height * 0.014,
                                                  color: Colors.black26,
                                                  decoration: TextDecoration.lineThrough,
                                                  fontWeight: FontWeight.bold),
                                            ),

                                        ],
                                      )),
                                ),
                              );
                            })),
                    SizedBox(height: size.height*0.1,),
                  ],
                ),
                if(HomeController.cartItems.isNotEmpty)
                  CartBar()
              ],
            ),
          ),
        ),

      ],
    );
  }
}
