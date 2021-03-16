import 'package:covidui/bottomNav.dart';
import 'package:covidui/cardWidget.dart';
import 'package:covidui/constants.dart';
import 'package:covidui/screens/detailsScreen.dart';
import 'package:covidui/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  getScreen(var screen, var context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return screen;
    }));
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[],
        ),
      ),
      bottomNavigationBar: BottomNavWidget(size: size),
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
                  Align(
                    alignment: Alignment.topRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _drawerKey.currentState.openDrawer(),
                          child: Container(
                            alignment: Alignment.center,
                            height: size.height * .05,
                            width: size.width * .12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF817DCF),
                            ),
                            child: SvgPicture.asset("assets/icons/menu.svg"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
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
                        ),
                        CardWidget(
                          src: "recents.svg",
                          title: "Recent Splits!",
                          press: () {},
                        ),
                        CardWidget(
                          src: "friendsparty.svg",
                          title: "Friends",
                          press: () {},
                        ),
                        CardWidget(
                          src: "new.svg",
                          title: "New Split!",
                          press: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
