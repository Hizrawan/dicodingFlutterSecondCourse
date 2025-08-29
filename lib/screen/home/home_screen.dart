import 'package:flutter/material.dart';
import 'package:restaurant_app/model/restaurant.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/NavigationRoute.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant List"),
      ),
      body: ListView.builder(
        itemCount: restaurantList.length,
        itemBuilder: (context, index) {
          final restaurant = restaurantList[index];

          return RestaurantCard(
            restaurant: restaurant,
            onTap: () {
              Navigator.pushNamed(
                context,
                NavigationRoute.detailRoute.name,
                arguments: restaurant,
              );
            },
          );
        },
      ),
    );
  }
}