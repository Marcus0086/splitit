import 'package:auto_size_text/auto_size_text.dart';
import 'package:covidui/HomePage.dart';
import 'package:covidui/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User user;

  void initState() {
    super.initState();
    if (this.user != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage(user: this.user)));
    }
  }

  void click() async {
    await signInWithGoogle().then((user) {
      this.user = user;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage(user: this.user)));
    });
  }

  void signInAnonymously() async {
    await auth.signInAnonymously().then((result) => {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(user: result.user))),
        });
  }

  Widget button(
      Size size, Function press, String text, Color color, Widget customIcon) {
    return Container(
      width: size.width * .7,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(color),
            ),
            onPressed: press,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    customIcon,
                    SizedBox(width: size.width * .1),
                    AutoSizeText(
                      '$text',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white),
                    ),
                  ]),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Background(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
          'Login to SplitIt',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: kBlueColor,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
        ),
        SizedBox(height: size.height * .1),
        SvgPicture.asset(
          'assets/icons/login_back.svg',
          height: size.height * .3,
        ),
        SizedBox(height: size.height * .1),
        button(
          size,
          this.click,
          'Log In With Google!',
          kBlueColor,
          SvgPicture.asset(
            'assets/icons/google.svg',
            height: size.height * .025,
          ),
        ),
        SizedBox(
          height: size.height * .05,
          width: size.width * .5,
          child: Align(
            alignment: Alignment.center,
            child: Divider(),
          ),
        ),
        button(
            size,
            this.signInAnonymously,
            'Log In as Test User',
            Color(0xFFfdcf84),
            RadiantGradientMask(
              colors: [Colors.deepPurpleAccent, Colors.deepPurple],
              child: Icon(
                Icons.account_circle_sharp,
                color: Colors.white,
                size: 20,
              ),
            )),
      ],
    ));
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset('assets/images/main_top.png'),
            width: size.width * 0.3,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset('assets/images/main_bottom.png'),
            width: size.width * 0.2,
          ),
          child,
        ],
      ),
    );
  }
}
