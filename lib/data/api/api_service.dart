import 'dart:convert';
 
 import 'package:restaurant_app/data/model/restaurant_detail_list_response.dart';
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
 Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
   final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));
 
 
   if (response.statusCode == 200) {
     return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
   } else {
     throw Exception('Failed to load restaurant detail');
   }
 }

 Future<RestaurantListResponse> searchRestaurant(String query) async {
  final encodedQuery = Uri.encodeComponent(query);
  final response = await http.get(
      Uri.parse("$_baseUrl/search?q=$encodedQuery"));
  
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    
    // Check if the API returned an error
    if (responseData['error'] == true) {
      throw Exception(responseData['message'] ?? 'Search failed');
    }
    
    return RestaurantListResponse.fromJson(responseData);
  } else {
    throw Exception("Failed to search restaurant: ${response.statusCode}");
  }
}

}