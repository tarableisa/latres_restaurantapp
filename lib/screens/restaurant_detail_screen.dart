// lib/screens/restaurant_detail_screen.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/restaurant_detail.dart';
import '../services/fav_db_service.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final ApiService _api = ApiService();
  final FavDbService _db = FavDbService();

  late Future<RestaurantDetail> _futureDetail;
  bool _isFav = false;
  late String _id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ambil ID yang dikirim via Navigator
    _id = ModalRoute.of(context)!.settings.arguments as String;
    _futureDetail = _api.getRestaurantDetail(_id);
    // Cek status favorit segera saat widget terpasang
    _db.isFavorite(_id).then((v) {
      if (mounted) setState(() => _isFav = v);
    });
  }

  Future<void> _toggleFav(RestaurantDetail detail) async {
    if (_isFav) {
      await _db.removeFavorite(_id);
      setState(() => _isFav = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dihapus dari favorit'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      await _db.addFavorite(detail);
      setState(() => _isFav = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ditambahkan ke favorit'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RestaurantDetail>(
      future: _futureDetail,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final detail = snap.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Restaurant'),
            leading: BackButton(onPressed: () {
              Navigator.pop(context);
            }),
            actions: [
              IconButton(
                icon: Icon(
                  _isFav ? Icons.favorite : Icons.favorite_border,
                  color: _isFav ? Colors.red : null,
                ),
                onPressed: () {
                  _toggleFav(detail).then((_) {
                    // Setelah toggle, biar halaman favorit reload nanti
                  });
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar besar
                Image.network(
                  'https://restaurant-api.dicoding.dev/images/large/${detail.pictureId}',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 12),

                // Nama
                Text(
                  detail.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),

                // Kota & alamat
                Text('${detail.city}, ${detail.address}'),
                const SizedBox(height: 8),

                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, size: 20, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(detail.rating.toString()),
                  ],
                ),
                const SizedBox(height: 16),

                // Kategori
                Text(
                  'Kategori: ${detail.categories.join(', ')}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Menu
                Text(
                  'Menu Makanan: ${detail.foods.join(', ')}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Menu Minuman: ${detail.drinks.join(', ')}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Customer Reviews
                Text(
                  'Review Pelanggan:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...detail.customerReviews.map(
                  (r) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(r.name),
                      subtitle: Text(r.review),
                      trailing: Text(r.date),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Deskripsi
                Text(
                  'Deskripsi:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(detail.description),
              ],
            ),
          ),
        );
      },
    );
  }
}
