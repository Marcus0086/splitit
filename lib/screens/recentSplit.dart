import 'package:covidui/bottomNav.dart';
import 'package:covidui/constants.dart';
import 'package:covidui/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  List allFriends = [];
  bool shShown = false;
  getFriends(User user) async {
    await firestoreInstance
        .collection('users')
        .doc(user.uid)
        .collection('data')
        .doc(user.email)
        .get()
        .then((friend) {
      friend.data().forEach((key, value) {
        List names = [];
        var kv = key.split(' ');
        var fkv = kv.join(" ").toString();
        for (dynamic friends in value) {
          friends.forEach((keyq, valueq) {
            names.add(valueq['name']);
          });
        }
        allFriends.add([fkv, names]);
        keys.add(fkv);
      });
    });
    for (String key in keys) {
      var titleLi = key.split(' ');
      var amount = titleLi.removeLast();
      var title = titleLi.join(" ").toString();
      userCards.add([title, amount]);
    }
  }

  void initState() {
    user = widget.user;
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
              future: getFriends(user),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error getting data!');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: userCards.length,
                          itemBuilder: (BuildContext context, index) {
                            var user = userCards[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(19)),
                              elevation: 8.0,
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: Center(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    leading: Container(
                                      padding: EdgeInsets.only(right: 12.0),
                                      decoration: new BoxDecoration(
                                          border: new Border(
                                              right: new BorderSide(
                                                  width: 1.0,
                                                  color: Colors.white24))),
                                      child: Icon(Icons.people,
                                          color: Colors.white),
                                    ),
                                    title: Text(
                                      '${user[0]}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        'Amount: ' + '\u20B9' + '${user[1]}',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            );
                          }));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/icons/nothinghere.svg',
                        height: size.height * .25,
                      ),
                    ),
                    SizedBox(height: size.height * .025),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No Events',
                        style: TextStyle(
                          color: Colors.black38,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                );
              }),
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
