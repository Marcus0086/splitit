import 'dart:async';
import 'package:covidui/auth.dart';
import 'package:covidui/screens/billSplitter.dart';
import 'package:covidui/screens/friendsPage.dart';
import 'package:covidui/screens/recentSplit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';

class SideBarUser extends StatefulWidget {
  final size;
  final drawerKey;
  final User user;

  const SideBarUser({Key key, this.size, this.drawerKey, this.user})
      : super(key: key);
  @override
  _SideBarUserState createState() => _SideBarUserState();
}

class _SideBarUserState extends State<SideBarUser> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: kShadowColor,
            onTap: () {
              setState(() {
                isClicked = true;
              });
              Timer(Duration(milliseconds: 250), () {
                widget.drawerKey.currentState.openDrawer();
              });
              Timer(Duration(milliseconds: 500), () {
                setState(() {
                  isClicked = false;
                });
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: widget.size.height * .045,
              width: widget.size.width * .1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Color(0xFF817DCF),
              ),
              child: CircleAvatar(
                backgroundColor: isClicked ? Colors.blue : Colors.transparent,
                radius: 60.0,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 60.0,
                    child: ClipOval(
                      child: widget.user.photoURL != null
                          ? Image(
                              image:
                                  NetworkImage(widget.user.photoURL.toString()))
                          : SvgPicture.asset('assets/icons/profile.svg'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SideBar extends StatefulWidget {
  final User user;
  final Route route;
  const SideBar({Key key, this.user, this.route}) : super(key: key);
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final bugQuery = Uri(
      scheme: 'mailto',
      path: 'guptamarcus42@gmail.com',
      queryParameters: {'subject': 'Bugs', 'body': 'Describe the bug here'});
  @override
  Widget build(BuildContext context) {
    var key = UniqueKey().toString();
    var accountName = widget.user.displayName != null
        ? widget.user.displayName.toString()
        : 'User' + key.substring(1, key.length - 1);
    var email = widget.user.email != null
        ? widget.user.email.toString()
        : "test" + key.substring(1, key.length - 1) + "@gmail.com";
    var size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  accountName: Text(
                    accountName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: kTextColor),
                  ),
                  accountEmail: Text(
                    email,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: kTextColor),
                  ),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                        child: widget.user.photoURL != null
                            ? Image(
                                image: NetworkImage(
                                    widget.user.photoURL.toString()))
                            : SvgPicture.asset('assets/icons/male.svg')),
                  ),
                ),
                ListTile(
                  focusColor: Colors.blue,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BillSplitHomePage(user: widget.user)));
                  },
                  title: Row(
                    children: [
                      Icon(Icons.add_circle, color: Colors.blue),
                      SizedBox(width: size.width * .1),
                      Text('New Split!'),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Friendspage(user: widget.user)));
                  },
                  title: Row(
                    children: [
                      Icon(Icons.person_add, color: Colors.orange),
                      SizedBox(width: size.width * .1),
                      Text('All Friends!'),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RecentSplits(user: widget.user)));
                  },
                  title: Row(
                    children: [
                      Icon(Icons.recent_actors, color: Colors.red),
                      SizedBox(width: size.width * .1),
                      Text('Recent Splits!'),
                    ],
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: () {},
                  title: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: size.width * .1),
                      Text('Calender!'),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {},
                  title: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ),
                      SizedBox(width: size.width * .1),
                      Text('Settings!'),
                    ],
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: () {},
                  title: Row(
                    children: [
                      Icon(Icons.badge, color: Colors.orange[200]),
                      SizedBox(width: size.width * .1),
                      Text('About Us!'),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await canLaunch(bugQuery.toString())
                        ? launch(bugQuery.toString())
                        : customSnackBar(content: 'Cannot open url $bugQuery');
                  },
                  title: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.bug,
                        color: Colors.red,
                        size: 20,
                      ),
                      SizedBox(width: size.width * .1),
                      Text('Report Bugs!'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () async {
                          await signOutGoogle(context: context);
                          Navigator.of(context).pushReplacement(widget.route);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: size.width * .1),
                              Text(
                                'Exit!',
                                style: GoogleFonts.montserrat(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ))),
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Copyright by AdditcoX 2021',
              style: GoogleFonts.montserrat(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
