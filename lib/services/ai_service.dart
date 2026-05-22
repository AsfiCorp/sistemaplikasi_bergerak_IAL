import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/clothing_item.dart';

class AiService {
  final String _apiKey = 'AIzaSyA7JVAntd8fYfVjXnI5U1SqD7emAiPI-uk';

  AiService();

  Future<List<String>> generateOutfitIds(String userPrompt, List<ClothingItem> wardrobe) async {
    try {
      // 1. Format wardrobe into minimal JSON string
      final List<Map<String, String>> minimalWardrobe = wardrobe.map((item) {
        return {
          'id': item.id,
          'category': item.category,
          'material': item.material,
          'title': item.title,
        };
      }).toList();
      
      final String wardrobeJson = jsonEncode(minimalWardrobe);

      // 2. Construct System Prompt
      final prompt = '''
Kamu adalah penata gaya. Lemari user: $wardrobeJson. User meminta: '$userPrompt'. 
Pilih 1 Tops, 1 Bottoms, (opsional Outerwear). 
RETURN STRICTLY ONLY A RAW JSON ARRAY OF STRINGS CONTAINING ITEM IDS. NO MARKDOWN, NO EXPLANATION, NO CODE BLOCKS, JUST THE ARRAY LIKE ["id1", "id2"].
''';

      // 3. Call Gemini
      print('🔑 API Key terisi: ${_apiKey.isNotEmpty}');
      final content = [Content.text(prompt)];
      
      GenerateContentResponse? response;
      try {
        final model = GenerativeModel(model: 'gemini-flash-latest', apiKey: _apiKey);
        response = await model.generateContent(content);
      } catch (e) {
        throw e;
      }

      final responseText = response.text;

      if (responseText == null || responseText.isEmpty) {
        return [];
      }

      // 4. Parse the response
      String rawText = responseText ?? '[]';
      // Bersihkan markdown code blocks jika AI masih membandel
      rawText = rawText.replaceAll(RegExp(r'```json\n?'), '').replaceAll(RegExp(r'```'), '').trim();

      // Cari index kurung siku untuk memastikan kita hanya mengambil array-nya
      int startIndex = rawText.indexOf('[');
      int endIndex = rawText.lastIndexOf(']');

      if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
          String jsonArrayString = rawText.substring(startIndex, endIndex + 1);
          List<dynamic> decoded = jsonDecode(jsonArrayString);
          return decoded.map((e) => e.toString()).toList();
      } else {
          throw Exception('Valid JSON array not found in AI response');
      }

    } catch (e) {
      print('🔴 ERROR GEMINI: $e');
      throw e;
    }
  }
}
