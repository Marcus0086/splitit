import 'package:covidui/bottomNav.dart';
import 'package:covidui/cardWidget.dart';
import 'package:covidui/constants.dart';
import 'package:covidui/login.dart';
import 'package:covidui/screens/billSplitter.dart';
import 'package:covidui/screens/friendsPage.dart';
import 'package:covidui/screens/recentSplit.dart';
import 'package:covidui/searchBar.dart';
import 'package:covidui/sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      floatingActionButton: FloatingActionButton(
        heroTag: 'button1',
        splashColor: kBlueLightColor,
        backgroundColor: kBlueColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BillSplitHomePage(user: user)));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                          src: "new.svg",
                          title: "New Split!",
                          press: () =>
                              getScreen(BillSplitHomePage(user: user), context),
                          key: UniqueKey(),
                        ),
                        CardWidget(
                          src: "friendsparty.svg",
                          title: "Friends",
                          press: () =>
                              getScreen(Friendspage(user: user), context),
                          key: UniqueKey(),
                        ),
                        CardWidget(
                          src: "settingsImage.svg",
                          title: "Settings",
                          press: () => {},
                          key: UniqueKey(),
                        ),
                        CardWidget(
                          src: "recents.svg",
                          title: "Recent Splits!",
                          press: () =>
                              getScreen(RecentSplits(user: user), context),
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
