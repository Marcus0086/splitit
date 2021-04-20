import 'package:covidui/auth.dart';
import 'package:covidui/login.dart';
import 'package:covidui/screens/aboutus.dart';
import 'package:covidui/screens/dilaogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final User user;

  const SettingsPage({Key key, @required this.user}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _gitlink = 'https://github.com/Marcus0086/splitit';
  final _licenselink = 'https://www.gnu.org/licenses/gpl-3.0.txt';
  final _privacyPolicy =
      'https://www.freeprivacypolicy.com/live/441b2bc5-be44-4800-bbb8-b97489e815e1';
  final bugQuery = Uri(
      scheme: 'mailto',
      path: 'guptamarcus42@gmail.com',
      queryParameters: {'subject': 'Bugs', 'body': 'Describe the bug here'});
  final contactUs = Uri(
      scheme: 'mailto',
      path: 'guptamarcus42@gmail.com',
      queryParameters: {'subject': 'Contact Us'});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: Text('Settings!'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialog(
                              title: Text('Restart App!'),
                              positiveBtnText: 'Restart',
                              onPostivePressed: () {
                                Phoenix.rebirth(context);
                              },
                              negativeBtnText: 'Cancel',
                              onNegativePressed: () {
                                Navigator.pop(context);
                              },
                            ));
                  },
                  title: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.wrench, color: Colors.blue[300]),
                      SizedBox(
                        width: size.width * .1,
                      ),
                      Text('Repair App!'),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await canLaunch(_gitlink)
                        ? await launch(_gitlink)
                        : customSnackBar(content: 'Cannot open url $_gitlink');
                  },
                  title: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.github, color: Colors.grey),
                      SizedBox(
                        width: size.width * .1,
                      ),
                      Text('Code Used in App!'),
                    ],
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: () async {
                    await canLaunch(_licenselink)
                        ? await launch(_licenselink)
                        : customSnackBar(
                            content: 'Cannot launch url $_licenselink');
                  },
                  title: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.idCardAlt, color: Colors.red),
                      SizedBox(
                        width: size.width * .1,
                      ),
                      Text('License'),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutUs(
                                user: widget.user,
                              ))),
                  title: Row(
                    children: [
                      Icon(Icons.badge, color: Colors.orange[200]),
                      SizedBox(width: size.width * .1),
                      Text('About Us!'),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await canLaunch(_privacyPolicy)
                        ? await launch(_privacyPolicy)
                        : customSnackBar(
                            content: 'cannot open url $_privacyPolicy');
                  },
                  title: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.lock, color: Colors.red[200]),
                      SizedBox(
                        width: size.width * .1,
                      ),
                      Text('Privacy Policy'),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await canLaunch(bugQuery.toString())
                        ? launch(bugQuery.toString())
                        : customSnackBar(content: 'Cannot open url $bugQuery');
                  },
                  title: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.bug,
                        color: Colors.red,
                        size: 20,
                      ),
                      SizedBox(width: size.width * .1),
                      Text('Report Bugs!'),
                    ],
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: () async {
                    await canLaunch(contactUs.toString())
                        ? await launch(contactUs.toString())
                        : customSnackBar(content: 'Cannot open url $contactUs');
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.contact_mail,
                        color: Colors.green[200],
                        size: 20,
                      ),
                      SizedBox(width: size.width * .1),
                      Text('Contact Us!'),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await signOutGoogle(context: context);
                    Navigator.of(context).pushReplacement(
                        routeToSignInScreen(screen: LoginPage()));
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 20,
                      ),
                      SizedBox(width: size.width * .1),
                      Text('Sign Out'),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Copyright by AdditcoX 2021',
                      style: GoogleFonts.montserrat(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
