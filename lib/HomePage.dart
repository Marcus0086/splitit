import 'dart:async';

import 'package:covidui/auth.dart';
import 'package:covidui/bottomNav.dart';
import 'package:covidui/cardWidget.dart';
import 'package:covidui/constants.dart';
import 'package:covidui/login.dart';
import 'package:covidui/screens/detailsScreen.dart';
import 'package:covidui/screens/newSplit.dart';
import 'package:covidui/searchBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key key, this.user}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;
  bool isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void initState() {
    user = widget.user;
    super.initState();
  }

  getScreen(var screen, var context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _drawerKey,
      drawer: SideBar(
        key: UniqueKey(),
        user: widget.user,
        route: _routeToSignInScreen(),
      ),
      bottomNavigationBar: BottomNavWidget(
        size: size,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              image: DecorationImage(
                  alignment: Alignment.centerLeft,
                  image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
                  colorFilter:
                      ColorFilter.mode(kBlueColor, BlendMode.saturation)),
              color: kBlueColor,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SideBarUser(
                        size: size,
                        drawerKey: _drawerKey,
                        user: widget.user,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Split it",
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: size.height * .06,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Bill Splitter",
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: size.height * .05,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  SearchBarWidget(
                    hintText: "Search People",
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        CardWidget(
                          src: "payments.svg",
                          title: "Payments",
                          press: () => getScreen(DetailsScreen(), context),
                          key: UniqueKey(),
                        ),
                        CardWidget(
                          src: "recents.svg",
                          title: "Recent Splits!",
                          press: () {},
                          key: UniqueKey(),
                        ),
                        CardWidget(
                          src: "friendsparty.svg",
                          title: "Friends",
                          press: () {},
                          key: UniqueKey(),
                        ),
                        CardWidget(
                          src: "new.svg",
                          title: "New Split!",
                          press: () => getScreen(NewSplit(), context),
                          key: UniqueKey(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
              widget.drawerKey.currentState.openDrawer();
              Timer(Duration(seconds: 1), () {
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
  @override
  Widget build(BuildContext context) {
    var key = UniqueKey().toString();
    var accountName = widget.user.displayName != null
        ? widget.user.displayName.toString()
        : 'User' + key.substring(1, key.length - 1);
    var email = widget.user.email != null
        ? widget.user.email.toString()
        : "test" + key.substring(1, key.length - 1) + "@gmail.com";
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
              ],
            ),
          ),
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
                        child: Icon(Icons.logout))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
