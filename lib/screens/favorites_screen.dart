import 'package:flutter/material.dart';
import '../services/fav_db_service.dart';
import '../models/restaurant_detail.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavDbService _db = FavDbService();
  late Future<List<RestaurantDetail>> _futureFav;

  @override
  void initState() {
    super.initState();
    _futureFav = _db.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: FutureBuilder<List<RestaurantDetail>>(
        future: _futureFav,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(child: Text('Belum ada favorit'));
          }

          final favs = snap.data!;
          return ListView.builder(
            itemCount: favs.length,
            itemBuilder: (ctx, i) {
              final r = favs[i];
              return ListTile(
                leading: Image.network(
                  'https://restaurant-api.dicoding.dev/images/small/${r.pictureId}',
                  width: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(r.name),
                subtitle: Text('${r.city} • ⭐ ${r.rating}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _db.removeFavorite(r.id);
                    setState(() => _futureFav = _db.getFavorites());
                  },
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/detail', arguments: r.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
