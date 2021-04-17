import 'package:flutter/material.dart';

class Friends {
  String name;
  Color color;
  Key key;
  String image;
  Friends(
      {@required String name,
      @required Color color,
      @required String image,
      Key key}) {
    this.name = name;
    this.color = color;
    this.image = image;
    this.key = key;
  }

  dynamic toJson() =>
      {'name': name, 'color': color.value.toString(), 'image': image};
}
