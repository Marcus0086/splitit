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
        value.forEach((keyq, valueq) {
          keys.add([key, keyq, valueq['name']]);
          Friends newFriend = Friends(
              name: valueq['name'],
              color: Color(int.parse(valueq['color'])),
              image: valueq['image']);
          setState(() {
            friendsCardsList.add(newFriend);
          });
        });
      });
    });
  }

  void initState() {
    user = widget.user;
    getFriends(user);
    super.initState();
  }

  Future<void> deleteUser({Friends friend}) async {
    for (dynamic i in keys) {
      var title = i[0];
      if (i[2] == friend.name) {
        await firestoreInstance
            .collection('users')
            .doc(user.uid)
            .collection('data')
            .doc(user.email)
            .update({'$title': FieldValue.delete()});
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
                        padding: const EdgeInsets.all(6.0),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
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
                                    height: size.height * .025,
                                  ),
                                  SvgPicture.asset(
                                    image,
                                    width: size.width * .05,
                                    height: size.height * .05,
                                  ),
                                  SizedBox(
                                    height: size.height * .045,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "$name",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 16,
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
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.25,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                children: friendsCardsList.isNotEmpty
                    ? friendsCardsList
                        .map((friend) => friendsCards(
                            context: context,
                            friend: friend,
                            name: friend.name,
                            image: friend.image,
                            size: size,
                            color: friend.color,
                            splashColor: friend.color))
                        .toList()
                    : [
                        Container(
                          child: Center(
                              child: SvgPicture.asset(
                                  'assets/icons/nothinghere.svg')),
                        )
                      ],
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: kBlueColor,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('My Friends!'),
            SizedBox(width: size.width * .025),
            Icon(Icons.nature_people),
          ],
        ),
        centerTitle: true,
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
      bottomNavigationBar: BottomNavWidget(size: size),
    );
  }
}
