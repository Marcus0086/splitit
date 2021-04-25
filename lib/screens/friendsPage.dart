import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidui/bottomNav.dart';
import 'package:covidui/constants.dart';
import 'package:covidui/screens/Friends.dart';
import 'package:covidui/screens/dilaogue.dart';
import 'package:covidui/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Friendspage extends StatefulWidget {
  final User user;

  const Friendspage({Key key, @required this.user}) : super(key: key);
  @override
  _FriendspageState createState() => _FriendspageState();
}

class _FriendspageState extends State<Friendspage> {
  User user;
  List<Friends> friendsCardsList = [];
  List keys = [];
  void getFriends(User user) async {
    await firestoreInstance
        .collection('users')
        .doc(user.uid)
        .collection('data')
        .doc(user.email)
        .get()
        .then((friend) {
      friend.data().forEach((key, value) {
        for (dynamic friends in value) {
          friends.forEach((keyq, valueq) {
            keys.add([key, keyq, valueq]);
            Friends newFriend = Friends(
              name: valueq['name'],
              color: Color(int.parse(valueq['color'])),
              image: valueq['image'],
            );
            setState(() {
              friendsCardsList.add(newFriend);
            });
          });
        }
      });
    });
  }

  void initState() {
    user = widget.user;
    getFriends(user);
    super.initState();
  }

  deleteUser({Friends friend}) async {
    for (dynamic key in keys) {
      var title = key[0];
      var friendsI = key[1];
      if (key[2]['name'] == friend.name &&
          Color(int.parse(key[2]['color'])) == friend.color &&
          key[2]['image'] == friend.image) {
        await firestoreInstance
            .collection('users')
            .doc(user.uid)
            .collection('data')
            .doc(user.email)
            .update({
          '$title': FieldValue.arrayRemove([
            {friendsI: friend.toJson()}
          ])
        });
      }
    }
  }

  Widget friendsCards(
      {@required BuildContext context,
      @required Friends friend,
      @required String name,
      @required String image,
      @required Size size,
      @required Color color,
      @required Color splashColor}) {
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
                    splashColor: splashColor,
                    child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                iconSize: 18,
                                splashColor: splashColor,
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => CustomAlertDialog(
                                            title: Text(
                                              'Delete Friend!',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            message:
                                                'Are you sure you want to delete ${friend.name}',
                                            positiveBtnText: 'Delete',
                                            negativeBtnText: 'Cancel',
                                            onPostivePressed: () {
                                              setState(() {
                                                deleteUser(friend: friend);
                                                friendsCardsList.removeAt(
                                                    friendsCardsList
                                                        .indexOf(friend));
                                              });
                                              Navigator.pop(context);
                                            },
                                            onNegativePressed: () {
                                              Navigator.pop(context);
                                            },
                                          ));
                                },
                              ),
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: size.height * .01,
                                  ),
                                  SvgPicture.asset(
                                    image,
                                    width: size.width * .04,
                                    height: size.height * .04,
                                  ),
                                  SizedBox(
                                    height: size.height * .025,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "$name",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                          ],
                        ))))));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              flex: 1,
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/friendsparty.svg',
                  height: size.height * .25,
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Text(
              friendsCardsList.isNotEmpty
                  ? 'All Friends(${friendsCardsList.length})'
                  : 'No Friends Yet!',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: friendsCardsList.length,
                  itemBuilder: (BuildContext context, index) {
                    var friend = friendsCardsList[index];
                    return friendsCards(
                        context: context,
                        friend: friend,
                        name: friend.name,
                        image: friend.image,
                        size: size,
                        color: friend.color,
                        splashColor: friend.color);
                  }),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBlueColor,
        splashColor: kBlueLightColor,
        onPressed: () {
          Navigator.pop(context);
        },
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
