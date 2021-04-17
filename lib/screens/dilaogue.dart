import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color bgColor;
  final Widget title;
  final String message;
  final String positiveBtnText;
  final String negativeBtnText;
  final Function onPostivePressed;
  final Function onNegativePressed;
  final double circularBorderRadius;

  CustomAlertDialog({
    this.title,
    this.message,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    this.positiveBtnText,
    this.negativeBtnText,
    this.onPostivePressed,
    this.onNegativePressed,
  })  : assert(bgColor != null),
        assert(circularBorderRadius != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? title : Container(),
      content: message != null
          ? Text(
              message,
              style: GoogleFonts.montserrat(
                fontSize: 16,
              ),
            )
          : Text(''),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: <Widget>[
        negativeBtnText != null
            ? TextButton(
                child: Text(negativeBtnText),
                onPressed: onNegativePressed,
              )
            : Container(),
        positiveBtnText != null
            ? TextButton(
                child: Text(positiveBtnText),
                onPressed: onPostivePressed,
              )
            : Container(),
      ],
    );
  }
}
