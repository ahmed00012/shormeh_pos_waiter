import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shormeh_pos_waiter/controller/home_controller.dart';
import 'package:shormeh_pos_waiter/models/notes_model.dart';


import '../../constants.dart';

class SingleItem extends ConsumerWidget {
  const SingleItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(dataFuture);

    Size size = MediaQuery.of(context).size;
    return viewModel.chosenItem==null? Container():
    Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                viewModel.removeCartItem(viewModel.chosenItem!);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * 0.09,
                  width: size.width * 0.12,
                  decoration: BoxDecoration(
                      color: Colors.red[500],
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Icon(
                      Icons.delete_outline,
                      size: size.height * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                viewModel.plusController(viewModel.chosenItem!);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * 0.09,
                  width: size.width * 0.12,
                  decoration: BoxDecoration(
                      color: Constants.mainColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: size.height * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                viewModel.minusController(viewModel.chosenItem!);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * 0.09,
                  width: size.width * 0.12,
                  decoration: BoxDecoration(
                      color: Constants.mainColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Icon(
                      Icons.minimize,
                      size: size.height * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * 0.09,
                  width: size.width * 0.12,
                  decoration: BoxDecoration(
                      color: Constants.mainColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: size.height * 0.04,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'back'.tr(),
                        style: TextStyle(
                            fontSize: size.height * 0.015, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              HomeController.cartItems[viewModel.chosenItem!].count.toString() +
                  'X   ' +
                  HomeController.cartItems[viewModel.chosenItem!].mainName! ,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size.height * 0.02,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              HomeController.cartItems[viewModel.chosenItem!].total.toString() +
                  ' SAR',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Constants.secondryColor,
                  fontSize: size.height * 0.02,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
          Text(
            'extra'.tr(),
            style: TextStyle(
                color: Constants.mainColor,
                fontSize: size.height * 0.02,
                fontWeight: FontWeight.bold),
          ),
        SizedBox(
          height: 5,
        ),
          Container(

            height: size.height*0.22,
            child: GridView.builder(
              itemCount:
              HomeController.cartItems[viewModel.chosenItem!].extra!.length+1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1.5),

              itemBuilder: (context, i) {
                return
                  i==HomeController.cartItems[viewModel.chosenItem!].extra!.length?
                      InkWell(
                        onTap: (){
                          viewModel.addMore = true;
                          viewModel.refresh();

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Constants.secondryColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Constants.mainColor)),
                            child: Center(
                              child: Text(
                                'addMore'.tr(),
                                style: TextStyle(
                                    color: Constants.mainColor,
                                    fontSize: size.height * 0.018,
                                    fontWeight: FontWeight.w500),
                              ),

                            )
                          ),
                        ),
                      ):
                  InkWell(

                  onDoubleTap:(){

                    HomeController.cartItems[viewModel.chosenItem!].total =
                        HomeController.cartItems[viewModel.chosenItem!].total! -
                        HomeController.cartItems[viewModel.chosenItem!].extra![i].price!;
                    HomeController.cartItems[viewModel.chosenItem!].extra!.removeAt(i);
                    HomeController.cartItems[viewModel.chosenItem!].updated=true;
                    viewModel.refresh();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Constants.mainColor)),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              HomeController.cartItems[viewModel.chosenItem!].extra![i].title!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.height * 0.017,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              HomeController.cartItems[viewModel.chosenItem!].extra![i].price!=0.00 ?
                              HomeController.cartItems[viewModel.chosenItem!].extra![i].price.toString() +
                                  ' SAR':'',
                              style: TextStyle(
                                  fontSize: size.height * 0.017,
                                  color: Constants.secondryColor,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ),
                  ),
                );
              },
            ),
          ),
        SizedBox(
          height: 20,
        ),
        if(viewModel.addMore)
          Expanded(
            child: GridView.builder(
                itemCount: viewModel.optionsList.length ,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {

                      HomeController.cartItems[viewModel.chosenItem!].updated=true;
                        NotesModel note =NotesModel(
                          title: viewModel
                              .optionsList[i].title!,
                          id: int.parse(viewModel
                              .optionsList[i].id!),
                          price: double.parse(viewModel
                              .optionsList[i].price!),
                        );
                        List notesID= [];
                        HomeController.cartItems[viewModel.chosenItem!].extra!.forEach((element) {notesID.add(element.id);});

                        if(!notesID.contains(int.parse(viewModel
                            .optionsList[i].id!))) {
                                HomeController
                                    .cartItems[viewModel.chosenItem!].extra!
                                    .add(note);
                                HomeController.cartItems[viewModel.chosenItem!].total = HomeController.cartItems[viewModel.chosenItem!].total!+note.price!;
                              }
                        viewModel.refresh();
                            },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(

                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                              viewModel
                                  .optionsList[i].title!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: size.height * 0.017),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  viewModel
                                      .optionsList[i].price=='0.00'?
                                      '':
                                viewModel
                                    .optionsList[i].price
                                    .toString() +
                                    ' SAR',
                                style: TextStyle(
                                    fontSize: size.height * 0.017,
                                    color: Constants.secondryColor,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                    ),
                  );
                }))
      ],
    );
  }
}
