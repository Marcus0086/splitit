import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xFFF8F8F8);
const kActiveIconColor = Color(0xFFE68342);
const kTextColor = Color(0xFF222B45);
const kBlueLightColor = Color(0xFFC7B8F5);
const kBlueColor = Color(0xFF817DC0);
const kShadowColor = Color(0xFFE6E6E6);

class CustomColor {
  static const Color dark_blue = Color(0xFF05008b);
  static const Color dark_cyan = Color(0xFF025ab5);
  static const Color sea_blue = Color(0xFF106db6);
  static const Color neon_green = Color(0xFF51ca98);
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({@required this.child, @required this.colors});
  final Widget child;
  final List<Color> colors;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: colors,
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
