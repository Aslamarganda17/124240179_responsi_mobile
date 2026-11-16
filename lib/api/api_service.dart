import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/show.dart';

/// Semua urusan fetch & parse API dipisah dari UI di sini.
class ApiService {
  static const String apiUrl = 'https://api.tvmaze.com/shows';

  // GET https://api.tvmaze.com/shows
  static Future<List<Show>> getShows() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Show.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load shows');
    }
  }

  // GET https://api.tvmaze.com/shows/{id}
  static Future<Show> getSingleShow(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      return Show.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load show detail');
    }
  }
}
