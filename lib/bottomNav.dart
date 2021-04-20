import 'package:covidui/constants.dart';
import 'package:covidui/screens/Dashboard.dart';
import 'package:covidui/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomNavWidget extends StatefulWidget {
  final Widget svg;
  final User user;
  const BottomNavWidget({
    Key key,
    this.size,
    this.svg,
    @required this.user,
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
        border: Border.all(color: kBlueLightColor),
        boxShadow: [
          BoxShadow(
            color: kShadowColor,
            offset: Offset(0, 17),
            spreadRadius: -23,
            blurRadius: 17,
          )
        ],
      ),
      height: widget.size.height * .09,
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
                isActive1 = !isActive1;
                isActive2 = false;
                isActive3 = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DashboardScreen(user: widget.user)));
            },
            key: UniqueKey(),
          ),
          widget.svg != null ? widget.svg : Container(),
          BottomIcons(
            svg: isActive3 ? Icons.settings_rounded : Icons.settings_outlined,
            isActive: isActive3,
            press: () {
              setState(() {
                isActive3 = !isActive3;
                isActive1 = false;
                isActive2 = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsPage(
                            user: widget.user,
                          )));
            },
            key: UniqueKey(),
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
    return IconButton(
      onPressed: widget.press,
      iconSize: 22.5,
      icon: RadiantGradientMask(
          child: Icon(svg, color: Colors.white),
          colors: [Colors.deepPurple, Colors.deepPurpleAccent]),
    );
  }
}
