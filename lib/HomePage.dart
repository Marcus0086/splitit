import 'package:covidui/auth.dart';
import 'package:covidui/bottomNav.dart';
import 'package:covidui/cardWidget.dart';
import 'package:covidui/chart.dart';
import 'package:covidui/constants.dart';
import 'package:covidui/login.dart';
import 'package:covidui/screens/billSplitter.dart';
import 'package:covidui/screens/friendsPage.dart';
import 'package:covidui/screens/recentSplit.dart';
import 'package:covidui/screens/settings.dart';
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
  var _gridViewController;
  double height = 0;
  double aspectratio = 1.5;
  void initState() {
    user = widget.user;
    _gridViewController = ScrollController();
    _gridViewController.addListener(_scrollEvent);
    super.initState();
  }

  _scrollEvent() {
    if (_gridViewController.offset > 0 &&
        !_gridViewController.position.outOfRange) {
      setState(() {
        height = 180;
        aspectratio = 2.5;
      });
    } else if (_gridViewController.offset <=
            _gridViewController.position.minScrollExtent &&
        !_gridViewController.position.outOfRange) {
      setState(() {
        height = 0;
        aspectratio = 1.5;
      });
    }
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
        route: routeToSignInScreen(screen: LoginPage()),
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
        user: user,
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                    child: AnimatedContainer(
                      width: size.width,
                      height: height == 0 ? size.height * .35 : height,
                      duration: Duration(milliseconds: 360),
                      child: LineChartSample1(
                        aspectratio: aspectratio,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 8),
                      child: GridView.builder(
                          controller: _gridViewController,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 300,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemCount: 4,
                          itemBuilder: (BuildContext context, index) {
                            Function getPage() {
                              return index == 0
                                  ? getScreen(
                                      BillSplitHomePage(user: user), context)
                                  : index == 1
                                      ? getScreen(
                                          Friendspage(user: user), context)
                                      : index == 2
                                          ? getScreen(
                                              SettingsPage(user: user), context)
                                          : index == 3
                                              ? getScreen(
                                                  RecentSplits(
                                                    user: user,
                                                  ),
                                                  context)
                                              : null;
                            }

                            return CardWidget(
                              key: UniqueKey(),
                              title: index == 0
                                  ? 'New Split'
                                  : index == 1
                                      ? 'All Friends'
                                      : index == 2
                                          ? 'Settings'
                                          : index == 3
                                              ? 'Recent Splits!'
                                              : '',
                              src: index == 0
                                  ? 'new.svg'
                                  : index == 1
                                      ? 'friendsparty.svg'
                                      : index == 2
                                          ? 'settingsImage.svg'
                                          : index == 3
                                              ? 'recents.svg'
                                              : '',
                              press: getPage,
                            );
                          }),
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
