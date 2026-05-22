import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final String apiKey = 'AIzaSyATMry8WzTS7Y-lI9NzhvYx3nNHReDGSEc';
  final String cxId = '4001d4f35b216497c';
  final String query = 'vintage jeans';

  final url = Uri.parse(
      'https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=$cxId&searchType=image&q=${Uri.encodeComponent(query)}');

  print('Menembak URL: \$url');
  
  try {
    final response = await http.get(url);
    print('Status Code: \${response.statusCode}');
    print('Response Body: \${response.body}');
  } catch (e) {
    print('Exception: \$e');
  }
}
