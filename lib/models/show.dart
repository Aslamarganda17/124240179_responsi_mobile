class Show {
  final int id;
  final String name;
  final String? imageMedium;
  final String? imageOriginal;
  final double? rating;
  final List<String> genres;
  final String summary;

  Show({
    required this.id,
    required this.name,
    this.imageMedium,
    this.imageOriginal,
    this.rating,
    required this.genres,
    required this.summary,
  });

  // factory constructor (Modul 5 bagian G)
  factory Show.fromJson(Map<String, dynamic> json) {
    final image = json['image'] as Map<String, dynamic>?;
    final ratingMap = json['rating'] as Map<String, dynamic>?;

    return Show(
      id: json['id'],
      name: json['name'] ?? '-',
      imageMedium: image?['medium'],
      imageOriginal: image?['original'],
      rating: (ratingMap?['average'] as num?)?.toDouble(),
      genres: List<String>.from(json['genres'] ?? []),
      summary: _stripHtml(json['summary'] ?? ''),
    );
  }

  // summary dari TVMaze berupa HTML (<p>, <b>, dst), kita bersihkan
  static String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}
