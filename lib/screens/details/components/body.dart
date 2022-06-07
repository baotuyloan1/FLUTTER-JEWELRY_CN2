import 'package:flutter/material.dart';
import 'package:furniture_app/components/default_button.dart';
import 'package:furniture_app/constants.dart';
import 'package:furniture_app/entity/cart.dart';
import 'package:furniture_app/function/show_toast.dart';
import 'package:furniture_app/models/account_model.dart';
import 'package:furniture_app/models/rating_model.dart';
import 'package:furniture_app/provider/init_provider.dart';
import 'package:furniture_app/readAPI/getData/get_rating.dart';
import 'package:furniture_app/readAPI/postData/post_review.dart';
import 'package:furniture_app/screens/reviews/components/reviewui.dart';
import 'package:furniture_app/screens/reviews/reviews.dart';
import 'package:furniture_app/size_config.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../../../models/product_model.dart';
import 'color_dots.dart';
import 'top_rounded_container.dart';
import 'product_description.dart';
import 'product_images.dart';
import 'package:provider/provider.dart';
import '../../../provider/quantity_detail_provider.dart';

class Body extends StatefulWidget {
  final ProductModel productModel;
  const Body({Key? key, required this.productModel}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<RatingModel>>? _futureRatings;
  bool isMore = false;
  bool isRated = false;
  AccountModel? customer;
  List<RatingModel>? ratingsList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureRatings = showRatings(widget.productModel.productId.toString());

    customer = Provider.of<InitProvider>(context, listen: false).accountModel;
    // ratingsList = await showRatings(widget.productModel.productId.toString());
    getRatingData();
  }

  void getRatingData() async {
    ratingsList = await showRatings(widget.productModel.productId.toString());
    for (var rating in ratingsList!) {
      if (customer!.id == rating.customerId) {
        setState(() {
          isRated = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.productModel.colors = [
      const Color(0xFFF6625E),
      const Color(0xFF836DB8),
      const Color(0xFFDECB9C),
      Colors.white,
    ];
    double price = double.parse(widget.productModel.productPrice.toString());
    if (widget.productModel.discountModel.discountPercent! > 0 &&
        widget.productModel.discountModel.discountPercent! <= 100) {
      price = (100 - widget.productModel.discountModel.discountPercent!) /
          100 *
          double.parse(widget.productModel.productPrice!);
      price = double.parse((price).toStringAsFixed(2));
    } else {
      price = double.parse((price).toStringAsFixed(2));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ProductImages(productModel: widget.productModel),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                ProductDescription(
                  productModel: widget.productModel,
                  pressOnSeeMore: () {},
                ),
                TopRoundedContainer(
                  color: const Color(0xFFF6F7F9),
                  child: Column(
                    children: [
                      ColorDots(productModel: widget.productModel),
                      TopRoundedContainer(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.screenWidth * 0.15,
                                right: SizeConfig.screenWidth * 0.15,
                                top: getProportionateScreenWidth(15),
                                bottom: getProportionateScreenWidth(20)),
                            child: DefaultButton(
                                text: "Add to card",
                                press: () async {
                                  var cartProduct = await context
                                      .read<InitProvider>()
                                      .cartDao
                                      .getItemInCartByUid("bao",
                                          widget.productModel.productId!);
                                  if (cartProduct != null) {
                                    cartProduct.quantity =
                                        cartProduct.quantity +
                                            context
                                                .read<QuantityDetailProvider>()
                                                .quantity
                                                .toInt();
                                    await context
                                        .read<InitProvider>()
                                        .cartDao
                                        .updateCart(cartProduct);
                                  } else {
                                    Cart cart = Cart(
                                        id: widget.productModel.productId!,
                                        uid: "bao",
                                        productName:
                                            widget.productModel.productName!,
                                        categoryProduct:
                                            widget.productModel.categoryId!,
                                        imageUrl:
                                            widget.productModel.productImage!,
                                        price: price,
                                        quantity: context
                                            .read<QuantityDetailProvider>()
                                            .quantity);
                                    await context
                                        .read<InitProvider>()
                                        .cartDao
                                        .insertCart(cart);
                                  }
                                  Navigator.pop(context);
                                  showToast(
                                      context: context, color: kPrimaryColor);
                                }),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            isRated
                                ? const Text("Review")
                                : GestureDetector(
                                    onTap: () => showRatingDialog(),
                                    child: const Text(
                                      "Rating this product",
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                  ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.pushNamed(
                                    context, Reviews.routeName, arguments: {
                                  'productId': widget.productModel.productId
                                }).then((value) => refresh());
                              },
                              child: const Text("View all"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<RatingModel>>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          top: getProportionateScreenHeight(8.0),
                          left: getProportionateScreenHeight(16.0),
                          bottom: getProportionateScreenHeight(8.0)),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return ReviewUI(
                            parentFunction: refresh,
                            customerId: snapshot.data![index].customerId!,
                            ratingId: snapshot.data![index].ratingId!,
                            image: snapshot.data![index].customerImage!,
                            name: snapshot.data![index].customerName!,
                            comment: snapshot.data![index].comment!,
                            date: snapshot.data![index].updatedAt!,
                            rating: snapshot.data![index].rating!.toDouble(),
                            onTap: () {
                              setState(() {
                                isMore = !isMore;
                              });
                            },
                            onPressed: () {
                              print("More Action $index");
                            },
                            isLess: isMore);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          thickness: 1,
                        );
                      },
                    );
                  } else {
                    return Text("Data is " + snapshot.data!.isEmpty.toString());
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              future: _futureRatings),
        ],
      ),
    );
  }

  void showRatingDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return RatingDialog(
              title: const Text("Do you like this product ?"),
              message: const Text("Tap on star to rate us"),
              commentHint: "Enter your comment",
              // image: const Icon(
              //   Icons.star,
              //   color: kPrimaryColor,
              // ),
              submitButtonText: "Submit",
              onSubmitted: (response) async {
                int status = await JSONReview().postReview(
                    productId: widget.productModel.productId.toString(),
                    customerId: customer!.id.toString(),
                    rating: response.rating.toString(),
                    comment: response.comment.toString());
                if (status == 1) {
                  setState(() {
                    _futureRatings =
                        showRatings(widget.productModel.productId.toString());
                    getRatingData();
                  });
                } else {
                  showToast1(
                      content: "Can't review this product",
                      color: kPrimaryColor,
                      context: context);
                }
              });
        });
  }

  refresh() {
    setState(() {
      _futureRatings = showRatings(widget.productModel.productId.toString());
    });
  }
}
