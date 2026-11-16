import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../api/api_service.dart';
import '../models/favorite_show.dart';
import '../models/show.dart';

class DetailScreen extends StatefulWidget {
  final int showId;
  const DetailScreen({super.key, required this.showId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Show? show;
  bool isLoading = true;
  String? errorMessage;

  final Box<FavoriteShow> favBox = Hive.box<FavoriteShow>('favorites');

  Future<void> fetchShow() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await ApiService.getSingleShow(widget.showId);
      setState(() {
        show = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat detail.';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchShow();
  }

  // key Hive = id show, jadi gampang cek & hapus
  void _toggleFavorite(Show s) {
    if (favBox.containsKey(s.id)) {
      favBox.delete(s.id);
      _snack('Dihapus dari favorit');
    } else {
      favBox.put(
        s.id,
        FavoriteShow(
          id: s.id,
          name: s.name,
          image: s.imageMedium ?? s.imageOriginal,
          rating: s.rating,
        ),
      );
      _snack('Ditambahkan ke favorit');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail', style: TextStyle(fontSize: 16))),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(errorMessage!),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: fetchShow,
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                )
              : _buildContent(show!),
    );
  }

  Widget _buildContent(Show s) {
    final img = s.imageOriginal ?? s.imageMedium;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (img != null)
            Image.network(
              img,
              width: double.infinity,
              height: 420,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 420,
                child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
              ),
            )
          else
            const SizedBox(
              height: 300,
              width: double.infinity,
              child: Icon(Icons.movie, size: 64, color: Colors.grey),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(s.rating?.toString() ?? '-'),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  s.genres.isEmpty ? '-' : s.genres.join(', '),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // tombol favorit (reaktif terhadap Hive box)
                ValueListenableBuilder(
                  valueListenable: favBox.listenable(keys: [s.id]),
                  builder: (context, Box<FavoriteShow> box, _) {
                    final isFav = box.containsKey(s.id);
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _toggleFavorite(s),
                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                        label: Text(isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF44336),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  s.summary.isEmpty ? 'Tidak ada deskripsi.' : s.summary,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
