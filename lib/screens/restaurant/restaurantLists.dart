import 'package:flutter/material.dart';
import 'restaurantDetails.dart';
import '../../models/restaurant.dart';

class RestaurantLists extends StatelessWidget {
  const RestaurantLists({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: restaurantList.length,
      itemBuilder: (context, index) {
        final restaurant = restaurantList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF2d3e50),
              child: Text(restaurant.title[0], style: const TextStyle(color: Colors.white)),
            ),
            title: Text(restaurant.title),
            subtitle: Text(restaurant.category),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailPage(restaurant: restaurant),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
