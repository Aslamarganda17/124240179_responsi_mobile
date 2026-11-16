import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/favorite_show.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<FavoriteShow>('favorites');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Favorit',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<FavoriteShow> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Belum ada favorit'));
          }
          final favorites = box.values.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final fav = favorites[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(showId: fav.id),
                      ),
                    );
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: fav.image != null
                        ? Image.network(
                            fav.image!,
                            width: 40,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          )
                        : const Icon(Icons.movie),
                  ),
                  title: Text(
                    fav.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(fav.rating?.toString() ?? '-'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFFF44336)),
                    onPressed: () => box.delete(fav.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
