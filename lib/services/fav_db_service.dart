import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/restaurant_detail.dart';

class FavDbService {
  static const _key = 'favorite_restaurants';

  // Ambil semua favorit
  Future<List<RestaurantDetail>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((r) => RestaurantDetail.fromMap(r)).toList();
  }

  // Simpan semua favorit
  Future<void> _saveFavorites(List<RestaurantDetail> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(favorites.map((r) => r.toMap()).toList());
    await prefs.setString(_key, jsonString);
  }

  // Tambah favorit
  Future<void> addFavorite(RestaurantDetail r) async {
    final favorites = await getFavorites();
    if (!favorites.any((item) => item.id == r.id)) {
      favorites.add(r);
      await _saveFavorites(favorites);
    }
  }

  // Hapus favorit
  Future<void> removeFavorite(String id) async {
    final favorites = await getFavorites();
    favorites.removeWhere((item) => item.id == id);
    await _saveFavorites(favorites);
  }

  // Cek apakah ID favorit
  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item.id == id);
  }
}
