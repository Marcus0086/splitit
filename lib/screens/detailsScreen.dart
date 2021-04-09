import 'package:auto_size_text/auto_size_text.dart';
import 'package:covidui/bottomNav.dart';
import 'package:covidui/constants.dart';
import 'package:covidui/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<int> screenCards = [1, 2, 3, 4, 5, 6];
    return Scaffold(
      bottomNavigationBar: BottomNavWidget(
        size: size,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            width: size.width,
            decoration: BoxDecoration(
              color: kBlueColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(
                "assets/icons/paymentsscreens.svg",
                width: size.width * .3,
                height: size.height * .3,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: size.height * .02,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: AutoSizeText(
                            "Payments",
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: kTextColor),
                          ),
                        ),
                        SizedBox(
                          height: size.height * .03,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: AutoSizeText(
                            "If you think nobody cares about you then\ntry missing a couple of car payments../",
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: size.width,
                      child: SearchBarWidget(
                        hintText: "Search Payments!",
                        key: UniqueKey(),
                      ),
                    ),
                    Text(
                      "All Payments",
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontWeight: FontWeight.bold, color: kTextColor),
                    ),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: screenCards
                          .map(
                            (i) => ScreenCards(
                              size: size,
                              sessionNo: i,
                              key: UniqueKey(),
                              isDone: (i == 2) ? true : false,
                              press: () {},
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    Text(
                      "Last Transaction",
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontWeight: FontWeight.bold, color: kTextColor),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      padding: EdgeInsets.all(12),
                      height: size.height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 23,
                            spreadRadius: -13,
                            offset: Offset(0, 17),
                            color: kShadowColor,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/icons/paymentsscreens.svg",
                            width: size.width * .06,
                            height: size.height * .06,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "\$7800",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text("Team Party"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.delete_outline_outlined),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenCards extends StatelessWidget {
  final int sessionNo;
  final bool isDone;
  final Function press;
  const ScreenCards({
    Key key,
    this.size,
    this.sessionNo,
    this.isDone = false,
    this.press,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: constraints.maxWidth / 2 - 10,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: kShadowColor,
                offset: Offset(0, 17),
                spreadRadius: -23,
                blurRadius: 17,
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.blueGrey[50],
              onTap: press,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                        height: size.height * .06,
                        width: size.width * .08,
                        child: SvgPicture.asset(
                          "assets/icons/wallet.svg",
                          width: size.width * .1,
                          height: size.height * .1,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Payment $sessionNo",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
