import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiService {
  static const String apiKey = 'AIzaSyBNRi0l7_vPwfPRhomXk-LMJ4QxbkbPk-g';
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  Future<String> getRecommendations(String disease) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'Give me treatment recommendations for plant disease: $disease. Keep it concise and practical.'
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception(
            'Failed to get recommendations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting recommendations: $e');
      return 'Unable to get recommendations at this time.';
    }
  }
}
