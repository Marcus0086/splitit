import 'package:flutter/material.dart';

class LinearGradientMask extends StatelessWidget {
  LinearGradientMask({this.child, this.colors});
  final Widget child;
  final List<Color> colors;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: this.colors,
        tileMode: TileMode.repeated,
      ).createShader(bounds),
      child: child,
    );
  }
}
