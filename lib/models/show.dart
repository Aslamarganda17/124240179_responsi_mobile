class Show {
  final int id;
  final String name;
  final String? posterImage;
  final String? coverImage;
  final double? rating;
  final String? ageRating;
  final int? episodeCount;
  final String synopsis;

  const Show({
    required this.id,
    required this.name,
    this.posterImage,
    this.coverImage,
    this.rating,
    this.ageRating,
    this.episodeCount,
    required this.synopsis,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>? ?? const {};
    final titles = attributes['titles'] as Map<String, dynamic>? ?? const {};
    final poster =
        attributes['posterImage'] as Map<String, dynamic>? ?? const {};
    final cover = attributes['coverImage'] as Map<String, dynamic>? ?? const {};
    final averageRating = _number(attributes['averageRating']);
    final id = int.tryParse(json['id'].toString());

    if (id == null) {
      throw const FormatException('ID anime Kitsu tidak valid.');
    }

    return Show(
      id: id,
      name: (titles['en_jp'] ??
              titles['en'] ??
              attributes['canonicalTitle'] ??
              attributes['slug'] ??
              'Tanpa judul')
          .toString(),
      posterImage: poster['medium']?.toString() ??
          poster['small']?.toString() ??
          poster['tiny']?.toString(),
      coverImage: cover['large']?.toString() ??
          cover['small']?.toString() ??
          cover['tiny']?.toString(),
      rating: averageRating == null ? null : averageRating / 10,
      ageRating: attributes['ageRating']?.toString(),
      episodeCount: _integer(attributes['episodeCount']),
      synopsis: attributes['synopsis']?.toString().trim() ?? '',
    );
  }

  static double? _number(Object? value) {
    if (value is num) return value.toDouble();
    return value == null ? null : double.tryParse(value.toString());
  }

  static int? _integer(Object? value) {
    if (value is int) return value;
    return value == null ? null : int.tryParse(value.toString());
  }
}
