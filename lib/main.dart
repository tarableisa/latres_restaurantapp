import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/restaurant_list_screen.dart';
import 'screens/restaurant_detail_screen.dart';
import 'screens/favorites_screen.dart';
import 'models/restaurant_list.dart'; // jika kamu butuh objek restaurant

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
        title: 'Dicoding Restaurant App',
        theme: ThemeData(useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (_) => LoginScreen(),
          '/list': (_) => RestaurantListScreen(),
          '/fav': (_) => FavoritesScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            final id = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => RestaurantDetailScreen(), // tetap sama
              settings:
                  RouteSettings(arguments: id), // agar _id tetap bisa diakses
            );
          }
          return null;
        });
  }
}
