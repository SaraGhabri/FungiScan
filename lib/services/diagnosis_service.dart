import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class DiagnosisService {
  // Use localhost for web, 10.0.2.2 for Android emulator
  static final String baseUrl =
      kIsWeb ? 'http://localhost:5000' : 'http://192.168.243.117:5000';

  Future<Map<String, double>> getDiagnosis(String imagePath) async {
    try {
      final Uri url = Uri.parse('$baseUrl/predict');
      final request = http.MultipartRequest('POST', url);

      if (kIsWeb) {
        // For web, we need to handle File differently
        final bytes = await File(imagePath).readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: 'image.jpg',
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath('image', imagePath),
        );
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Map<String, double>.from(jsonDecode(responseData));
      } else {
        throw Exception('Failed to get diagnosis: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      print('Error getting diagnosis: $e');
      return {};
    }
  }
}
