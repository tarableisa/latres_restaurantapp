// lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import '../services/fav_db_service.dart';
import '../models/restaurant_detail.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavDbService db = FavDbService();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: FutureBuilder<List<RestaurantDetail>>(
        // 🔥 Panggil langsung agar selalu fresh
        future: db.getFavorites(),
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
                    await db.removeFavorite(r.id);
                    // Karena FutureBuilder akan rebuild otomatis setelah pop,
                    // kita cukup memanggil setState di sini via Navigator.pop.
                    // Setelah dihapus, kita refresh layar dengan pushReplacement:
                    Navigator.pushReplacementNamed(context, '/fav');
                  },
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/detail', arguments: r.id).then(
                      (_) => Navigator.pushReplacementNamed(context, '/fav'));
                },
              );
            },
          );
        },
      ),
    );
  }
}
