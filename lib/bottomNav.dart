import 'package:auto_size_text/auto_size_text.dart';
import 'package:covidui/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavWidget extends StatefulWidget {
  const BottomNavWidget({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;
  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  bool isActive1 = false;
  bool isActive2 = false;
  bool isActive3 = false;

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
      height: widget.size.height * .08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BottomIcons(
            svg: "calendar.svg",
            text: "today",
            isActive: isActive1,
            press: () {
              setState(() {
                isActive1 = true;
                isActive2 = false;
                isActive3 = false;
              });
            },
          ),
          BottomIcons(
            svg: "home.svg",
            text: "Home",
            isActive: isActive2,
            press: () {
              if (ModalRoute.of(context).settings.name != '/') {
                setState(() {
                  isActive2 = true;
                });
              } else {
                setState(() {
                  isActive1 = false;
                  isActive3 = false;
                });
              }
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          BottomIcons(
            svg: "Settings.svg",
            text: "Settings",
            isActive: isActive3,
            press: () {
              setState(() {
                isActive3 = true;
                isActive1 = false;
                isActive2 = false;
              });
            },
          ),
        ],
      ),
    );
  }
}

class BottomIcons extends StatefulWidget {
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
  _BottomIconsState createState() => _BottomIconsState();
}

class _BottomIconsState extends State<BottomIcons> {
  @override
  Widget build(BuildContext context) {
    var text = widget.text;
    var svg = widget.svg;
    return GestureDetector(
      onTap: widget.press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SvgPicture.asset(
            "assets/icons/$svg",
            color: widget.isActive ? kActiveIconColor : kTextColor,
            width: MediaQuery.of(context).size.width * .02,
            height: MediaQuery.of(context).size.height * .02,
          ),
          AutoSizeText(
            "$text",
            style: TextStyle(
                color: widget.isActive ? kActiveIconColor : kTextColor,
                fontSize: 10),
          ),
        ],
      ),
    );
  }
}
