import 'package:flutter/material.dart';

enum RestaurantColors {
  red("red", Color.fromARGB(255, 182, 19, 19));

  const RestaurantColors(this.name, this.color);

  final String name;
  final Color color;
}