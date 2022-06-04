import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniture_app/config.dart';
import 'package:furniture_app/models/product_model.dart';
import '../constants.dart';

import '../size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetion = 1.02,
    required this.product,
    required this.press,
  }) : super(key: key);

  final double width, aspectRetion;
  final ProductModel product;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    double discountPrice = 0.00;
    if (product.discountModel.discountPercent! > 0 &&
        product.discountModel.discountPercent! <= 100) {
      discountPrice = (100 - product.discountModel.discountPercent!) /
          100 *
          double.parse(product.productPrice!);
      discountPrice = double.parse((discountPrice).toStringAsFixed(2));
    }
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(width),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: aspectRetion,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15)),
                  child:
                      Image.network(getImageProductUrl + product.productImage!),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                product.productName!,
                style: const TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (discountPrice == 0)
                    Column(
                      children: [
                        Text(
                          "\$${product.productPrice}",
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(14),
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor),
                        ),
                        Row(
                          children: [
                            Text("",
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontStyle: FontStyle.italic,
                                    fontSize: getProportionateScreenWidth(14),
                                    color: kSecondaryColor)),
                            Text("",
                                style: TextStyle(
                                    fontSize: getProportionateScreenWidth(14),
                                    fontStyle: FontStyle.italic,
                                    color: kSecondaryColor)),
                          ],
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Text("\$$discountPrice",
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(14),
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor)),
                        Row(
                          children: [
                            Text("\$${product.productPrice}",
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontStyle: FontStyle.italic,
                                    fontSize: getProportionateScreenWidth(14),
                                    color: kSecondaryColor)),
                            Text(
                                " (-${product.discountModel.discountPercent}%)",
                                style: TextStyle(
                                    fontSize: getProportionateScreenWidth(14),
                                    fontStyle: FontStyle.italic,
                                    color: kSecondaryColor)),
                          ],
                        ),
                      ],
                    ),
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                      width: getProportionateScreenWidth(28),
                      height: getProportionateScreenWidth(28),
                      decoration: BoxDecoration(
                          color: true
                              ? kPrimaryColor.withOpacity(0.15)
                              : kSecondaryColor.withOpacity(0.1),
                          shape: BoxShape.circle),
                      child: SvgPicture.asset(
                        "assets/icons/Heart Icon_2.svg",
                        color: true
                            ? const Color(0xFFFF4848)
                            : const Color(0xFFD8DEE4),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
