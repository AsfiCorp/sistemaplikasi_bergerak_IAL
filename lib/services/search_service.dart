import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchService {
  // Ganti placeholder ini dengan API Key asli dari Pexels
  final String apiKey = 'GEOBK3KD6D2S6FL9eczyrhiLSg86NxbC110plYNf29MT5rh0JSPW5no7';

  Future<List<String>> searchPinterestImages(String query) async {
    final url = Uri.parse(
        'https://api.pexels.com/v1/search?query=${Uri.encodeComponent(query)}&per_page=20');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': apiKey,
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['photos'] != null) {
          final items = data['photos'] as List;
          // Mengambil gambar dengan ukuran 'portrait' agar cocok dengan UI bergaya Pinterest
          return items.map((item) => item['src']['portrait'] as String).toList();
        }
        return [];
      } else {
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search API Error: $e');
    }
  }
}
