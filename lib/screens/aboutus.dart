import 'package:covidui/bottomNav.dart';
import 'package:covidui/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatelessWidget {
  final User user;

  const AboutUs({Key key, @required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavWidget(
        size: size,
        user: user,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBlueColor,
        onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        child: Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/icons/about.svg',
                    height: size.height * .15,
                  ),
                ),
                Center(
                    child: Text(
                  'About SplitIt',
                  style: GoogleFonts.montserrat(
                      fontSize: 24, fontWeight: FontWeight.bold),
                )),
                SizedBox(height: size.height * .01),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'What is SplitIt?',
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ),
                SizedBox(height: size.height * .005),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "SplitIt is a free bill splitting app made by the team of AdditcoX.SplitIt started as a personal small project built just for fun but by nimplementing various new technologies team understood that this project can be scaled up for various purposes like: money management,time management. By using google calender api, the user can create various events like: small gatherings, dinners, etc.The User don't have to think about money management, by using SplitIt user can split bill with others very easily.",
                    style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Example Split',
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('assets/images/splitss.png'),
                    fit: BoxFit.contain,
                    height: size.height * .65,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'About Us',
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'AdditcoX is a small texm of four beginner developers.\nWho are trying their best in the fast growing world of software engineering and flutter.\nThank You for using our app!',
                    style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ),
                SizedBox(height: size.height * .025),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
