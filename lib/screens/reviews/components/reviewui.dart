import 'package:flutter/material.dart';
import 'package:furniture_app/constants.dart';
import 'package:furniture_app/size_config.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ReviewUI extends StatelessWidget {
  String image, name, date, comment;
  double rating;
  bool isLess;

  GestureTapCallback onTap, onPressed;

  ReviewUI(
      {Key? key,
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
            IconButton(onPressed: onPressed, icon: const Icon(Icons.more_vert))
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
}
