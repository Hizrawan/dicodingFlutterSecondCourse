import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<RestaurantListResponse> _futureRestaurantResponse;
  String query = "";
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _futureRestaurantResponse = ApiServices().getRestaurantList();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _searchRestaurant(String input) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        query = input.trim();
        if (query.isEmpty) {
          // Kalau query kosong, ambil semua restaurant
          _futureRestaurantResponse = ApiServices().getRestaurantList();
        } else {
          // Panggil API search
          _futureRestaurantResponse = ApiServices().searchRestaurant(query);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant List"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search restaurant...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _searchRestaurant,
            ),
          ),
        ),
      ),
      body: FutureBuilder<RestaurantListResponse>(
        future: _futureRestaurantResponse,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        "Error: ${snapshot.error.toString()}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _futureRestaurantResponse = query.isEmpty 
                                ? ApiServices().getRestaurantList()
                                : ApiServices().searchRestaurant(query);
                          });
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }
              final listOfRestaurant = snapshot.data?.restaurants ?? [];
              if (listOfRestaurant.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        query.isEmpty 
                            ? "No restaurants available" 
                            : "No restaurants found for '$query'",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: listOfRestaurant.length,
                itemBuilder: (context, index) {
                  final restaurant = listOfRestaurant[index];
                  return RestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.detailRoute.name,
                        arguments: restaurant.id,
                      );
                    },
                  );
                },
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
