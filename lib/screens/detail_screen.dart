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
      if (!mounted) return;
      setState(() {
        show = data;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Gagal memuat detail anime. Cek koneksi internet.';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchShow();
  }

  void _toggleFavorite(Show anime) {
    if (favBox.containsKey(anime.id)) {
      favBox.delete(anime.id);
      _showMessage('Dihapus dari favorit');
    } else {
      favBox.put(
        anime.id,
        FavoriteShow(
          id: anime.id,
          name: anime.name,
          image: anime.posterImage,
          rating: anime.rating,
        ),
      );
      _showMessage('Ditambahkan ke favorit');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
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

  Widget _buildContent(Show anime) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 230,
            width: double.infinity,
            child: anime.coverImage != null
                ? Image.network(
                    anime.coverImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _coverPlaceholder(),
                  )
                : _coverPlaceholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anime.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _metadata(
                      Icons.star,
                      anime.rating?.toStringAsFixed(1) ?? '-',
                      color: Colors.amber,
                    ),
                    _metadata(Icons.child_care, anime.ageRating ?? 'NR'),
                    _metadata(
                      Icons.movie_outlined,
                      '${anime.episodeCount ?? '-'} Episode',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showMessage(
                          'Fitur nonton belum tersedia.',
                        ),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Nonton'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5722),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ValueListenableBuilder(
                      valueListenable: favBox.listenable(keys: [anime.id]),
                      builder: (context, Box<FavoriteShow> box, _) {
                        final isFavorite = box.containsKey(anime.id);
                        return IconButton.filled(
                          tooltip: isFavorite
                              ? 'Hapus dari favorit'
                              : 'Tambah ke favorit',
                          onPressed: () => _toggleFavorite(anime),
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF2C2C2E),
                            foregroundColor: const Color(0xFFFF5722),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sinopsis',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  anime.synopsis.isEmpty
                      ? 'Sinopsis tidak tersedia.'
                      : anime.synopsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _coverPlaceholder() {
    return const ColoredBox(
      color: Color(0xFF1C1C1E),
      child: Center(
        child: Icon(Icons.movie, size: 64, color: Colors.white38),
      ),
    );
  }

  Widget _metadata(IconData icon, String value,
      {Color color = Colors.white70}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 5),
        Text(value, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
