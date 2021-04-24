import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidui/bottomNav.dart';
import 'package:covidui/constants.dart';
import 'package:covidui/screens/Friends.dart';
import 'package:covidui/screens/dilaogue.dart';
import 'package:covidui/screens/recentSplit.dart';
import 'package:covidui/screens/totalAmount.dart';
import 'package:covidui/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

class BillSplitHomePage extends StatefulWidget {
  final User user;

  const BillSplitHomePage({Key key, @required this.user}) : super(key: key);
  @override
  _BillSplitHomePageState createState() => _BillSplitHomePageState();
}

class _BillSplitHomePageState extends State<BillSplitHomePage> {
  final _amounttextEditingController = TextEditingController();
  final _nameTextEditingController = TextEditingController();
  final _titleTextEditingController = TextEditingController();
  List<Friends> friendsCardsList = [];
  String amount = '';
  String name = '';
  String hintText = 'RS:00.00';
  String namehintText = 'Enter name';
  String title = '';
  Color hintTextColor = Colors.grey;
  void initState() {
    super.initState();
    _amounttextEditingController.addListener(getValue);
    _nameTextEditingController.addListener(getName);
    _titleTextEditingController.addListener(getTitle);
  }

  void getValue() {
    if (_amounttextEditingController.text.isEmpty) {
      friendsCardsList.clear();
    }
    this.amount = _amounttextEditingController.text;
  }

  void getName() {
    this.name = _nameTextEditingController.text;
  }

  void getTitle() {
    this.title = _titleTextEditingController.text;
  }

  void dispose() {
    _amounttextEditingController.dispose();
    _nameTextEditingController.dispose();
    super.dispose();
  }

  Color randColor({List<Color> colors}) {
    final _random = Random();
    return colors[_random.nextInt(colors.length)];
  }

  String randImage({List<String> images}) {
    final _random = Random();
    return images[_random.nextInt(images.length)];
  }

  Widget titleScreen({BuildContext context}) {
    void existRunProcess() async {
      int i = 0;
      bool flag = false;
      for (Friends friend in friendsCardsList) {
        await firestoreInstance
            .collection('users')
            .doc(widget.user.uid)
            .collection('data')
            .doc(widget.user.email)
            .update({
          this.title + " " + this.amount: FieldValue.arrayUnion([
            {'Friends$i': friend.toJson()}
          ])
        }).then((value) {
          flag = true;
        });
        i++;
      }
      if (flag) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) => CustomAlertDialog(
                  title: Text(
                    'Done!',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  message: "See your Split or Back to Home!",
                  positiveBtnText: 'To Split',
                  negativeBtnText: 'To Home',
                  onNegativePressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  onPostivePressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RecentSplits(user: widget.user)));
                  },
                ));
      }
    }

    void addUser() async {
      if (_titleTextEditingController.text.isNotEmpty) {
        var isExist = await firestoreInstance
            .collection('users')
            .doc(widget.user.uid)
            .collection('data')
            .doc(widget.user.email)
            .get();

        if (isExist.exists) {
          existRunProcess();
        } else {
          await firestoreInstance
              .collection('users')
              .doc(widget.user.uid)
              .collection('data')
              .doc(widget.user.email)
              .set({});
          existRunProcess();
        }
      } else {
        setState(() {
          hintTextColor = Colors.red[300];
        });
      }
    }

    bool isVisible = false;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBlueColor,
        onPressed: () {
          if (_titleTextEditingController.text.isNotEmpty) {
            setState(() {
              isVisible = true;
            });
            FocusScope.of(context).requestFocus(new FocusNode());
            isVisible
                ? showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Processing',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: size.height * .05),
                              CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            ],
                          ),
                        ))
                : Container();
            addUser();
          }
        },
        child: Icon(Icons.done),
      ),
      appBar: AppBar(
        backgroundColor: kBlueColor,
        centerTitle: true,
        title: Icon(Icons.person_rounded),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Your Split!',
              style: GoogleFonts.montserrat(
                  color: kTextColor, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 82),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                    hintText: "Enter title!",
                    hintStyle: TextStyle(color: hintTextColor),
                    icon: Icon(Icons.title),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero),
                style: GoogleFonts.montserrat(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: friendsCardsList
                  .map((friend) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: friendsCards(
                            friend: friend,
                            child: Icon(Icons.done, color: Colors.green[400]),
                            amount: this.amount,
                            image: friend.image,
                            size: size,
                            color: friend.color,
                            splashColor: Colors.red),
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(29)),
                border: Border.all(color: kBlueLightColor),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.money,
                    color: Colors.green[300],
                  ),
                  SizedBox(width: size.width * .01),
                  Center(
                    child: Text(
                      'Total:' + '\u20B9' + '${this.amount}',
                      style: GoogleFonts.montserrat(
                          color: kTextColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
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

  Widget friendsCards(
      {BuildContext context,
      @required Friends friend,
      Widget child,
      @required String amount,
      @required String image,
      @required Size size,
      @required Color color,
      @required Color splashColor}) {
    double newAmount = double.parse(amount);
    newAmount /= friendsCardsList.length;
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
                        padding: const EdgeInsets.all(18.0),
                        child: Row(children: <Widget>[
                          SvgPicture.asset(
                            friend.image,
                            width: size.width * .05,
                            height: size.height * .05,
                          ),
                          SizedBox(width: size.width * .05),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${friend.name}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${newAmount.toStringAsFixed(2)}',
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
      body: Stack(children: [
        SafeArea(
            bottom: true,
            child: ListView(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: size.height * .045,
                      width: size.width * .1,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF817DCF),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 60.0,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            radius: 60.0,
                            child: ClipOval(
                              child: widget.user.photoURL != null
                                  ? Image(
                                      image: NetworkImage(
                                          widget.user.photoURL.toString()))
                                  : SvgPicture.asset(
                                      'assets/icons/profile.svg'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: Column(children: [
                            Container(
                              height: size.height * .072,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.red[200],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    child: CircleAvatar(
                                      radius: 26,
                                      backgroundColor: Colors.yellow[100],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.orange[400],
                                    ),
                                  ),
                                  Positioned(
                                    right: 64,
                                    top: 0,
                                    bottom: 0,
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.amber[200],
                                    ),
                                  ),
                                  Positioned(
                                    right: 48,
                                    top: 0,
                                    bottom: 0,
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.red[300],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * .012,
                            ),
                            Text(
                              "Enter Amount",
                              style: TextStyle(fontSize: 16),
                            ),
                            TotalAmountField(
                              size: size,
                              textEditingController:
                                  _amounttextEditingController,
                              hintText: this.hintText,
                            ),
                            SizedBox(
                              height: size.height * .012,
                            ),
                            TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(kBlueColor),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    this.amount =
                                        _amounttextEditingController.text;
                                    if (FocusScope.of(context).isFirstFocus) {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                    }
                                  });
                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 60),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text('Submit',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ))),
                                        ]))),
                          ])))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "All Friends(${friendsCardsList.length})",
                      style: GoogleFonts.montserrat(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: size.height * .012,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        padding: EdgeInsets.all(6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Row(
                            children: [
                              Container(
                                height: size.height * .08,
                                width: size.width * .68,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: TextField(
                                      controller: _nameTextEditingController,
                                      decoration: InputDecoration(
                                          hintText: this.namehintText,
                                          icon: Icon(Icons.person),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero),
                                      style: GoogleFonts.montserrat(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height * .08,
                                width: size.width * .21,
                                color: kBlueLightColor,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: kBlueColor,
                                    onTap: () {
                                      if (_amounttextEditingController
                                              .text.isNotEmpty &&
                                          _nameTextEditingController
                                              .text.isNotEmpty) {
                                        setState(() {
                                          Friends newFriend = Friends(
                                            name: this.name,
                                            color: randColor(colors: [
                                              Colors.red[200],
                                              Colors.blue[200],
                                              Colors.green[200],
                                              Colors.pink[100],
                                              kBlueLightColor,
                                              kBlueColor
                                            ]),
                                            image: randImage(images: [
                                              'assets/icons/male.svg',
                                              'assets/icons/profile.svg',
                                              'assets/icons/profile.svg',
                                              'assets/icons/male.svg'
                                            ]),
                                            key: UniqueKey(),
                                          );
                                          friendsCardsList.add(newFriend);
                                          _nameTextEditingController.clear();
                                        });
                                      } else {
                                        setState(() {
                                          this.hintText = 'Enter money';
                                          this.namehintText = 'Enter name';
                                        });
                                      }
                                    },
                                    child: Center(
                                      child:
                                          Icon(Icons.add, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: size.height * .28,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: friendsCardsList.length > 0
                          ? friendsCardsList
                              .map((friend) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: friendsCards(
                                        friend: friend,
                                        child: FloatingActionButton(
                                            heroTag: UniqueKey().toString(),
                                            backgroundColor: friend.color,
                                            elevation: 0,
                                            onPressed: () {
                                              setState(() {
                                                friendsCardsList.removeAt(
                                                    friendsCardsList
                                                        .indexOf(friend));
                                              });
                                            },
                                            child: Icon(Icons.delete_forever)),
                                        amount: this.amount,
                                        image: friend.image,
                                        size: size,
                                        color: friend.color,
                                        splashColor: Colors.red),
                                  ))
                              .toList()
                          : [Container()],
                    )),
              ),
            ]))
      ]),
      bottomNavigationBar: BottomNavWidget(
        size: MediaQuery.of(context).size,
        svg: FloatingActionButton(
          splashColor: kBlueLightColor,
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: Icon(Icons.home),
          backgroundColor: kBlueColor,
        ),
        user: widget.user,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'button2',
        backgroundColor: Colors.red,
        child: Icon(Icons.done),
        onPressed: () async {
          if (friendsCardsList.isNotEmpty) {
            FocusScope.of(context).requestFocus(new FocusNode());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => titleScreen(context: context)));
          } else {
            setState(() {
              this.hintText = "Empty Field!";
              this.namehintText = 'Enter name!';
            });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
