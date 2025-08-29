import 'package:flutter/material.dart';
import 'package:restaurant_app/model/restaurant.dart';
 
class DetailScreen extends StatelessWidget {
 final Restaurant restaurant;
 
 const DetailScreen({
   super.key,
   required this.restaurant,
 });
 
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text("Restaurant Detail"),
     ),
     body: SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           children: [
             Image.network(
               restaurant.image,
               fit: BoxFit.cover,
             ),
             const SizedBox.square(dimension: 16),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         restaurant.name,
                         style: const TextStyle(fontSize: 18),
                       ),
                       Text(
                         restaurant.address,
                         style: const TextStyle(
                           fontSize: 12,
                         ),
                       ),
                     ],
                   ),
                 ),
                 Row(
                   children: [
                     const Icon(Icons.favorite),
                     const SizedBox.square(dimension: 4),
                     Text(restaurant.like.toString())
                   ],
                 ),
               ],
             ),
             const SizedBox.square(dimension: 16),
             Text(
               restaurant.description,
             ),
           ],
         ),
       ),
     ),
   );
 }
}