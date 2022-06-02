import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_waiter/controller/auth_controller.dart';
import 'package:shormeh_pos_waiter/controller/home_controller.dart';
import 'package:shormeh_pos_waiter/ui/screens/single_item.dart';
import 'package:shormeh_pos_waiter/ui/screens/tables.dart';
import '../../constants.dart';
import '../../local_storage.dart';
import 'cart.dart';
import 'new_home.dart';



class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(dataFuture);
    final authController = ref.watch(loginFuture);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: false,
      body: WillPopScope(
        onWillPop: () {
          viewModel.switchToCardItemWidget(false);
          return Future.value(false);
        },
        child: Row(
          children: [

            Expanded(
              child:DefaultTabController(
                initialIndex: 1,
                length: 2,
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              viewModel.tabViewController(0);
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(color:viewModel.tablesWidget?
                                  Constants.secondryColor:
                                  Colors.white,
                                  width: 2)
                                )
                              ),


                              child: Center(
                                child: Icon(Icons.grid_view,color: Constants.mainColor,)
                              ),
                            ),
                          ),
                        ),


                        Container(height: 60,width: 1,color: Colors.lightBlueAccent[50],),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              viewModel.tabViewController(1);
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(color:viewModel.homeWidget?
                                      Constants.secondryColor:
                                      Colors.white,
                                          width: 2)
                                  )
                              ),


                              child: Center(
                                child: Icon(Icons.home,color: Constants.mainColor,)
                              ),
                            ),
                          ),
                        ),
                        Container(height: 60,width: 1,color: Colors.lightBlueAccent[50],),
                        Container(
                          color: Colors.white,
                          height: 60,

                          child: PopupMenuButton(
                            icon: Icon(Icons.settings,color: Constants.mainColor,),


                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Language  '),

                                                viewModel.lan=='ar'?
                                                Image.asset('assets/images/saudi-arabia.png',
                                                  width: 20,
                                                  height: 60,):
                                                Image.asset('assets/images/united-states.png',
                                                width: 20,
                                                height: 60,),
                                    ],
                                  ),
                                  value: 1,
                                  onTap: (){
                                          String lan =  viewModel.getLanguage();
                                          lan=='ar'?
                                          context.setLocale(Locale('en')):
                                          context.setLocale( Locale('ar'));
                                          lan = context.locale.languageCode;
                                          viewModel.changeLanguage(lan);
                                          viewModel.synchronize(context);
                                          viewModel.categories=[];
                                          viewModel.products=[];
                                          viewModel.optionsList=[];
                                          viewModel.getNotes();
                                          viewModel.getCategories();
                                  },
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Logout  ',),

                                    Icon(Icons.logout,color: Constants.colorRed,),
                                    ],
                                  ),
                                  value: 2,
                                )
                              ]
                          ),
                        )

                      ],
                    ),

                    // TabBar(
                    //     indicatorColor: Colors.amber,
                    //     indicatorSize: TabBarIndicatorSize.label,
                    //     indicatorWeight: 3,
                    //     labelColor: Constants.mainColor,
                    //
                    //     tabs: [
                    //       Tab(
                    //         child: Flexible(
                    //           child: Container(
                    //             height: 60,
                    //             width: 300,
                    //             color: Colors.white,
                    //             child: Center(
                    //               child: Text('tables'.tr()),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Tab(
                    //
                    //         child: Container(
                    //           height: 60,
                    //           color: Colors.white,
                    //           child: Center(
                    //             child: Text('home'.tr()),
                    //           ),
                    //         ),
                    //       ),
                    //     ]),
                Expanded(
                  child: Row(
                    children: [
                      // if(!viewModel.tablesWidget)
                      //   Container(
                      //       width: size.width * 0.28,
                      //       child: Card(
                      //           elevation: 5,
                      //           clipBehavior: Clip.antiAliasWithSaveLayer,
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10.0),
                      //           ),
                      //           child: Cart())),
                      viewModel.itemWidget? Expanded(child: SingleItem()):
                      Expanded(
                        child:  viewModel.tablesWidget?Center(
                          child: Tables(),
                        ):Center(
                          child: NewHome(),
                        ),

                      )
                    ],
                  ),
                )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
