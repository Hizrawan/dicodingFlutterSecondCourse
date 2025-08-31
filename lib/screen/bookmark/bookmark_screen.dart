import 'package:flutter/material.dart';
import 'package:restaurant_app/model/restaurant.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmark List"),
      ),
      body: ListView.builder(
          itemCount: bookmarkRestaurantList.length,
          itemBuilder: (context, index) {
            final restaurant = bookmarkRestaurantList[index];
            return RestaurantCard(
              restaurant: restaurant,
              onTap: (){
                Navigator.pushNamed(
                  context,
                  NavigationRoute.detailRoute.name,
                  arguments: restaurant,
                );
              },
              );
          },
        )
    );
  }
}