import 'package:covidui/bottomNav.dart';
import 'package:covidui/constants.dart';
import 'package:covidui/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_color/random_color.dart';

class RecentSplits extends StatefulWidget {
  final User user;

  const RecentSplits({Key key, this.user}) : super(key: key);
  @override
  _RecentSplitsState createState() => _RecentSplitsState();
}

class _RecentSplitsState extends State<RecentSplits> {
  User user;
  Set keys = Set();
  List userCards = [];
  void getFriends(User user) async {
    await firestoreInstance
        .collection('users')
        .doc(user.uid)
        .collection('data')
        .doc(user.email)
        .get()
        .then((friend) {
      friend.data().forEach((key, value) {
        var kv = key.split(' ');
        kv.removeAt(0);
        keys.add(kv.join(" ").toString());
      });
    });
    for (String key in keys) {
      var titleLi = key.split(' ');
      var amount = titleLi.removeLast();
      var title = titleLi.join().toString();
      setState(() {
        userCards.add([title, amount]);
      });
    }
  }

  void initState() {
    user = widget.user;
    getFriends(user);
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget friendsCards(
      {BuildContext context,
      @required String title,
      Widget child,
      @required String amount,
      @required Size size,
      @required Color color,
      Color splashColor}) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
            decoration: BoxDecoration(
              color: color,
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
                    splashColor:
                        splashColor != null ? splashColor : Colors.grey,
                    child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: ClipRRect(
                                    child: Text(
                                      "Title:$title",
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Total:' + '\u20B9' + '$amount',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          child != null ? child : Container(),
                        ]))))));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 1,
              childAspectRatio: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: userCards.isNotEmpty
                  ? userCards
                      .map((user) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: friendsCards(
                              title: user[0],
                              amount: user[1],
                              size: size,
                              color: RandomColor().randomColor(
                                  colorBrightness: ColorBrightness.light,
                                  colorHue: ColorHue.multiple(colorHues: [
                                    ColorHue.blue,
                                    ColorHue.orange
                                  ])),
                            ),
                          ))
                      .toList()
                  : [Container()],
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: kBlueColor,
        title: Icon(Icons.people),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        backgroundColor: kBlueColor,
        child: Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavWidget(
        size: size,
        user: user,
      ),
    );
  }
}
