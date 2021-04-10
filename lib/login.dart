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
        FutureBuilder(
          future: initializeFirebase(context: context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error initializing Firebase');
            } else if (snapshot.connectionState == ConnectionState.done) {
              return SignInButton(
                key: UniqueKey(),
                press: signInWithGoogle,
                text: 'Sign In with Google',
                icon: SvgPicture.asset(
                  'assets/icons/google.svg',
                  height: size.height * .03,
                  width: size.width * .03,
                ),
                color: kBlueColor,
              );
            }
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.orange,
              ),
            );
          },
        ),
        SizedBox(
          height: size.height * .025,
          width: size.width * .5,
          child: Align(
            alignment: Alignment.center,
            child: Divider(),
          ),
        ),
        FutureBuilder(
          future: initializeFirebase(context: context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error initializing Firebase');
            } else if (snapshot.connectionState == ConnectionState.done) {
              return SignInButton(
                key: UniqueKey(),
                press: signInAnonymously,
                text: 'Sign In with Guest!',
                icon: Icon(
                  Icons.account_circle_sharp,
                  color: Colors.white,
                  size: 25,
                ),
                color: kBlueColor,
              );
            }
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.orange,
              ),
            );
          },
        ),
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

class SignInButton extends StatefulWidget {
  final Function press;
  final String text;
  final Widget icon;
  final Color color;
  const SignInButton({Key key, this.press, this.text, this.icon, this.color})
      : super(key: key);
  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    var text = widget.text;
    var icon = widget.icon;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            )
          : TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(widget.color),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                User user = await widget.press();
                setState(() {
                  _isSigningIn = false;
                });
                if (user != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomePage(
                            user: user,
                          )));
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    icon,
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        '$text',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
