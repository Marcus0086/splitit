import 'package:covidui/constants.dart';
import 'package:covidui/screens/newSplit.dart';
import 'package:flutter/material.dart';

class BottomNavWidget extends StatefulWidget {
  const BottomNavWidget({
    Key key,
    this.size,
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
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: kShadowColor,
            offset: Offset(0, 17),
            spreadRadius: -23,
            blurRadius: 17,
          )
        ],
      ),
      height: widget.size.height * .08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BottomIcons(
            svg: isActive1
                ? Icons.calendar_today_rounded
                : Icons.calendar_today_outlined,
            isActive: isActive1,
            press: () {
              setState(() {
                isActive1 = true;
                isActive2 = false;
                isActive3 = false;
              });
            },
            key: UniqueKey(),
          ),
          BottomIcons(
            svg: isActive2 ? Icons.add_box_rounded : Icons.add_box_outlined,
            isActive: isActive2,
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NewSplit();
              }));
              setState(() {
                isActive1 = false;
                isActive2 = true;
                isActive3 = false;
              });
            },
          ),
          BottomIcons(
            svg: isActive3 ? Icons.settings_rounded : Icons.settings_outlined,
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
  final IconData svg;
  final Function press;
  final bool isActive;
  const BottomIcons({
    Key key,
    this.svg,
    this.press,
    this.isActive = false,
  }) : super(key: key);
  @override
  _BottomIconsState createState() => _BottomIconsState();
}

class _BottomIconsState extends State<BottomIcons> {
  @override
  Widget build(BuildContext context) {
    var svg = widget.svg;
    return GestureDetector(
      onTap: widget.press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RadiantGradientMask(
              child: Icon(svg, color: Colors.white, size: 25),
              colors: [Colors.deepPurple, Colors.deepPurpleAccent]),
        ],
      ),
    );
  }
}
