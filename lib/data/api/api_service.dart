import 'dart:convert';
 
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:http/http.dart' as http;
 
class ApiServices {
 static const String _baseUrl = "https://restaurant-api.dicoding.dev";
 
 Future<RestaurantListResponse> getRestaurantList() async {
   final response = await http.get(Uri.parse("$_baseUrl/list"));
 
   if (response.statusCode == 200) {
     return RestaurantListResponse.fromJson(jsonDecode(response.body));
   } else {
     throw Exception('Failed to load restaurant list');
   }
 }
}