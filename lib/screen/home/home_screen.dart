import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = "";
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

     Future.microtask(() {
     context.read<RestaurantListProvider>().fetchRestaurantList();
   });

  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
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
              // onChanged: _searchRestaurant,
            ),
          ),
        ),
      ),
      body: 
      Consumer<RestaurantListProvider>(
        builder: (context,value,child){
          return switch (value.resultState){
            RestaurantListLoadingState()=> const Center(
              child: CircularProgressIndicator(),
            ),
            RestaurantListLoadedState(data:var restauranList)=> ListView.builder(
              itemCount: restauranList.length,
              itemBuilder: (context,index){
                final restaurant = restauranList[index];
                return RestaurantCard(restaurant: restaurant,
                 onTap: () {
                     Navigator.pushNamed(
                       context,
                       NavigationRoute.detailRoute.name,
                       arguments: restaurant.id,
                     );
                   },);
              }
              ),
              RestaurantListErrorState(error: var message) => Center(
               child: Text(message),
             ),
           _ => const SizedBox(),
          };
        },
      )
    );
  }
}
