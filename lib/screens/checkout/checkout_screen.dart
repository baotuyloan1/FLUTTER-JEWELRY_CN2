import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:furniture_app/components/custom_bottom_nav_bar.dart';
import 'package:furniture_app/components/default_button.dart';
import 'package:furniture_app/config.dart';
import 'package:furniture_app/constants.dart';
import 'package:furniture_app/dao/cart_dao.dart';
import 'package:furniture_app/entity/cart.dart';
import 'package:furniture_app/enums.dart';
import 'package:furniture_app/function/show_toast.dart';
import 'package:furniture_app/models/billing_model.dart';
import 'package:furniture_app/models/order_detail_model.dart';
import 'package:furniture_app/provider/init_provider.dart';
import 'package:furniture_app/readAPI/postData/delete_billing.dart';
import 'package:furniture_app/readAPI/postData/post_order.dart';
import 'package:furniture_app/screens/checkout/components/payment_cost.dart';
import 'package:furniture_app/screens/delivery_address/delivery_address_screen.dart';
import 'package:furniture_app/screens/home/home_screen.dart';
import 'package:furniture_app/size_config.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'components/payment_cart.dart';

class CheckoutScreen extends StatefulWidget {
  static String routeName = "/checkout";

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int? addressSelected;
  BillingModel? billingModelSelected;
  String? _note = "";
  TextEditingController noteController = TextEditingController();
  final bool _isShown = true;
  final _formKey = GlobalKey<FormState>();

  late Future<List<BillingModel>> _futureBillings;
  Future<List<BillingModel>> showBillings(String? cusID) async {
    // final response = await http.post(Uri.parse(getBillingUrl), body: {
    //   "customer_id": cusID.toString(),
    // });
    // if (response.statusCode == 200) {
    //   final list = ((json.decode(response.body)) as List<dynamic>)
    //       .map((value) => BillingModel.fromJson(value))
    //       .toList();
    //   return list;
    // } else {
    //   throw Exception('Failed to load album');
    // }
    final response =
        await http.post(Uri.parse(getBillingUrl), body: {"customer_id": cusID});
    final list = ((json.decode(response.body)) as List<dynamic>)
        .map((value) => BillingModel.fromJson(value))
        .toList();
    return list;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final customerId =
          Provider.of<InitProvider>(context, listen: false).accountModel.id;
      _futureBillings = showBillings(customerId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    int customerId = context.watch<InitProvider>().accountModel.id!;

    CartDAO cartDAO = context.watch<InitProvider>().cartDao;
    CartDAO cartDAORead = context.read<InitProvider>().cartDao;
    double? subTotal = context.watch<InitProvider>().subTotal;

    List<Cart> carts;
    return StreamBuilder(
      stream: cartDAO.getAllItemInCartAllByUid("bao"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          carts = snapshot.data as List<Cart>;

          double deliveryCoast = carts.isNotEmpty ? (subTotal! * 10) / 100 : 0;
          deliveryCoast = double.parse((deliveryCoast).toStringAsFixed(2));
          double total = deliveryCoast + subTotal!;
          total = double.parse((total).toStringAsFixed(2));
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "CheckOut",
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Delivery Address"),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context,
                                        DeliveryAddressScreen.routeName)
                                    .then(onGoBack);
                              },
                              child: const Text(
                                "Add",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: getProportionateScreenWidth(5)),
                    selectDeliveryAddress(context),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: getProportionateScreenWidth(10),
                      width: double.infinity,
                      color: kSecondaryColor.withOpacity(0.1),
                    ),
                    SizedBox(
                      height: getProportionateScreenWidth(20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Payment  method"),
                          TextButton(
                              onPressed: () {},
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.add,
                                    color: kPrimaryColor,
                                  ),
                                  Text("Add Card",
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold))
                                ],
                              ))
                        ],
                      ),
                    ),
                    PaymentCard(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Cash on delivery"),
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: kPrimaryColor),
                            width: getProportionateScreenWidth(15),
                            height: getProportionateScreenWidth(15),
                            child: Icon(
                              Icons.check,
                              size: getProportionateScreenWidth(13),
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PaymentCard(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: getProportionateScreenWidth(40),
                                  child:
                                      Image.asset("assets/images/visa1.png")),
                              SizedBox(
                                width: getProportionateScreenWidth(10),
                              ),
                              const Text("**** **** **** 2612"),
                            ],
                          ),
                          Container(
                            width: getProportionateScreenWidth(15),
                            height: getProportionateScreenWidth(15),
                            decoration: const ShapeDecoration(
                                shape: CircleBorder(
                                    side: BorderSide(color: kPrimaryColor))),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PaymentCard(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: getProportionateScreenWidth(40),
                                  child:
                                      Image.asset("assets/images/paypal.png")),
                              SizedBox(
                                width: getProportionateScreenWidth(10),
                              ),
                              Text(context
                                  .watch<InitProvider>()
                                  .accountModel
                                  .email
                                  .toString()),
                            ],
                          ),
                          Container(
                            width: getProportionateScreenWidth(15),
                            height: getProportionateScreenWidth(15),
                            decoration: const ShapeDecoration(
                                shape: CircleBorder(
                                    side: BorderSide(color: kPrimaryColor))),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenWidth(20),
                    ),
                    Container(
                      height: getProportionateScreenWidth(10),
                      width: double.infinity,
                      color: kSecondaryColor.withOpacity(0.1),
                    ),
                    SizedBox(
                      height: getProportionateScreenWidth(20),
                    ),
                    PaymentCost(context, subTotal),
                    Container(
                      height: getProportionateScreenWidth(10),
                      width: double.infinity,
                      color: kSecondaryColor.withOpacity(0.1),
                    ),
                    SizedBox(
                      height: getProportionateScreenWidth(10),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: buildNoteFormField(),
                    ),
                    SizedBox(
                      height: getProportionateScreenWidth(20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: SizedBox(
                        width: double.infinity,
                        child: DefaultButton(
                          text: "Send order",
                          press: () async {
                            if (billingModelSelected != null) {
                              int idPayment = 3;
                              int idOrder = await PostOrder().postOrder(
                                  billing_id:
                                      billingModelSelected!.id!.toString(),
                                  customer_id: customerId.toString(),
                                  order_total: total.toString(),
                                  payment_id: idPayment.toString(),
                                  order_note: _note!);
                              List<OrderDetailModel> orderDetails = carts
                                  .map((e) => OrderDetailModel(
                                      productId: e.id.toString(),
                                      productName: e.productName,
                                      orderId: idOrder.toString(),
                                      quantity: e.quantity,
                                      productPrice: e.price.toDouble()))
                                  .toList();
                              var body = json.encode(orderDetails);
                              var response = await http.post(
                                  Uri.parse(postOrderDetaillUrl),
                                  body: body);
                              if (response.body == "1") {
                                cartDAORead.clearCartByUid("bao");
                                Navigator.pushNamed(
                                    context, HomeScreen.routeName);
                              } else {
                                print("ERROR");
                              }
                            } else {
                              showToast1(
                                  context: context,
                                  color: kPrimaryColor,
                                  content: "Please add delivery address");
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar:
                const CustomBottomNavBar(selectedMenu: MenuState.home),
          );
        }
        return const Center(
          child: Text("error"),
        );
      },
    );
  }

  // StreamBuilder cartDetails() {
  //   return StreamBuilder(
  //       stream: context
  //           .read<InitProvider>()
  //           .cartDao
  //           .getAllItemInCartAllByUid("bao"),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           var list = snapshot.data as List<Cart>;
  //           _subTotal = list
  //               .map<double>(
  //                   (e) => double.parse((e.price * e.quantity).toString()))
  //               .reduce((value, element) => value + element);

  //           _deliveryCost = list
  //               .map<double>((e) =>
  //                   double.parse((e.price * e.quantity * (1 / 100)).toString()))
  //               .reduce((value, element) => value + element);
  //         }
  //         return const Center(
  //           child: Text('Cart Detail Error'),
  //         );
  //       });
  // }
  void refreshData() {
    setState(() {
      _futureBillings = showBillings(
          Provider.of<InitProvider>(context, listen: false)
              .accountModel
              .id
              .toString());
    });
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  TextFormField buildNoteFormField() {
    return TextFormField(
      controller: noteController,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      onSaved: (newValue) => _note = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          _note = value;
        } else {
          _note = "";
        }
      },
      decoration: const InputDecoration(
          labelText: "Note",
          hintText: "Enter your note",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder()),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter your note';
        }
        return null;
      },
    );
  }

  FutureBuilder<List<BillingModel>> selectDeliveryAddress(
      BuildContext context) {
    return FutureBuilder<List<BillingModel>>(
      future: _futureBillings,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            if (billingModelSelected == null) {
              billingModelSelected = snapshot.data![snapshot.data!.length - 1];
              addressSelected = snapshot.data!.length - 1;
              print(billingModelSelected!.billingName);
            }
          }

          return Column(
            children: [
              ...List.generate(snapshot.data!.length, (index) {
                return buildSelectAddress(
                    index: index, model: snapshot.data![index]);
              })
              // SpecialOfferCard(
              //   image: "assets/images/Image Banner 2.png",
              //   category: "Table",
              //   numOfBrands: 16,
              //   press: () {},
              // ),

              // SizedBox(
              //   width: getProportionateScreenWidth(20),
              // )
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  GestureDetector buildSelectAddress(
      {required int index, required BillingModel model}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          addressSelected = index;
          billingModelSelected = model;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(40)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.cancel_outlined),
              iconSize: getProportionateScreenWidth(15),
              color: Colors.red,
              onPressed:
                  _isShown == true ? () => _delete(context, model) : null,
            ),
            SizedBox(
              width: SizeConfig.screenWidth * 0.7,
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "${model.billingName} - ${model.billingPhone}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("${model.billingAddress}")),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: kPrimaryColor),
              width: getProportionateScreenWidth(15),
              height: getProportionateScreenWidth(15),
              child: Row(children: [
                Icon(
                  addressSelected == index ? Icons.check : Icons.circle,
                  size: getProportionateScreenWidth(15),
                  color: Colors.white,
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  void _delete(BuildContext context, BillingModel billingModel) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Do you want to delete this address ?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {
                    int a = await DeleteBilling()
                        .deleteBilling(idBilling: billingModel.id);
                    // Remove the box
                    setState(() {
                      _futureBillings = showBillings(
                          Provider.of<InitProvider>(context, listen: false)
                              .accountModel
                              .id
                              .toString());
                    });

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }
}
