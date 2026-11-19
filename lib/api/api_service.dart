import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/show.dart';

class ApiService {
  static const String _baseUrl = 'https://kitsu.io/api/edge/anime';
  static const Map<String, String> _headers = {
    'Accept': 'application/vnd.api+json',
  };

  static Future<List<Show>> getShows() async {
    final uri = Uri.https('kitsu.io', '/api/edge/anime', {
      'page[limit]': '20',
      'page[offset]': '0',
    });
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat daftar anime (${response.statusCode}).');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    return data
        .map((item) => Show.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<Show> getSingleShow(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$id'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail anime (${response.statusCode}).');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return Show.fromJson(body['data'] as Map<String, dynamic>);
  }
}
