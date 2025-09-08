import 'dart:convert';

import 'package:restaurant_app/data/model/restaurant_detail_list_response.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

class ApiServices {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";

  Future<Result<RestaurantListResponse>> getRestaurantList() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/list"));

      if (response.statusCode == 200) {
        return Success(RestaurantListResponse.fromJson(jsonDecode(response.body)));
      } else {
        return Failure('Failed to load restaurant list: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        return Failure('No Internet Connection. Please try again later.');
      } else if (e is TimeoutException) {
        return Failure('Request timed out. Please try again later.');
      } else if (e is FormatException) {
        return Failure('Failed to load response data.');
      } else {
        return Failure("Caught an error: $e");
      }
    }
  }

  Future<Result<RestaurantDetailResponse>> getRestaurantDetail(String id) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

      if (response.statusCode == 200) {
        return Success(RestaurantDetailResponse.fromJson(jsonDecode(response.body)));
      } else {
        return Failure('Failed to load restaurant detail: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        return Failure('No Internet Connection. Please try again later.');
      } else if (e is TimeoutException) {
        return Failure('Request timed out. Please try again later.');
      } else if (e is FormatException) {
        return Failure('Failed to load response data.');
      } else {
        return Failure("Caught an error: $e");
      }
    }
  }

  Future<Result<RestaurantListResponse>> searchRestaurant(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final response = await http.get(
        Uri.parse("$_baseUrl/search?q=$encodedQuery"),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check if the API returned an error
        if (responseData['error'] == true) {
          return Failure(responseData['message'] ?? 'Search failed');
        }

        return Success(RestaurantListResponse.fromJson(responseData));
      } else {
        return Failure("Failed to search restaurant: ${response.statusCode}");
      }
    } catch (e) {
      if (e is SocketException) {
        return Failure('No Internet Connection. Please try again later.');
      } else if (e is TimeoutException) {
        return Failure('Request timed out. Please try again later.');
      } else if (e is FormatException) {
        return Failure('Failed to load response data.');
      } else {
        return Failure("Caught an error: $e");
      }
    }
  }
}

sealed class Result<S> {
 const Result();
}
 
class Success<S> extends Result<S> {
 const Success(this.value);
 final S value;
}
 
class Failure<S> extends Result<S> {
 const Failure(this.error);
 final String error;
}