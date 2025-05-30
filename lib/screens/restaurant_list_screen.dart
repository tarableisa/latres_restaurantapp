import 'package:flutter/material.dart';
import '../models/restaurant_list.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'favorites_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final ApiService _api = ApiService();
  final AuthService _auth = AuthService();
  late Future<List<Restaurant>> _future;
  String _filterCategory = '';

  @override
  void initState() {
    super.initState();
    _future = _api.getRestaurants();
  }

  void _applyFilter(String cat) {
    setState(() {
      _filterCategory = cat;
      if (cat.isEmpty) {
        _future = _api.getRestaurants();
      } else {
        _future = _api.searchRestaurants(cat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _auth.getUsername(),
      builder: (ctx, snapUser) {
        final user = snapUser.data ?? 'Guest';
        return Scaffold(
          appBar: AppBar(
            title: Text('Hello, $user'),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  );
                },
              )
            ],
          ),
          body: Column(
            children: [
              // Dropdown filter kategori
              Padding(
                padding: const EdgeInsets.all(8),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Filter kategori'),
                  value: _filterCategory.isEmpty ? null : _filterCategory,
                  items: const [
                    DropdownMenuItem(value: '', child: Text('Semua')),
                    DropdownMenuItem(value: 'Modern', child: Text('Modern')),
                    DropdownMenuItem(
                        value: 'Traditional', child: Text('Traditional')),
                  ],
                  onChanged: (v) => _applyFilter(v ?? ''),
                ),
              ),

              // List restoran
              Expanded(
                child: FutureBuilder<List<Restaurant>>(
                  future: _future,
                  builder: (ctx, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snap.hasError) {
                      return Center(child: Text('Error: ${snap.error}'));
                    } else if (!snap.hasData || snap.data!.isEmpty) {
                      return const Center(child: Text('Tidak ada data'));
                    }

                    final list = snap.data!;
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final r = list[i];
                        return ListTile(
                          leading: Image.network(
                            'https://restaurant-api.dicoding.dev/images/small/${r.pictureId}',
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(r.name),
                          subtitle: Text('${r.city} • ⭐ ${r.rating}'),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: r.id,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
