import 'package:flutter/material.dart';
import 'package:furniture_app/constants.dart';
import 'package:furniture_app/models/rating_model.dart';
import 'package:furniture_app/readAPI/getData/get_rating.dart';
import 'package:furniture_app/screens/reviews/components/reviewui.dart';
import 'package:furniture_app/size_config.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class Reviews extends StatefulWidget {
  static String routeName = "/review";
  final Map<String, dynamic>? args;
  const Reviews(this.args, {Key? key}) : super(key: key);

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  Future<List<RatingModel>>? _futureRatings;
  bool isMore = false;
  int countRating1 = 0;
  int countRating2 = 0;
  int countRating3 = 0;
  int countRating4 = 0;
  int countRating5 = 0;
  List<double> ratingPercentList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureRatings = showRatings(widget.args!["productId"].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review")),
      body: FutureBuilder<List<RatingModel>>(
        future: _futureRatings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              int ratingTotal = 0;
              for (var rating in snapshot.data!) {
                ratingTotal += rating.rating!;
                if (rating.rating! == 1) {
                  countRating1++;
                }
                if (rating.rating! == 2) {
                  countRating2++;
                }
                if (rating.rating! == 3) {
                  countRating3++;
                }
                if (rating.rating! == 4) {
                  countRating4++;
                }
                if (rating.rating! == 5) {
                  countRating5++;
                }
              }
              int totalCount = (countRating1 +
                  countRating2 +
                  countRating3 +
                  countRating4 +
                  countRating5);
              double percentRating1 = countRating1 / totalCount;
              double percentRating2 = countRating2 / totalCount;
              double percentRating3 = countRating3 / totalCount;
              double percentRating4 = countRating4 / totalCount;
              double percentRating5 = countRating5 / totalCount;
              ratingPercentList.add(percentRating1);
              ratingPercentList.add(percentRating2);
              ratingPercentList.add(percentRating3);
              ratingPercentList.add(percentRating4);
              ratingPercentList.add(percentRating5);
              double ratingMean = ratingTotal / snapshot.data!.length;
              String ratingMeann =
                  double.parse(ratingMean.toString()).toStringAsFixed(1);
              return Column(
                children: [
                  Container(
                    color: kPrimaryLightColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenHeight(16.0),
                        vertical: getProportionateScreenHeight(16.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: ratingMeann,
                                  style: const TextStyle(
                                      fontSize: 48.0, color: Colors.black)),
                              const TextSpan(
                                  text: "/5",
                                  style: TextStyle(
                                      fontSize: 24.0, color: kSecondaryColor)),
                            ])),
                            SmoothStarRating(
                              starCount: 5,
                              rating: double.parse(ratingMeann),
                              size: getProportionateScreenHeight(28.0),
                              color: kPrimaryColor,
                              borderColor: kPrimaryColor,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(16.0),
                            ),
                            Text(
                              "${snapshot.data!.length} Reviews",
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(20.0),
                                  color: kSecondaryColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text(
                                    (++index).toString(),
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(16.0)),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenHeight(4.0),
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: kPrimaryColor,
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenHeight(8.0),
                                  ),
                                  LinearPercentIndicator(
                                    percent: ratingPercentList[--index],
                                    barRadius: const Radius.circular(16),
                                    lineHeight:
                                        getProportionateScreenHeight(6.0),
                                    width:
                                        MediaQuery.of(context).size.width / 2.8,
                                    animation: true,
                                    animationDuration: 2500,
                                    progressColor: kPrimaryColor,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(
                          top: getProportionateScreenHeight(8.0),
                          left: getProportionateScreenHeight(16.0),
                          bottom: getProportionateScreenHeight(8.0)),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ReviewUI(
                            parentFunction: refresh,
                            customerId: snapshot.data![index].customerId!,
                            ratingId: snapshot.data![index].ratingId!,
                            image: snapshot.data![index].customerImage!,
                            name: snapshot.data![index].customerName!,
                            comment: snapshot.data![index].comment ?? "",
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
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  refresh() {
    setState(() {
      _futureRatings = showRatings(widget.args!["productId"].toString());
    });
  }
}
