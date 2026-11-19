import 'package:flutter_test/flutter_test.dart';
import 'package:latres_mobile/models/show.dart';

void main() {
  test('parses anime fields from Kitsu attributes', () {
    final anime = Show.fromJson({
      'id': '1',
      'attributes': {
        'titles': {'en_jp': 'Cowboy Bebop'},
        'posterImage': {'medium': 'poster.jpg'},
        'coverImage': {'large': 'cover.jpg'},
        'averageRating': '82.28',
        'ageRating': 'R',
        'episodeCount': 26,
        'synopsis': 'A space western.',
      },
    });

    expect(anime.id, 1);
    expect(anime.name, 'Cowboy Bebop');
    expect(anime.posterImage, 'poster.jpg');
    expect(anime.coverImage, 'cover.jpg');
    expect(anime.rating, 8.228);
    expect(anime.ageRating, 'R');
    expect(anime.episodeCount, 26);
    expect(anime.synopsis, 'A space western.');
  });

  test('rejects anime records without a numeric ID', () {
    expect(
      () => Show.fromJson({
        'id': 'not-an-id',
        'attributes': const <String, dynamic>{},
      }),
      throwsFormatException,
    );
  });
}
