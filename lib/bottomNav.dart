import 'package:covidui/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      height: size.height * .08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BottomIcons(
            svg: "calendar.svg",
            text: "today",
            isActive: false,
          ),
          BottomIcons(
            svg: "home.svg",
            text: "Home",
            isActive: true,
          ),
          BottomIcons(
            svg: "Settings.svg",
            text: "Settings",
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class BottomIcons extends StatelessWidget {
  final String svg;
  final String text;
  final Function press;
  final bool isActive;
  const BottomIcons({
    Key key,
    this.svg,
    this.text,
    this.press,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SvgPicture.asset(
            "assets/icons/$svg",
            color: isActive ? kActiveIconColor : kTextColor,
            width: MediaQuery.of(context).size.width * .03,
            height: MediaQuery.of(context).size.height * .03,
          ),
          Text(
            "$text",
            style: TextStyle(color: isActive ? kActiveIconColor : kTextColor),
          ),
        ],
      ),
    );
  }
}
