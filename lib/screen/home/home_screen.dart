import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/data/api/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<RestaurantListResponse> _futureRestaurantResponse;
  String query = "";

  @override
  void initState() {
    super.initState();
    _futureRestaurantResponse = ApiServices().getRestaurantList();
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
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _futureRestaurantResponse,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              final listOfRestaurant = snapshot.data!.restaurants;
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
