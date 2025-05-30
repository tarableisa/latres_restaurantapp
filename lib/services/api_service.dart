import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_detail.dart';
import '../models/restaurant_list.dart';

class ApiService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  /// GET /list
  Future<List<Restaurant>> getRestaurants() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List restaurants = data['restaurants'];
      return restaurants
          .map<Restaurant>((r) => Restaurant.fromJson(r))
          .toList();
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  /// GET /search?q=<query>
  Future<List<Restaurant>> searchRestaurants(String query) async {
    final response =
        await http.get(Uri.parse('$baseUrl/search?q=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List restaurants = data['restaurants'];
      return restaurants
          .map<Restaurant>((r) => Restaurant.fromJson(r))
          .toList();
    } else {
      throw Exception('Failed to search restaurants');
    }
  }

  /// GET /detail/:id
  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/detail/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return RestaurantDetail.fromJson(jsonData['restaurant']);
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  /// POST /review
  Future<bool> addReview(String id, String name, String review) async {
    final response = await http.post(
      Uri.parse('$baseUrl/review'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': id,
        'name': name,
        'review': review,
      }),
    );
    return response.statusCode == 200;
  }
}