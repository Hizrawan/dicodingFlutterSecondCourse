import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/auth/auth_provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';

class BodyOfDetailScreenWidget extends StatelessWidget {
  const BodyOfDetailScreenWidget({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  Future<void> _addReviewDialog(BuildContext context, String restaurantId) async {
    final authProvider = context.read<AuthProvider>();
    final nameController = TextEditingController(text: authProvider.username ?? '');
    final reviewController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Review"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: reviewController,
              decoration: const InputDecoration(labelText: "Review"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final review = reviewController.text.trim();
              if (name.isEmpty || review.isEmpty) return;

              final response = await http.post(
                Uri.parse("https://restaurant-api.dicoding.dev/review"),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({
                  "id": restaurantId,
                  "name": name,
                  "review": review,
                }),
              );

              if (response.statusCode == 200 || response.statusCode == 201) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Review submitted!")),
                );
                // Refresh the restaurant detail to show the new review
                context.read<RestaurantDetailProvider>().fetchRestaurantDetail(restaurantId);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          "Failed to submit review: ${response.statusCode}")),
                );
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount =
        MediaQuery.of(context).size.width > 600 ? 3 : 2; // responsive

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Hero(
              tag: restaurant.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  restaurant.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name, city, rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        "${restaurant.city} • ${restaurant.address ?? "-"}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.rating.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              restaurant.description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            // Categories
            if (restaurant.categories.isNotEmpty)
              Wrap(
                spacing: 8,
                children: restaurant.categories
                    .map((c) => Chip(label: Text(c.name)))
                    .toList(),
              ),
            if (restaurant.categories.isNotEmpty) const SizedBox(height: 24),

            // Foods Grid
            if (restaurant.menus.foods.isNotEmpty) ...[
              Text("Foods", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: restaurant.menus.foods.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final food = restaurant.menus.foods[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          food.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],

            // Drinks Grid
            if (restaurant.menus.drinks.isNotEmpty) ...[
              Text("Drinks", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: restaurant.menus.drinks.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final drink = restaurant.menus.drinks[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          drink.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],

            // Reviews
            if (restaurant.customerReviews.isNotEmpty) ...[
              Text("Customer Reviews",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Column(
                children: restaurant.customerReviews.map((review) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(review.name),
                      subtitle: Text(review.review),
                      trailing: Text(
                        review.date,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            // Add Review Button
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _addReviewDialog(context, restaurant.id),
                icon: const Icon(Icons.add_comment),
                label: const Text("Add Review"),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
