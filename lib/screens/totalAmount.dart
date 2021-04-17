import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TotalAmountField extends StatelessWidget {
  final String hintText;
  const TotalAmountField({
    Key key,
    @required this.size,
    @required TextEditingController textEditingController,
    this.hintText,
  })  : _textEditingController = textEditingController,
        super(key: key);

  final Size size;
  final TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * .4,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: TextField(
          keyboardType: TextInputType.number,
          controller: _textEditingController,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              hintText: this.hintText,
              icon: Icon(Icons.edit_outlined),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero),
          style:
              GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
