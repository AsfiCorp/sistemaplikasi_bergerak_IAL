import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final String apiKey = 'GEOBK3KD6D2S6FL9eczyrhiLSg86NxbC110plYNf29MT5rh0JSPW5no7';
  final String query = 'vintage jeans';

  final url = Uri.parse(
      'https://api.pexels.com/v1/search?query=\${Uri.encodeComponent(query)}&per_page=1');

  print('Menembak Pexels API: \$url');
  
  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': apiKey,
      },
    );
    print('Status Code: \${response.statusCode}');
    if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['photos'] != null && (data['photos'] as List).isNotEmpty) {
            print('Success! Sample Image URL: \${data['photos'][0]['src']['portrait']}');
        }
    } else {
        print('Error Body: \${response.body}');
    }
  } catch (e) {
    print('Exception: \$e');
  }
}
