import 'package:flutter/material.dart';
import 'package:furniture_app/constants.dart';
import 'package:furniture_app/function/show_toast.dart';
import 'package:furniture_app/provider/init_provider.dart';
import 'package:furniture_app/readAPI/postData/post_review.dart';
import 'package:furniture_app/size_config.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ReviewUI extends StatelessWidget {
  String image, name, date, comment;
  int ratingId, customerId;
  double rating;
  bool isLess;
  Function() parentFunction;
  GestureTapCallback onTap, onPressed;

  ReviewUI(
      {Key? key,
      required this.parentFunction,
      required this.customerId,
      required this.ratingId,
      required this.image,
      required this.name,
      required this.date,
      required this.comment,
      required this.rating,
      required this.onTap,
      required this.isLess,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customer =
        Provider.of<InitProvider>(context, listen: false).accountModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: getProportionateScreenHeight(45.0),
              width: getProportionateScreenHeight(45.0),
              margin:
                  EdgeInsets.only(right: getProportionateScreenHeight(16.0)),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(44.0)),
            ),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                    fontSize: getProportionateScreenHeight(20.0),
                    fontWeight: FontWeight.bold),
              ),
            ),
            // IconButton(
            //     onPressed: () {

            //       PopupMenuButton(
            //           itemBuilder: (context) => const [
            //                 PopupMenuItem(
            //                   child: Text("Bảo"),
            //                 ),
            //                 PopupMenuItem(child: Text("Bảo1"))
            //               ]);
            //     },
            //     icon: const Icon(Icons.more_vert))
            customer.id == customerId
                ? PopupMenuButton(
                    itemBuilder: (contextx) {
                      return [
                        const PopupMenuItem<int>(
                            value: 0, child: Text("Delete Review")),
                        const PopupMenuItem<int>(
                            value: 1, child: Text("Edit Review")),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {}
                      if (value == 1) {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return RatingDialog(
                                  title: const Text("Update your review ?"),
                                  message: const Text("Tap on star to rate us"),
                                  commentHint: "Enter your comment",
                                  // image: const Icon(
                                  //   Icons.star,
                                  //   color: kPrimaryColor,
                                  // ),
                                  submitButtonText: "Submit",
                                  onSubmitted: (response) async {
                                    int status = await JSONReview().editReview(
                                      comments: response.comment,
                                      reviewId: ratingId.toString(),
                                      rating: response.rating,
                                    );
                                    if (status == 1) {
                                      parentFunction();
                                    } else {
                                      showToast1(
                                          content: "Can't review this product",
                                          color: kPrimaryColor,
                                          context: context);
                                    }
                                  });
                            });
                        // JSONReview().editReview(reviewId: ratingId.toString(), rating: rating, comments: comment)
                      }
                    },
                  )
                : const SizedBox(
                    height: 0,
                  )
          ],
        ),
        Row(
          children: [
            SmoothStarRating(
              starCount: 5,
              color: kPrimaryColor,
              rating: rating,
              size: getProportionateScreenHeight(28.0),
              borderColor: kPrimaryColor,
            ),
            SizedBox(
              width: getProportionateScreenHeight(5.0),
            ),
            Text(
              date,
              style: TextStyle(fontSize: getProportionateScreenHeight(14.0)),
            )
          ],
        ),
        SizedBox(height: getProportionateScreenHeight(5.0)),
        GestureDetector(
          onTap: onTap,
          child: isLess
              ? Text(
                  comment,
                )
              : Text(
                  comment,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
        )
      ],
    );
  }

  void showRatingDialog() {}
}
