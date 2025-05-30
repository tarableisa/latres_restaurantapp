import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/restaurant_list_screen.dart';
import 'screens/restaurant_detail_screen.dart';
import 'screens/favorites_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: 'Dicoding Restaurant App',
      theme: ThemeData(useMaterial3: true),
      // Ubah initialRoute jadi '/login'
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/list': (_) => RestaurantListScreen(),
        '/fav': (_) => FavoritesScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final id = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => RestaurantDetailScreen(),
            settings: RouteSettings(arguments: id),
          );
        }
        return null;
      },
    );
  }
}
