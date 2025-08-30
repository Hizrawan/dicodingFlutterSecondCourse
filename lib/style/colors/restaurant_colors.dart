import 'package:flutter/material.dart';

enum RestaurantColors {
  blue("Blue", Color(0xFF0D47A1));

  const RestaurantColors(this.name, this.color);

  final String name;
  final Color color;
}